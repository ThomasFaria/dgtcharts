# Enregistre la police Marianne embarquée si elle n'est pas installée sur le
# système. Appelé au chargement du package.
register_marianne <- function() {
  already <- "Marianne" %in% systemfonts::system_fonts()$family ||
    "Marianne" %in% systemfonts::registry_fonts()$family
  if (already) {
    return(invisible(FALSE))
  }
  font_file <- function(f) system.file("fonts", f, package = "dgtcharts")
  systemfonts::register_font(
    name       = "Marianne",
    plain      = font_file("Marianne-Regular.otf"),
    bold       = font_file("Marianne-Bold.otf"),
    italic     = font_file("Marianne-RegularItalic.otf"),
    bolditalic = font_file("Marianne-BoldItalic.otf")
  )
  invisible(TRUE)
}

.onLoad <- function(libname, pkgname) {
  try(register_marianne(), silent = TRUE)
}

# Variables utilisées en évaluation non standard (aes(), dplyr, gt)
utils::globalVariables(c(
  "time", "value", "values", "label", "measure", "tooltip", "data_id",
  "time_end", "value_end", "facet", "var_annuelle", "parent"
))
