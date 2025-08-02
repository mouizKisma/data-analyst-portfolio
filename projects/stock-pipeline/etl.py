import os
import yfinance as yf
import pandas as pd
from datetime import datetime, timedelta
from dotenv import load_dotenv
import time
from tenacity import retry, stop_after_attempt, wait_fixed 
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

# Load environment variables
load_dotenv()

#define sqlache engine
#engine = create_engine(os.getenv("DATABASE_URL"))
# Temporary for testing
DATABASE_URL = "postgresql://admin:admin@postgres:5432/stockdb"
engine = create_engine(
    DATABASE_URL,
    # Pool configuration
    poolclass=QueuePool,
    pool_size=5,          # Number of connections to maintain
    max_overflow=10,      # Additional connections beyond pool_size
    pool_pre_ping=True,   # Verify connections before use
    pool_recycle=3600,    # Recycle connections after 1 hour
    
    # Connection arguments for PostgreSQL
    connect_args={
        "connect_timeout": 10,
        "application_name": "stock_etl_app"
    }
)
#run analysis function:
def run_analysis():
    """Run analysis on stock data"""
    run_sql_file("sql/1_base_view.sql")
    run_sql_file("sql/2_daily_metrics_view.sql")
    run_sql_file("sql/3_weekly_metrics_view.sql")
    run_sql_file("sql/4_annual_metrics_view.sql")
    run_sql_file("sql/5_reporting_view.sql")
    run_sql_file("sql/6_reporting_weekly_view.sql")
#run sql files function:
def run_sql_file(file_path):  
    with open(file_path, 'r') as file:
        sql_script = file.read().strip()
    with engine.begin() as connection:
        connection.exec_driver_sql(sql_script)
        print(f"Executed SQL script: {file_path}")

# Function to fetch stock data from Yahoo Finance
@retry(stop=stop_after_attempt(3), wait=wait_fixed(60))
def fetch_stock_data(symbol, days=730):
    """Fetch stock data from Yahoo Finance"""
    end_date = datetime.now()
    start_date = end_date - timedelta(days=days)
    print(f"📡 Fetching {symbol} data from {start_date} to {end_date}")
    return yf.download(symbol, start=start_date, end=end_date,auto_adjust=True, progress=False)

# Function to transform and clean data
def transform_data(data, symbol):
    #check if data is empty
    if data.empty:
        raise ValueError(f"No data found for {symbol} in the specified date range.")
    # Reset index and rename columns
    df = data.reset_index()[['Date', 'Close', 'Volume']]
    df.columns = ['date', 'price', 'volume']  # Lowercase for SQL
    df['symbol'] = symbol
    #df["daily_return"] = df["price"].pct_change()  # Calculate daily returns
    df = df[['symbol', 'date', 'price', 'volume']]
    return df

# Function to load data into PostgreSQL
def load_to_db(df):
    """Load data into PostgreSQL with upsert logic using SQL files"""
    
    # Create temp table
    run_sql_file("sql/create_temp_table.sql")
    
    # Insert data into temp table
    df.to_sql('temp_stock_prices', engine, if_exists='append', index=False)
    
    # Upsert from temp table to main table
    run_sql_file("sql/upsert_stock_data.sql")
    
    print(f"📥 Loaded {len(df)} rows for {df['symbol'].iloc[0]} into the database")
    

def run_etl():
    run_sql_file("sql/create_table.sql")
    symbols = ['AAPL', 'MSFT', 'GOOGL', 'META', 'AMZN', 'NFLX', 'TSLA', 'CRM', 'ORCL', 'NOW', 'SNOW', 'ADBE', 'UBER', 'SPOT', 'PLTR', 'CRWD', 'DDOG', 'MDB', 'TEAM', 'ZM', 'NVDA', 'AMD', 'INTC', 'PYPL', 'RBLX', 'EA']
    
    for symbol in symbols:
        try:
            raw_data = fetch_stock_data(symbol)
            clean_data = transform_data(raw_data, symbol)
            load_to_db(clean_data)
        except Exception as e:
            print(f"⚠️ Failed to process {symbol}: {str(e)}")
    try:
        print("🔄 Running analysis on the loaded data...")
        run_analysis()
    except Exception as e:
        print(f"⚠️ Analysis failed: {str(e)}")
    print("🚀 ETL process completed!")

# In main function:
if __name__ == "__main__":
    try:
        run_etl()
        print("✅ ETL process completed successfully!")
        time.sleep(10)  # Sleep to avoid hitting API limits

    except Exception as e:
        print("❌ ETL process failed!")
        print(f"⚠️ An error occurred: {str(e)}")