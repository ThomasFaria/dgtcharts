test_that("format_date_fr formate en français", {
  d <- as.Date("2024-03-15")
  expect_equal(format_date_fr(d, "day"), "15 mars 2024")
  expect_equal(format_date_fr(d, "month"), "mars 2024")
  expect_equal(format_date_fr(d, "quarter"), "T1 2024")
  expect_equal(format_date_fr(d, "semester"), "S1 2024")
})

test_that("create_tooltip produit du HTML avec virgule décimale", {
  tt <- create_tooltip(as.Date("2024-03-31"), 1.5, unit = "%", label = "Taux")
  expect_match(tt, "<strong>mars 2024</strong>", fixed = TRUE)
  expect_match(tt, "Taux : 1,5 %", fixed = TRUE)
})

test_that("calculate_scale_factor aligne les étendues", {
  df <- data.frame(g = rep(c("a", "b"), each = 2), v = c(0, 10, 0, 100))
  sf <- calculate_scale_factor(df, "g", "v", scaled_group = "b")
  expect_equal(sf, list(a = 0.1, b = 0))
  sf0 <- calculate_scale_factor(df, "g", "v", scaled_group = "b", align_zero = TRUE)
  expect_equal(sf0$b, 0)
})

test_that("add_caption assemble source et dernier point", {
  cap <- add_caption("Banque de France", "mars 2024")
  expect_equal(cap$caption, "Source : Banque de France. Dernier point : mars 2024.")
  expect_null(add_caption())
})

test_that("get_depth calcule la hiérarchie", {
  expect_equal(get_depth(c("A", "B", "C"), c(NA, "A", "B")), c(0, 1, 2))
})

test_that("encode_csv_fr produit un CSV base64 avec BOM", {
  raw <- base64enc::base64decode(encode_csv_fr(data.frame(x = 1.5)))
  expect_equal(raw[1:3], as.raw(c(0xef, 0xbb, 0xbf)))
  expect_match(rawToChar(raw[-(1:3)]), "1,5")
})
