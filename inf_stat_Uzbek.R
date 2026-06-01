# ==============================================================================
# SIMPLE STATISTICAL ANALYSIS FOR LLM RESULTS
# ==============================================================================

# STEP 1: Load your data files
# Put your 4 CSV files in the same folder as this R script, then run:

overt_summary <- read.csv("results_overt_case_summary.csv")
no_case_summary <- read.csv("results_no_overt_case_summary.csv")

# STEP 2: Look at what we loaded
cat("=== OVERT CASE (with case markers) ===\n")
print(overt_summary)

cat("\n=== NO CASE (without case markers) ===\n")
print(no_case_summary)

# STEP 3: Run statistics on OVERT CASE
cat("\n", rep("=", 80), "\n")
cat("STATISTICAL TESTS: OVERT CASE\n")
cat(rep("=", 80), "\n\n")

# For each model, test if their EO preference is different from 50% chance
# We have 8 items per condition for LLMs, 20 for children

for (i in 1:nrow(overt_summary)) {
  model_name <- overt_summary$Model[i]
  es_pct <- overt_summary$ES_Pref_..[i]
  eo_pct <- overt_summary$EO_Pref_..[i]
  
  # Sample size (children = 20, LLMs = 8)
  n <- ifelse(i == 1, 20, 8)
  
  # Calculate Cohen's h (effect size)
  cohens_h <- 2 * (asin(sqrt(eo_pct/100)) - asin(sqrt(es_pct/100)))
  
  cat(model_name, "\n")
  cat("  ES condition:", es_pct, "%\n")
  cat("  EO condition:", eo_pct, "%\n")
  cat("  Difference:", eo_pct - es_pct, "percentage points\n")
  cat("  Cohen's h:", round(cohens_h, 3), "\n\n")
}

# STEP 4: Run statistics on NO CASE
cat("\n", rep("=", 80), "\n")
cat("STATISTICAL TESTS: NO CASE\n")
cat(rep("=", 80), "\n\n")

for (i in 1:nrow(no_case_summary)) {
  model_name <- no_case_summary$Model[i]
  es_pct <- no_case_summary$ES_Pref_..[i]
  eo_pct <- no_case_summary$EO_Pref_..[i]
  
  n <- ifelse(i == 1, 20, 8)
  
  cohens_h <- 2 * (asin(sqrt(eo_pct/100)) - asin(sqrt(es_pct/100)))
  
  cat(model_name, "\n")
  cat("  ES condition:", es_pct, "%\n")
  cat("  EO condition:", eo_pct, "%\n")
  cat("  Difference:", eo_pct - es_pct, "percentage points\n")
  cat("  Cohen's h:", round(cohens_h, 3), "\n\n")
}

# STEP 5: Compare conditions
cat("\n", rep("=", 80), "\n")
cat("COMPARISON: How did each model change from OVERT to NO CASE?\n")
cat(rep("=", 80), "\n\n")

for (i in 1:nrow(overt_summary)) {
  model_name <- overt_summary$Model[i]
  
  overt_diff <- overt_summary$Difference_pp[i]
  no_case_diff <- no_case_summary$Difference_pp[i]
  
  change <- no_case_diff - overt_diff
  
  cat(model_name, "\n")
  cat("  With case markers (overt):", overt_diff, "pp\n")
  cat("  Without case markers (no case):", no_case_diff, "pp\n")
  cat("  Change:", change, "pp\n")
  
  if (change > 10) {
    cat("  → IMPROVED without case markers\n\n")
  } else if (change < -10) {
    cat("  → GOT WORSE without case markers\n\n")
  } else {
    cat("  → No major change\n\n")
  }
}

cat("\nDONE!\n")