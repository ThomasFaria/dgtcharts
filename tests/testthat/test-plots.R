test_that("plot_lines se rend, avec et sans double axe", {
  s <- sample_lines()
  expect_renders(plot_lines(s, map_lines(), title = "T", sources = "BdF", last_point = "juin 2024"))
  sf <- calculate_scale_factor(s, "label", "value", scaled_group = "Série B")
  expect_renders(plot_lines(s, map_lines(), scaleFactor = sf, sec_series = "Série B"))
  expect_error(plot_lines(s, map_lines(), scaleFactor = sf), "sec_series")
})

test_that("plot_bar_line se rend", {
  s <- sample_lines()
  s$measure <- ifelse(s$label == "Série A", "bar", "line")
  m <- map_lines(); m$fill <- m$color
  expect_renders(plot_bar_line(s, m, y_percent = TRUE))
})

test_that("plot_lines_area se rend", {
  s <- sample_lines()
  total <- dplyr::summarise(s, value = sum(value), .by = time)
  expect_renders(plot_lines_area(s, total, map_lines()))
})

test_that("plot_contrib se rend", {
  s <- sample_lines()
  s$values <- s$value
  va <- dplyr::summarise(s, var_annuelle = sum(value), .by = time)
  expect_renders(plot_contrib(s, va, map_lines()))
})

test_that("plot_lines_facet se rend", {
  skip_if_not_installed("gghighlight")
  expect_renders(plot_lines_facet(sample_lines(), map_lines()))
})

test_that("render_interactive renvoie un girafe, entouré du bouton CSV si des données sont fournies", {
  p <- ggplot2::ggplot(sample_lines(), ggplot2::aes(time, value, colour = label)) + ggplot2::geom_line()
  expect_s3_class(render_interactive(p), "girafe")
  w <- render_interactive(p, download_data = sample_lines())
  expect_s3_class(w, "shiny.tag")
  expect_match(as.character(w), "chart-data-download-btn", fixed = TRUE)
})

test_that("les versions interactives se rendent sans erreur", {
  s <- sample_lines()
  total <- dplyr::summarise(s, value = sum(value), .by = time)
  total$tooltip <- "tt"
  # Le dernier segment de chaque série (lead() = NA) est retiré par ggplot2 :
  # avertissement attendu, sans conséquence sur le rendu.
  suppressWarnings({
    expect_s3_class(plot_lines_interactive(s, map_lines()), "shiny.tag")
    expect_s3_class(plot_lines_area_interactive(s, total, map_lines()), "shiny.tag")
    expect_s3_class(plot_lines_facet_interactive(s, map_lines()), "shiny.tag")
  })
})
