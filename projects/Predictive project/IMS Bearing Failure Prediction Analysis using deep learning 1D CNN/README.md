# Predictive Maintenance for Industrial Equipment using 1D CNN
**Identifying Cross-Domain Challenges in Bearing Fault Detection**
- ![Dashboard first page/3](<Output and results/bearing_failure_dashboard.png>)

## Kaggle Notebooks

- [Notebook 1: Data preparation](https://www.kaggle.com/code/mouizeddinekisma/ims-deeplearning-data-prep)
- [Notebook 2: Model Training](https://www.kaggle.com/code/mouizeddinekisma/ims-deeplearning-data-prep-part2)
- [Notebook 3: CWRU data preparation](https://www.kaggle.com/code/mouizeddinekisma/cwru-dataprep)

## 🎯 Project Overview
Modern manufacturing relies on predictive maintenance to prevent costly equipment failures. However, models trained in controlled lab conditions often fail when deployed on different equipment. This project explores this real-world challenge using deep learning on bearing vibration data.

**Key Finding**: A CNN model achieving 99% accuracy on training data (IMS dataset) completely failed when tested on different equipment (CWRU dataset), demonstrating the critical importance of domain adaptation in industrial ML applications.

---

## 💼 Business Context
- **Problem**: Unplanned bearing failures cause millions in downtime costs
- **Solution**: Predict failures before they occur using vibration sensor data
- **Challenge**: Models must work across different machines, not just in the lab
- **Impact**: Understanding why models fail across domains is the first step to building robust production systems

---

## 🔬 Technical Approach

### Datasets
**Training**: IMS Bearing Dataset
- 376,780 vibration samples across 4 bearings
- Run-to-failure experiment under controlled conditions
- Class distribution: 94.5% healthy, 5.5% faulty

**Testing**: CWRU Bearing Dataset  
- 2,369 samples from different bearing types
- Different operating conditions and sensor placement
- Class distribution: 10% healthy, 90% faulty

### Architecture: 1D Convolutional Neural Network
Deep learning approach to automatically learn fault patterns from raw time-series data, eliminating manual feature engineering.

**Key Design Decisions**:
- Window size: 1,000 samples with 50% overlap
- 1D convolutions to detect temporal patterns in vibration signals
- Binary classification: healthy vs. faulty
```
Input (1000 samples) → Conv1D → ReLU → MaxPooling → 
Conv1D → ReLU → MaxPooling → Flatten → Dense → Sigmoid
```

---

## 📊 Results

### Within-Domain Performance (IMS → IMS)
The model did great as it has gotten a recall of .99%

### Cross-Domain Performance (IMS → CWRU)
❌ **Critical Failure Identified**
```
Classification Report:
              precision    recall  f1-score   support

           0       0.00      0.00      0.00       236
           1       0.90      0.99      0.94      2133

    accuracy                           0.89      2369

Confusion Matrix:
[[   0  236]    ← Model missed ALL healthy bearings
 [  20 2113]]
```

**Analysis**:
- Model predicts "faulty" for 99.2% of samples
- 0% recall on healthy bearings (class 0)
- High accuracy (89%) is misleading due to class imbalance
- **Root cause**: Severe domain shift between datasets

---

## 🔍 Key Insights

### 1. Domain Shift is Real
Training and testing on different equipment causes complete model failure, even with high training accuracy. This mirrors real industrial deployment challenges.

**Why Models Fail Across Domains**:
- Different sensor types and placements
- Varying operating speeds and loads  
- Equipment-specific vibration characteristics
- Signal amplitude and noise differences

### 2. Class Imbalance Matters
Training on 94.5% healthy data, then testing on 90% faulty data creates distribution mismatch. The model learned to predict "healthy" by default, which completely fails in fault-heavy test scenarios.

### 3. Accuracy is Misleading
89% accuracy sounds good but hides 0% recall on the minority class. In predictive maintenance, **missing a fault is catastrophic**.

### 4. Data Preprocessing Complexity
- Normalization strategy (per-file vs. global) significantly impacts results
- Window overlap increases training samples but can introduce data leakage
- Chronological ordering causes temporal bias

---

## 🛠️ Technical Implementation

### Data Pipeline
1. **Raw data loading**: Parse IMS text files and CWRU .mat files
2. **Windowing**: Split continuous signals into 1000-sample windows (50% overlap)
3. **Labeling**: Binary labels (0=healthy, 1=faulty) inherited from source files
4. **Normalization**: Tested multiple strategies (per-file, global, min-max)
5. **Train/test split**: IMS for training, CWRU for cross-domain testing

### Model Training
```python
- Optimizer: Adam
- Loss: Binary crossentropy
- Batch size: 32
- Epochs: 50
- Regularization: Dropout layers
```

---

## 📚 What I Learned

### Technical Skills
- Building 1D CNNs for time-series classification in TensorFlow/Keras
- Processing industrial sensor data (.txt, .mat formats)
- Implementing sliding window segmentation with overlap
- Diagnosing model failures through confusion matrices and class-wise metrics
- Understanding the gap between research datasets and production scenarios

### ML Engineering Lessons
- **Training accuracy ≠ deployment performance**
- **Domain shift is the norm, not the exception** in industrial ML
- **Evaluation metrics must match business goals** (recall > accuracy for fault detection)
- **Data exploration prevents wasted training time** (found imbalance before final model)

### Real-World ML Challenges
- Models that work in the lab often fail in production
- Cross-domain generalization requires specialized techniques
- Class imbalance needs proactive handling, not post-hoc fixes

---

## 🚀 Next Steps

### Immediate Improvements
1. **Address Class Imbalance**
   - Implement class weights in loss function
   - Try SMOTE oversampling
   - Adjust decision threshold for minority class

2. **Domain Adaptation**
   - Fine-tune on small labeled CWRU subset
   - Implement domain adversarial training (DANN)
   - Test transfer learning strategies

3. **Model Architecture**
   - Experiment with deeper networks
   - Add batch normalization
   - Try residual connections

### Future Directions
- Multi-source training (combine IMS + CWRU)
- Unsupervised domain adaptation using unlabeled target data
- Feature visualization (t-SNE) to understand domain differences
- Compare with feature-engineering baseline (XGBoost)
- Extend to multi-class fault diagnosis (bearing race, ball, cage faults)

---

## 💻 Technologies Used
- **Python 3.x**: Core programming
- **TensorFlow/Keras**: Deep learning framework
- **NumPy/Pandas**: Data manipulation
- **scikit-learn**: Metrics and preprocessing
- **Matplotlib/Seaborn**: Visualization
- **SciPy**: Signal processing and .mat file handling


---

## 🎓 Key Takeaway
This project demonstrates a critical reality in industrial ML: **models must be validated on target domains, not just held-out test sets from the same distribution**. The 89% accuracy that masks 0% minority class recall is a perfect example of why domain adaptation and proper evaluation metrics are essential for production ML systems.

**This is not a failure — it's a documented learning experience that mirrors real-world ML engineering challenges.**

---

## 📖 References
- IMS Bearing Dataset: [NASA Prognostics Center](https://www.nasa.gov/content/prognostics-center-of-excellence-data-set-repository)
- CWRU Bearing Dataset: [Case Western Reserve University](https://www.kaggle.com/datasets/brjapon/cwru-bearing-datasets)
