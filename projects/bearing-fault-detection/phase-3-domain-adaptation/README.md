## 🔄 Phase 3: Domain Adaptation Solution

### The Challenge
Phase 2 demonstrated complete cross-domain failure (0% recall on healthy bearings). This section shows how transfer learning solves the domain adaptation problem.

### Approach: Transfer Learning with Fine-Tuning

## Kaggle Notebooks

- [Notebook 1: Data preparation](https://www.kaggle.com/code/mouizeddinekisma/1d-cnn-domain-adaptation)

**Confusion Matrix:**

- ![Dashboard first page](<results/Phase-3-Confusion_matrix.png>)

**Strategy:**
- Split CWRU dataset: 20% for adaptation (473 samples), 80% for testing (1,896 samples)
- Freeze convolutional layers (keep learned vibration pattern detection)
- Fine-tune only final dense layers on CWRU training data
- Minimal target domain data requirement

### Results Comparison

| Approach | Healthy Recall | Faulty Recall | Overall Accuracy |
|----------|---------------|---------------|------------------|
| **Phase 2: No Adaptation** | 0% | 99% | 89% |
| **Phase 3: Transfer Learning** | 98% | 100% | 99.7% |


### Key Findings

**Impact of Transfer Learning:**
- Improved healthy bearing detection from 0% to 98% recall
- Maintained high faulty bearing detection (100% recall)
- Required only 473 CWRU samples (20% of available data)

**Why This Matters:**
In industrial deployment, collecting failure data is expensive and time-consuming. This demonstrates that models can be adapted to new equipment with minimal data collection critical for practical Industry 4.0 applications.

### Technical Implementation
- Froze all convolutional layers (pattern detection preserved)
- Retrained final 2 dense layers on CWRU data
- 10 epochs of fine-tuning
- Standard Adam optimizer, binary crossentropy loss

