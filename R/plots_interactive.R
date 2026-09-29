# Fonctions de graphiques interactifs (ggiraph) ------------------------------

#' Famille 1 : Graphique lignes (version interactive)
#'
#' @param sample tibble avec colonnes: time, value, label
#' @param series_map tibble avec colonnes: label, color
#' @param scaleFactor list(a=, b=), transformation affine pour le double axe (NULL si pas de double axe)
#' @param sec_series character, nom du label de la série à mettre sur l'axe secondaire (obligatoire si scaleFactor non NULL)
#' @param y_percent logical, formater l'axe Y en pourcentage
#' @param y_percent_sec logical, formater l'axe Y secondaire en pourcentage (si dual_axis)
#' @param hline numeric, valeur de la ligne horizontale (NULL pour aucune ligne)
#' @param legend_nrow integer, nombre de lignes pour la légende (NULL pour automatique)
#' @param title character, titre du graphique
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @param theme_extra theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par défaut)
#' @export
plot_lines_interactive <- function(sample, series_map,
                                   scaleFactor = NULL,
                                   sec_series = NULL,
                                   y_percent = FALSE,
                                   y_percent_sec = FALSE,
                                   hline = NULL,
                                   legend_nrow = NULL,
                                   title = "",
                                   sources = "",
                                   last_point = "",
                                   theme_extra = NULL) {
  # Vérification de cohérence des paramètres
  if (!is.null(scaleFactor) && is.null(sec_series)) {
    stop("Si scaleFactor est fourni, sec_series doit aussi \u00eatre fourni")
  }

  plot_data <- sample |>
    dplyr::arrange(time, label) |>
    dplyr::group_by(label) |>
    dplyr::mutate(
      time_end = dplyr::lead(time),
      value_end = dplyr::lead(value),
      data_id = paste0(label, "_", time)
    ) |>
    dplyr::ungroup()

  # Scaler la série spécifiée si nécessaire
  if (!is.null(scaleFactor)) {
    plot_data <- plot_data |>
      dplyr::mutate(
        value = dplyr::if_else(label == sec_series, value * scaleFactor$a + scaleFactor$b, value),
        value_end = dplyr::if_else(label == sec_series, value_end * scaleFactor$a + scaleFactor$b, value_end)
      )
  }

  p <- ggplot(plot_data, aes(x = time, y = value, color = label, group = label, tooltip = tooltip, data_id = data_id)) +
    geom_segment_interactive(aes(xend = time_end, yend = value_end)) +
    geom_point_interactive(size = 0.5, hover_nearest = TRUE) + # On est obligé de rajouter des points pour avoir le tooltip partout
    scale_color_manual(values = setNames(series_map$color, series_map$label)) +
    theme_DGT()

  # Double axe
  if (!is.null(scaleFactor)) {
    primary_labels <- if (y_percent) scales::percent else waiver()
    sec_labels <- if (y_percent_sec) scales::percent else waiver()
    p <- p +
      scale_y_continuous(
        labels   = primary_labels,
        sec.axis = sec_axis(~ (. - scaleFactor$b) / scaleFactor$a, labels = sec_labels)
      )
  } else {
    if (y_percent) p <- p + scale_y_continuous(labels = scales::percent)
  }

  # Options
  if (!is.null(hline)) p <- p + geom_hline(yintercept = hline, color = "black")

  # Configuration de la légende sur plusieurs lignes si spécifié
  if (!is.null(legend_nrow)) {
    p <- p + guides(color = guide_legend(nrow = legend_nrow, byrow = TRUE))
  }

  # Ajout du titre
  if (title != "") {
    p <- p + labs(title = title)
  }

  # Ajout de la caption
  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) {
    p <- p + caption_layer
  }

  # Ajout du thème extra si fourni
  if (!is.null(theme_extra)) {
    p <- p + theme_extra
  }

  p |> render_interactive(download_data = dplyr::select(sample, dplyr::any_of(c("time", "value", "label"))))
}

