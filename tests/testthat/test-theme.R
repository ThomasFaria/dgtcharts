test_that("la police Marianne est disponible", {
  fams <- c(systemfonts::system_fonts()$family, systemfonts::registry_fonts()$family)
  expect_true("Marianne" %in% fams)
})

test_that("DGT_col est une palette nommée de 18 couleurs", {
  expect_length(DGT_col, 18)
  expect_true(all(grepl("^#[0-9A-F]{6}$", DGT_col)))
  expect_equal(unname(DGT_col["bleu_france"]), "#000091")
})

test_that("theme_DGT renvoie un thème complet", {
  expect_s3_class(theme_DGT(), "theme")
})
