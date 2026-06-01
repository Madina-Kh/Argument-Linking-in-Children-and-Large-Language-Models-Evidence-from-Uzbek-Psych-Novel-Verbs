# ==============================================================================
# STATISTICAL ANALYSIS: ENGLISH NOVEL PSYCH VERBS (LLM Test)
# Testing if models show aspectual sensitivity in English
# ==============================================================================

# STEP 1: Load the English test data
english_summary <- read.csv("english_results_summary.csv")

cat("=== ENGLISH TEST DATA (LLMs on English Novel Verbs) ===\n")
print(english_summary)

# ==============================================================================
# ANALYSIS 1: Effect sizes (Cohen's h) for English
# ==============================================================================
cat("\n", rep("=", 80), "\n", sep="")
cat("ANALYSIS 1: EFFECT SIZES - ENGLISH NOVEL VERBS\n")
cat(rep("=", 80), "\n", sep="")

cohens_h <- function(p1, p2) 2 * (asin(sqrt(p1)) - asin(sqrt(p2)))

cat("\n")
cat(sprintf("%-25s %10s %10s %12s %10s %12s\n",
            "Model", "ES%", "EO%", "Diff (pp)", "Cohen's h", "Magnitude"))
cat(rep("-", 80), "\n", sep="")

english_effects <- data.frame(
  Model = character(0),
  ES_pct = numeric(0),
  EO_pct = numeric(0),
  Diff = numeric(0),
  Cohen_h = numeric(0),
  Magnitude = character(0),
  stringsAsFactors = FALSE
)

for (i in 1:nrow(english_summary)) {
  model <- english_summary$Model[i]
  es_pct <- english_summary$ES_Pref_..[i]
  eo_pct <- english_summary$EO_Pref_..[i]
  diff <- english_summary$Difference_pp[i]
  
  h <- cohens_h(eo_pct/100, es_pct/100)
  mag <- ifelse(abs(h) < 0.2, "negligible",
                ifelse(abs(h) < 0.5, "small",
                       ifelse(abs(h) < 0.8, "medium", "large")))
  
  english_effects[i, ] <- list(model, es_pct, eo_pct, diff, h, mag)
  
  cat(sprintf("%-25s %9.1f%% %9.1f%% %11.1f %10.3f %12s\n",
              model, es_pct, eo_pct, diff, h, mag))
}

# ==============================================================================
# ANALYSIS 2: Compare English vs Uzbek Performance
# ==============================================================================
cat("\n", rep("=", 80), "\n", sep="")
cat("ANALYSIS 2: ENGLISH vs UZBEK - MODEL COMPARISON\n")
cat(rep("=", 80), "\n", sep="")

# Load Uzbek results for comparison
# Uzbek children baseline
uzbek_children_h <- 0.831

cat("\nBaseline (Uzbek children): h = 0.831 (large)\n\n")

# Compare each model's English vs Uzbek performance
# Note: You'll need to have the Uzbek results available
# For now, let's focus on English-only analysis

cat("Model Performance on ENGLISH Novel Verbs:\n")
cat(rep("-", 80), "\n", sep="")

for (i in 2:nrow(english_effects)) {  # Skip row 1 (Uzbek children)
  model <- english_effects$Model[i]
  h_english <- english_effects$Cohen_h[i]
  mag <- english_effects$Magnitude[i]
  pct_of_baseline <- (h_english / uzbek_children_h) * 100
  
  cat(sprintf("%-25s h = %+.3f (%s, %.0f%% of Uzbek children)\n",
              model, h_english, mag, pct_of_baseline))
}

# ==============================================================================
# ANALYSIS 3: Cross-linguistic comparison (if Uzbek data available)
# ==============================================================================
cat("\n", rep("=", 80), "\n", sep="")
cat("ANALYSIS 3: DOES LANGUAGE MATTER?\n")
cat(rep("=", 80), "\n", sep="")

cat("\nNote: To complete this analysis, load Uzbek LLM results and compare:\n")
cat("  - Same model, different language (e.g., mBERT on Uzbek vs English)\n")
cat("  - Does aspectual sensitivity transfer across languages?\n")
cat("  - Or is it language-specific?\n")

# Placeholder for when you have both datasets
cat("\nTo add: Load overt_case Uzbek results and create side-by-side comparison\n")

# ==============================================================================
# SUMMARY
# ==============================================================================
cat("\n", rep("=", 80), "\n", sep="")
cat("SUMMARY: ENGLISH NOVEL PSYCH VERBS\n")
cat(rep("=", 80), "\n\n")

cat("1. MODELS WITH CORRECT PATTERN (positive h):\n")
for (i in 2:nrow(english_effects)) {
  if (english_effects$Cohen_h[i] > 0) {
    cat(sprintf("   ✓ %-25s h = %.3f (%s)\n",
                english_effects$Model[i],
                english_effects$Cohen_h[i],
                english_effects$Magnitude[i]))
  }
}

cat("\n2. MODELS WITH REVERSED/NO PATTERN:\n")
for (i in 2:nrow(english_effects)) {
  if (english_effects$Cohen_h[i] <= 0) {
    cat(sprintf("   ✗ %-25s h = %.3f\n",
                english_effects$Model[i],
                english_effects$Cohen_h[i]))
  }
}

cat("\n3. KEY FINDING:\n")
best_model_idx <- which.max(abs(english_effects$Cohen_h[2:nrow(english_effects)])) + 1
best_model <- english_effects$Model[best_model_idx]
best_h <- english_effects$Cohen_h[best_model_idx]

cat(sprintf("   Best performer: %s (h = %.3f)\n", best_model, best_h))

if (abs(best_h) > 0.2) {
  cat("   → Some models show aspectual sensitivity in English\n")
} else {
  cat("   → Minimal aspectual sensitivity across all models in English\n")
}

cat("\n", rep("=", 80), "\n", sep="")
cat("ANALYSIS COMPLETE!\n")
cat(rep("=", 80), "\n", sep="")