#' Famille 2 : Graphique barres + ligne avec double axe (version interactive)
#'
#' @param sample tibble avec colonnes: time, value, measure ("bar" ou "line"), label
#' @param series_map tibble avec colonnes: label, color, fill
#' @param scaleFactor list(a=, b=), transformation affine pour le double axe (NULL si pas de double axe)
#' @param scale_measure character, "bar" ou "line" - indique quelle mesure scaler (obligatoire si scaleFactor non NULL)
#' @param y_percent logical, formater l'axe Y en pourcentage
#' @param y_percent_sec logical, formater l'axe Y secondaire en pourcentage (si dual_axis)
#' @param hline numeric, valeur de la ligne horizontale (NULL pour aucune ligne)
#' @param title character, titre du graphique
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @param theme_extra theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par défaut)
#' @export
plot_bar_line_interactive <- function(sample, series_map,
                                      scaleFactor = NULL,
                                      scale_measure = NULL,
                                      y_percent = FALSE,
                                      y_percent_sec = FALSE,
                                      hline = NULL,
                                      title = "",
                                      sources = "",
                                      last_point = "",
                                      theme_extra = NULL) {
  # Vérification de cohérence des paramètres
  if (!is.null(scaleFactor) && is.null(scale_measure)) {
    stop("Si scaleFactor est fourni, scale_measure doit aussi \u00eatre fourni")
  }

  plot_data <- sample |>
    dplyr::arrange(time, label) |>
    dplyr::group_by(label) |>
    dplyr::mutate(
      time_end = dplyr::lead(time),
      value_end = dplyr::lead(value),
      data_id = paste0(label, "_", time)
    ) |>
    dplyr::ungroup()

  # Scaler la mesure spécifiée si nécessaire
  if (!is.null(scaleFactor)) {
    plot_data <- plot_data |>
      dplyr::mutate(
        value = dplyr::if_else(measure == scale_measure, value * scaleFactor$a + scaleFactor$b, value),
        value_end = dplyr::if_else(measure == scale_measure, value_end * scaleFactor$a + scaleFactor$b, value_end)
      )
  }

  p <- ggplot(mapping = aes(x = time, y = value, group = label, tooltip = tooltip, data_id = data_id)) +
    geom_bar_interactive(
      data = plot_data |> dplyr::filter(measure == "bar"),
      aes(fill = label),
      stat = "identity", position = position_dodge()
    ) +
    geom_segment_interactive(
      data = plot_data |> dplyr::filter(measure == "line"),
      aes(color = label, xend = time_end, yend = value_end)
    ) +
    geom_point_interactive(
      data = plot_data |> dplyr::filter(measure == "line"),
      aes(color = label),
      size = 0.5,
      hover_nearest = TRUE
    ) + # On est obligé de rajouter des points pour avoir le tooltip partout
    scale_fill_manual(values = setNames(series_map$fill, series_map$label)) +
    scale_color_manual(values = setNames(series_map$color, series_map$label)) +
    theme_DGT()

  # Double axe
  if (!is.null(scaleFactor)) {
    sec_labels <- if (y_percent_sec) scales::percent else waiver()
    p <- p +
      scale_y_continuous(sec.axis = sec_axis(~ (. - scaleFactor$b) / scaleFactor$a, labels = sec_labels)) +
      theme_sub_axis_right(text = element_text(hjust = -0.35))
  }

  # Options
  if (!is.null(hline)) p <- p + geom_hline(yintercept = hline, color = "black")
  if (y_percent) {
    if (!is.null(scaleFactor)) {
      p <- p + scale_y_continuous(labels = scales::percent, sec.axis = sec_axis(~ (. - scaleFactor$b) / scaleFactor$a))
    } else {
      p <- p + scale_y_continuous(labels = scales::percent)
    }
  }

  # Ajout du titre
  if (title != "") {
    p <- p + labs(title = title)
  }

  # Ajout de la caption
  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) {
    p <- p + caption_layer
  }

  # Ajout du thème extra si fourni
  if (!is.null(theme_extra)) {
    p <- p + theme_extra
  }

  p |> render_interactive(download_data = dplyr::select(sample, dplyr::any_of(c("time", "value", "measure", "label"))))
}

