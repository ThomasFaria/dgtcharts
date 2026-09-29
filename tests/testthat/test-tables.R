test_that("create_table_standard produit une table gt", {
  prep <- list(
    data = tibble::tibble(label = c("Total", "Dont A"), v = c(10.25, 3.5), parent = c(NA, "Total")),
    col_config = list(col_labels = c(label = "", v = "Encours", parent = "")),
    ref_cols = "v",
    format_config = list(columns = list(v = list(type = "number", decimals = 1))),
    metadata = list(title = "Titre", source = "Source : test", has_hierarchy = TRUE)
  )
  tbl <- create_table_standard(prep)
  expect_s3_class(tbl, "gt_tbl")
  expect_no_error(gt::as_raw_html(tbl))
})
