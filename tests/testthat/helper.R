sample_lines <- function() {
  t <- seq(as.Date("2024-01-31"), by = "month", length.out = 6)
  tibble::tibble(
    time = rep(t, 2),
    value = c(1:6, 6:1) / 10,
    label = factor(rep(c("Série A", "Série B"), each = 6), levels = c("Série A", "Série B")),
    tooltip = "tt"
  )
}

map_lines <- function() {
  tibble::tibble(label = c("Série A", "Série B"), color = unname(DGT_col[c("bleu_france", "rouge_marianne")]))
}

# Construit le graphique pour vérifier qu'il se rend sans erreur
expect_renders <- function(p) {
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplot2::ggplot_build(p))
}