#' Famille 3 : Plusieurs lignes + aire pour le total (version interactive)
#'
#' @param sample tibble avec colonnes: time, value, group
#' @param total tibble avec colonnes: time, value
#' @param series_map tibble avec colonnes: group, color
#' @param hline numeric, valeur de la ligne horizontale (NULL pour aucune ligne)
#' @param area_alpha numeric, transparence de l'aire (0-1)
#' @param legend_nrow integer, nombre de lignes pour la légende (NULL pour automatique)
#' @param total_label character, libellé du Total dans la légende ("Total" par défaut)
#' @param title character, titre du graphique
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @param theme_extra theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par défaut)
#' @export
plot_lines_area_interactive <- function(sample, total, series_map,
                                        hline = 0,
                                        area_alpha = 0.25,
                                        legend_nrow = NULL,
                                        total_label = "Total",
                                        title = "",
                                        sources = "",
                                        last_point = "",
                                        theme_extra = NULL) {
  sample <- sample |>
    dplyr::arrange(time, label) |>
    dplyr::group_by(label) |>
    dplyr::mutate(
      time_end = dplyr::lead(time),
      value_end = dplyr::lead(value),
      data_id = paste0(label, "_", time)
    ) |>
    dplyr::ungroup()

  total <- total |>
    dplyr::mutate(
      data_id = paste0("total_", time)
    )

  p <- ggplot() +
    geom_ribbon_interactive(
      data = total,
      aes(x = time, ymin = 0, ymax = value, fill = total_label, data_id = data_id, group = total_label),
      color = DGT_col[c("noir")],
      alpha = area_alpha
    ) +
    geom_point_interactive(
      data = total,
      aes(x = time, y = value, tooltip = tooltip, data_id = data_id, group = total_label),
      color = DGT_col[c("noir")],
      size = 0.5,
      hover_nearest = TRUE
    ) + # On est obligé de rajouter des points pour avoir le tooltip partout
    geom_segment_interactive(
      data = sample,
      aes(x = time, y = value, xend = time_end, yend = value_end, group = label, color = label)
    ) +
    geom_point_interactive(
      data = sample,
      aes(x = time, y = value, group = label, color = label, tooltip = tooltip, data_id = data_id),
      size = 0.5,
      hover_nearest = TRUE
    ) + # On est obligé de rajouter des points pour avoir le tooltip partout
    scale_color_manual(values = setNames(series_map$color, series_map$label)) +
    scale_fill_manual(values = setNames(DGT_col[c("gris_clair")], total_label)) +
    theme_DGT()

  if (!is.null(hline)) p <- p + geom_hline(yintercept = hline, color = "black")

  # Configuration de la légende sur plusieurs lignes si spécifié
  if (!is.null(legend_nrow)) {
    p <- p +
      guides(
        color = guide_legend(nrow = legend_nrow, byrow = TRUE)
      )
  }

  # Ajout du titre
  if (title != "") {
    p <- p + labs(title = title)
  }

  # Ajout de la caption
  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) {
    p <- p + caption_layer
  }

  # Ajout du thème extra si fourni
  if (!is.null(theme_extra)) {
    p <- p + theme_extra
  }

  download_data <- dplyr::bind_rows(
    dplyr::select(sample, dplyr::any_of(c("time", "value", "label"))),
    dplyr::select(total, dplyr::any_of(c("time", "value"))) |> dplyr::mutate(label = total_label)
  )

  p |> render_interactive(download_data = download_data)
}

#' Famille 5 : petits multiples (une série par facette, les autres en fond gris) — version interactive
#'
#' @param sample tibble avec colonnes: time, value, label, tooltip
#' @param series_map tibble avec colonnes: label, color
#' @param facet_ncol,facet_nrow integer, disposition des facettes
#' @param y_limits numeric(2), bornes de l'axe Y (NULL pour automatique)
#' @param hline numeric, valeur de la ligne horizontale de référence (NULL pour aucune)
#' @param y_percent logical, formater l'axe Y en pourcentage
#' @param title character, titre du graphique
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @param theme_extra theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par défaut)
#' @param height_svg numeric, hauteur du SVG (5 par défaut)
#' @export
plot_lines_facet_interactive <- function(sample, series_map,
                                         facet_ncol = NULL,
                                         facet_nrow = NULL,
                                         y_limits = NULL,
                                         hline = NULL,
                                         y_percent = FALSE,
                                         title = "",
                                         sources = "",
                                         last_point = "",
                                         theme_extra = NULL,
                                         height_svg = 5) {
  seg_data <- sample |>
    dplyr::arrange(label, time) |>
    dplyr::group_by(label) |>
    dplyr::mutate(
      time_end  = dplyr::lead(time),
      value_end = dplyr::lead(value),
      data_id   = paste0(label, "_", time)
    ) |>
    dplyr::ungroup()

  facet_labels <- levels(seg_data$label)
  if (is.null(facet_labels)) facet_labels <- unique(seg_data$label)

  # Fond : toutes les séries sauf la série du facet, sans tooltip
  bg_data <- purrr::map_dfr(facet_labels, \(fl) {
    seg_data |>
      dplyr::filter(label != fl) |>
      dplyr::mutate(facet = factor(fl, levels = facet_labels))
  })

  # Premier plan : uniquement la série du facet, avec tooltip
  hl_data <- seg_data |>
    dplyr::mutate(facet = factor(label, levels = facet_labels))

  p <- ggplot() +
    geom_segment(
      data = bg_data,
      aes(x = time, xend = time_end, y = value, yend = value_end, group = label),
      colour = "grey80", linewidth = 0.4
    ) +
    ggiraph::geom_segment_interactive(
      data = hl_data,
      aes(x = time, xend = time_end, y = value, yend = value_end,
          colour = facet, group = label, tooltip = tooltip, data_id = data_id)
    ) +
    ggiraph::geom_point_interactive(
      data = hl_data,
      aes(x = time, y = value, colour = facet, group = label,
          tooltip = tooltip, data_id = data_id),
      size = 0.5, hover_nearest = TRUE
    ) +
    facet_wrap(~ facet, ncol = facet_ncol, nrow = facet_nrow) +
    scale_colour_manual(values = setNames(series_map$color, series_map$label)) +
    theme_DGT() +
    theme(legend.position = "none") +
    labs(x = NULL, y = NULL)

  if (!is.null(hline)) {
    p <- p + geom_hline(yintercept = hline, color = "black")
  }

  if (y_percent) {
    p <- p + scale_y_continuous(
      labels = scales::percent,
      limits = y_limits
    )
  } else if (!is.null(y_limits)) {
    p <- p + scale_y_continuous(limits = y_limits)
  }

  if (title != "") p <- p + labs(title = title)

  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) p <- p + caption_layer

  if (!is.null(theme_extra)) p <- p + theme_extra

  p |> render_interactive(
    height_svg = height_svg,
    download_data = dplyr::select(sample, dplyr::any_of(c("time", "value", "label")))
  )
}

