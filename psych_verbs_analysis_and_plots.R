# =============================================================================
# Psych Verbs Children Study — Full Analysis & Plots
# Dataset: psych_verbs_children_final.csv
# Outcome: eo_preference (1 = chose EO response, 0 = chose ES response)
# Fixed effects: condition (EO vs ES) + age_group (4yo vs 5yo) + interaction
# Random effects: (1 | participant_id) + (1 | item_id)
# Reference: ES condition, 4-year-olds
# =============================================================================


# -----------------------------------------------------------------------------
# 1. Install packages (only needed once — comment out after first run)
# -----------------------------------------------------------------------------

# install.packages(c("lme4", "lmerTest", "sandwich", "lmtest", "tidyverse"))


# -----------------------------------------------------------------------------
# 2. Load packages
# -----------------------------------------------------------------------------

library(lme4)       # mixed models
library(lmerTest)   # p-values for lmer
library(sandwich)   # robust SEs
library(lmtest)     # coeftest
library(tidyverse)  # data wrangling + ggplot2


# -----------------------------------------------------------------------------
# 3. Load & prepare data
#    !! Change the path below to the folder where your CSV is saved !!
# -----------------------------------------------------------------------------

setwd("/Users/macbookair/Library/CloudStorage/OneDrive-Personal/MY THESIS/MY NEW THESIS/results")

df <- read.csv("psych_verbs_children.csv")

# Set reference levels: ES condition, 4yo
df$condition     <- factor(df$condition,  levels = c("ES", "EO"))
df$age_group     <- factor(df$age_group,  levels = c("4yo", "5yo"))
df$eo_preference <- as.integer(df$eo_preference)

# Quick check
cat("\n--- Data structure ---\n")
str(df)
cat("\n--- Participants per condition x age ---\n")
print(table(df$condition, df$age_group))


# -----------------------------------------------------------------------------
# 4. Descriptive statistics
# -----------------------------------------------------------------------------

# Per-participant preference rate
pp <- df %>%
  group_by(participant_id, age_group, condition) %>%
  summarise(pref_rate = mean(eo_preference) * 100, .groups = "drop")

# Group means and SEs
group_stats <- pp %>%
  group_by(age_group, condition) %>%
  summarise(
    pref_mean = mean(pref_rate),
    pref_se   = sd(pref_rate) / sqrt(n()),
    n         = n(),
    .groups   = "drop"
  )

cat("\n--- Descriptive statistics ---\n")
print(group_stats)


# -----------------------------------------------------------------------------
# 5. GLMM — logistic with crossed random intercepts (lme4)
#    If you get a "singular fit" warning, skip to Step 6.
# -----------------------------------------------------------------------------

cat("\n--- GLMM with crossed random intercepts ---\n")
m_glmm <- glmer(
  eo_preference ~ condition * age_group + (1 | participant_id) + (1 | item_id),
  data    = df,
  family  = binomial(link = "logit"),
  control = glmerControl(optimizer = "bobyqa")
)
summary(m_glmm)


# -----------------------------------------------------------------------------
# 6. Fallback: logistic regression + cluster-robust SEs
#    Use this if Step 5 gives a "singular fit" warning (random variance = 0)
# -----------------------------------------------------------------------------

m_glm <- glm(
  eo_preference ~ condition * age_group,
  data   = df,
  family = binomial(link = "logit")
)

cat("\n--- Logistic regression with cluster-robust SEs (Wald z) ---\n")
coeftest(m_glm, vcov = vcovCL(m_glm, cluster = ~participant_id))


# -----------------------------------------------------------------------------
# 7. Odds ratios with 95% CIs
# -----------------------------------------------------------------------------

get_OR_table <- function(model, cluster_var) {
  robust    <- coeftest(model, vcov = vcovCL(model, cluster = cluster_var))
  se_robust <- robust[, "Std. Error"]
  cbind(
    beta   = coef(model),
    SE     = se_robust,
    Wald_z = robust[, "z value"],
    p      = robust[, "Pr(>|z|)"],
    OR     = exp(coef(model)),
    CI_lo  = exp(coef(model) - 1.96 * se_robust),
    CI_hi  = exp(coef(model) + 1.96 * se_robust)
  )
}

