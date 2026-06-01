# Uzbek Novel Psych Verbs — Children and LLMs

Data, materials, and analysis code for the MA thesis:

> **"Argument Linking in Children and Large Language Models: Evidence from Uzbek Novel Psych Verbs."**
> Madina Kh., University of Siena, MA in Language and Mind, 2026.
> Supervisor: Prof. Cristiano Chesi.

---

## Citation

If you use these materials, please cite:

```
Kh., Madina (2026). Argument Linking in Children and Large Language Models: Evidence from Uzbek Novel Psych Verbs.
MA Thesis, University of Siena.
GitHub: https://github.com/Madina-Kh/[repo-name]
```

---

## Overview

This repository contains all materials for two empirical studies investigating whether Uzbek-speaking children (ages 4–5) and large language models exhibit similar argument linking patterns for novel psychological verbs.

**Study 1** tested 40 Uzbek-speaking children on a forced-choice novel verb paradigm adapted from Hartshorne et al. (2016). Children were introduced to novel psych verbs (*navamoq*, *payramoq*) in stories framing the psychological state as either a habitual attitude (ES condition) or an emotional episode (EO condition), then asked to choose which animal the verb applied to.

**Study 2** tested five multilingual masked language models (mBERT, XLM-RoBERTa-base, XLM-RoBERTa-large, BERTbek, XLM-V-base) on parallel materials using pseudo-log-likelihood scoring. Testing was conducted in three phases: Uzbek with overt case marker, Uzbek with no overt case marker, and English with no overt case marker.

**Key finding:** Children showed a robust 40.0 pp condition effect (z = 3.17, p = .002). No LLM produced a significant positive condition difference under controlled conditions, supporting the conclusion that distributional learning alone is insufficient to acquire the habitual/episodic mapping.

---

## Repository Structure

```
├── data/
│   └── psych_verbs_children.csv          # Study 1: item-level response data (N=40)
│
├── materials/
│   ├── picture_prompts_with_stories.pdf  # Study 1: full stimulus booklet (Uzbek)
│   ├── uzbek_psych_verbs_COMPLETE_32items.json  # Study 2 Phase 1: overt case marker stimuli
│   ├── uzbek_psych_verbs_FINAL.json             # Study 2 Phase 2: no overt case marker stimuli
│   └── english_psych_verbs_32items.json         # Study 2 English extension stimuli
│
├── code/
│   ├── psych_verbs_analysis_and_plots.R  # Study 1: full analysis + plots (R)
│   ├── testing.R                         # Study 2: Uzbek LLM results analysis (R)
│   └── english.R                         # Study 2: English LLM results analysis (R)
│
├── notebooks/
│   ├── overt_case_all5models.ipynb       # Study 2 Phase 1: Uzbek overt case (all 5 models)
│   ├── without_case_with_plots.ipynb     # Study 2 Phase 2: Uzbek no overt case
│   └── english_psych_verbs_testing.ipynb # Study 2: English extension (4 models)
│
└── README.md
```

---

## Requirements

**Study 1 (R):**
```r
R >= 4.1.0
lme4, lmerTest, sandwich, lmtest, tidyverse
```
Install with:
```r
install.packages(c("lme4", "lmerTest", "sandwich", "lmtest", "tidyverse"))
```

**Study 2 (Python / Google Colab):**
```
Python >= 3.8
transformers >= 4.30.0
torch >= 2.0.0
pandas, matplotlib, seaborn, scipy
```
All notebooks are self-contained and install dependencies automatically when run in Google Colab.

---

## How to Reproduce

### Study 1 — Children

1. Open `code/psych_verbs_analysis_and_plots.R` in RStudio.
2. Set your working directory to the root of this repository.
3. Run the script. It loads `data/psych_verbs_children.csv` and produces:
   - Mixed-effects logistic regression results (GLMM with participant and item random effects)
   - EO preference plots by condition and age group
   - Developmental trajectory plot

### Study 2 — LLMs

Each notebook is independent and self-contained.

**Phase 1 — Uzbek, overt case marker:**
1. Open `notebooks/overt_case_all5models.ipynb` in Google Colab.
2. Upload `materials/uzbek_psych_verbs_COMPLETE_32items.json` when prompted.
3. Click Runtime → Run All. Runtime: ~90 minutes.

**Phase 2 — Uzbek, no overt case marker:**
1. Open `notebooks/without_case_with_plots.ipynb` in Google Colab.
2. Upload `materials/uzbek_psych_verbs_FINAL.json` when prompted.
3. Click Runtime → Run All.

**English extension:**
1. Open `notebooks/english_psych_verbs_testing.ipynb` in Google Colab.
2. Upload `materials/english_psych_verbs_32items.json` when prompted.
3. Click Runtime → Run All. Runtime: ~60 minutes.
4. Note: BERTbek is excluded from the English extension (Uzbek-specific model).

---

## Data

### `data/psych_verbs_children.csv`

Item-level response data from Study 1. Each row is one trial.

| Column | Description |
|---|---|
| `participant_id` | Anonymous participant code (P01–P40) |
| `age_group` | Age group: `4yo` or `5yo` |
| `condition` | Semantic condition: `ES` (habitual) or `EO` (episodic) |
| `semantic_framing` | Framing label: `habitual` or `episodic` |
| `list` | Counterbalancing list: `L1` or `L2` |
| `verb_form` | Novel verb used: `navamoq` or `payramoq` |
| `item_id` | Item number (1–8 per condition) |
| `target_response` | Correct/expected response animal |
| `child_response` | Animal chosen by child |
| `eo_preference` | Binary outcome: `1` = chose EO response, `0` = chose ES response |

**Ethics note:** All participants are identified by anonymous codes only. No identifying information is included. Parental consent was obtained for all participants prior to testing.

### Stimulus files (JSON)

Each JSON file contains a list of items. Each item includes:
- `id`: unique item identifier
- `condition`: `ES` or `EO`
- `verb`: novel verb used
- `verb_definition`: the verb introduction text (Uzbek or English)
- `story_part1`, `story_part2`: the two story vignettes
- `test_question`: the forced-choice question
- `answer_choices`: the two answer options

---

## License

- **Code** (R scripts, Python notebooks): [MIT License](LICENSE)
- **Data and materials** (CSV, JSON, PDF): [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

---

## Contact

Madina Kh.
University of Siena — MA Language and Mind
GitHub: [@Madina-Kh](https://github.com/Madina-Kh)