#' Famille 6 : Barres empilées (contributions) + ligne (variation annuelle totale) — version interactive
#'
#' @param sample tibble avec colonnes: time, values (contribution décimale), label, tooltip
#' @param var_annuelle tibble avec colonnes: time, var_annuelle (taux décimal), tooltip
#' @param series_map tibble avec colonnes: label, color
#' @param total_label character, libellé de la ligne totale dans la légende
#' @param y_percent logical, formater l'axe Y en pourcentage
#' @param hline numeric, valeur de la ligne horizontale (NULL pour aucune)
#' @param legend_nrow integer, nombre de lignes pour la légende
#' @param title character, titre du graphique
#' @param sources character, source des données
#' @param last_point character, dernier point des données
#' @param theme_extra theme ggplot2 supplémentaire
#' @export
plot_contrib_interactive <- function(sample, var_annuelle, series_map,
                                     total_label = "Variation annuelle",
                                     y_percent = TRUE,
                                     hline = 0,
                                     legend_nrow = NULL,
                                     title = "",
                                     sources = "",
                                     last_point = "",
                                     theme_extra = NULL) {
  plot_bars <- sample |>
    dplyr::mutate(data_id = paste0(label, "_", time))

  plot_line <- var_annuelle |>
    dplyr::arrange(time) |>
    dplyr::mutate(
      time_end  = dplyr::lead(time),
      value_end = dplyr::lead(var_annuelle),
      data_id   = paste0("total_", time)
    )

  p <- ggplot() +
    geom_bar_interactive(
      data = plot_bars,
      aes(x = time, y = values, fill = label, tooltip = tooltip, data_id = data_id),
      stat = "identity", position = position_stack()
    ) +
    geom_segment_interactive(
      data = plot_line,
      aes(x = time, y = var_annuelle, xend = time_end, yend = value_end,
          color = total_label, tooltip = tooltip, data_id = data_id)
    ) +
    geom_point_interactive(
      data = plot_line,
      aes(x = time, y = var_annuelle, color = total_label, tooltip = tooltip, data_id = data_id),
      size = 0.5, hover_nearest = TRUE
    ) +
    scale_fill_manual(name = "", values = setNames(series_map$color, series_map$label)) +
    scale_color_manual(name = "", values = setNames("black", total_label)) +
    theme_DGT()

  if (!is.null(hline)) p <- p + geom_hline(yintercept = hline, color = "black")
  if (y_percent) p <- p + scale_y_continuous(labels = scales::percent)

  if (!is.null(legend_nrow)) {
    p <- p + guides(fill = guide_legend(nrow = legend_nrow, byrow = TRUE), color = "none")
  } else {
    p <- p + guides(color = "none")
  }

  if (title != "") p <- p + labs(title = title)

  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) p <- p + caption_layer

  if (!is.null(theme_extra)) p <- p + theme_extra

  download_data <- dplyr::bind_rows(
    dplyr::select(sample, dplyr::any_of(c("time", "label"))) |> dplyr::mutate(value = sample$values),
    dplyr::select(var_annuelle, dplyr::any_of("time")) |> dplyr::mutate(value = var_annuelle$var_annuelle, label = total_label)
  )

  p |> render_interactive(download_data = download_data)
}