cat("\n--- Odds ratios with 95% CIs ---\n")
print(round(get_OR_table(m_glm, ~df$participant_id), 3))


# =============================================================================
# 8. PLOTS
# =============================================================================

# Shared plot theme
plot_theme <- theme_classic() +
  theme(
    axis.title      = element_text(size = 12),
    axis.text       = element_text(size = 11),
    legend.title    = element_blank(),
    legend.text     = element_text(size = 11),
    legend.position = "top",
    plot.title      = element_text(size = 13, face = "bold"),
    plot.subtitle   = element_text(size = 11, color = "gray40")
  )


# -----------------------------------------------------------------------------
# Plot 1: EO Preference by Condition and Age Group
# -----------------------------------------------------------------------------

p1 <- ggplot(group_stats, aes(x = age_group, y = pref_mean, fill = condition)) +
  geom_bar(
    stat     = "identity",
    position = position_dodge(width = 0.6),
    width    = 0.5,
    color    = NA
  ) +
  geom_errorbar(
    aes(ymin = pref_mean - pref_se, ymax = pref_mean + pref_se),
    position  = position_dodge(width = 0.6),
    width     = 0.15,
    linewidth = 0.7
  ) +
  geom_hline(
    yintercept = 50,
    linetype   = "dashed",
    color      = "gray50",
    linewidth  = 0.7
  ) +
  annotate(
    "text",
    x     = 0.55,
    y     = 53,
    label = "chance (50%)",
    size  = 3.2,
    color = "gray50"
  ) +
  scale_fill_manual(
    values = c("EO" = "#1D9E75", "ES" = "#F0994A"),
    labels = c("ES (habitual attitude)", "EO (emotional episode)")
  ) +
  scale_y_continuous(
    limits = c(0, 110),
    labels = function(x) paste0(x, "%")
  ) +
  labs(
    title    = "EO Preference by Semantic Condition and Age Group",
    subtitle = "Mean % choosing EO interpretation +/- SE. Dashed line = chance (50%)",
    x        = "Age group",
    y        = "EO preference (%)"
  ) +
  plot_theme

print(p1)


# -----------------------------------------------------------------------------
# Plot 2: Developmental Trajectories by Condition
# -----------------------------------------------------------------------------

traj_means <- group_stats %>%
  select(age_group, condition, pref_mean)

p2 <- ggplot() +
  # Individual participant dots (jittered slightly)
  geom_jitter(
    data   = pp,
    aes(x = age_group, y = pref_rate, color = condition),
    width  = 0.08,
    height = 0,
    alpha  = 0.45,
    size   = 2.5
  ) +
  # Group mean lines
  geom_line(
    data      = traj_means,
    aes(x = age_group, y = pref_mean, color = condition, group = condition),
    linewidth = 1.5
  ) +
  # Group mean points
  geom_point(
    data = traj_means,
    aes(x = age_group, y = pref_mean, color = condition),
    size = 4
  ) +
  geom_hline(
    yintercept = 50,
    linetype   = "dashed",
    color      = "gray50",
    linewidth  = 0.7
  ) +
  annotate(
    "text",
    x     = 0.55,
    y     = 53,
    label = "chance (50%)",
    size  = 3.2,
    color = "gray50"
  ) +
  scale_color_manual(
    values = c("EO" = "#185FA5", "ES" = "#E8700A"),
    labels = c("ES (habitual attitude)", "EO (emotional episode)")
  ) +
  scale_y_continuous(
    limits = c(-5, 110),
    labels = function(x) paste0(x, "%")
  ) +
  labs(
    title    = "Developmental Trajectories by Semantic Condition",
    subtitle = "Individual participants (dots) and group means (lines). Dashed = chance (50%)",
    x        = "Age group",
    y        = "EO preference (%)"
  ) +
  plot_theme

print(p2)


# -----------------------------------------------------------------------------
# 9. Save plots
# -----------------------------------------------------------------------------

ggsave("plot1_preference_by_condition_age.png",
       plot = p1, width = 6, height = 5, dpi = 300)

ggsave("plot2_developmental_trajectories.png",
       plot = p2, width = 6, height = 5, dpi = 300)

cat("\nAll done! Plots saved to your results folder.\n")
