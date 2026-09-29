# Fonctions de graphiques statiques (ggplot2) -------------------------------

#' Famille 1 : Graphique lignes
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
plot_lines <- function(sample, series_map,
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

  # Scaler la série spécifiée si nécessaire
  plot_data <- sample
  if (!is.null(scaleFactor)) {
    plot_data <- sample |>
      dplyr::mutate(
        value = dplyr::if_else(
          label == sec_series,
          value * scaleFactor$a + scaleFactor$b,
          value
        )
      )
  }

  p <- ggplot(plot_data, aes(x = time, y = value, color = label)) +
    geom_line() +
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

  p
}

#' Famille 2 : Graphique barres + ligne avec double axe
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
plot_bar_line <- function(sample, series_map,
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

  # Scaler la mesure spécifiée si nécessaire
  plot_data <- sample
  if (!is.null(scaleFactor)) {
    plot_data <- sample |>
      dplyr::mutate(
        value = dplyr::if_else(measure == scale_measure, value * scaleFactor$a + scaleFactor$b, value)
      )
  }

  p <- ggplot() +
    geom_bar(
      data = plot_data |> dplyr::filter(measure == "bar"),
      aes(x = time, y = value, fill = label),
      stat = "identity", position = position_dodge()
    ) +
    geom_line(
      data = plot_data |> dplyr::filter(measure == "line"),
      aes(x = time, y = value, color = label)
    ) +
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

  p
}

#' Famille 3 : Plusieurs lignes + aire pour le total
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
plot_lines_area <- function(sample, total, series_map,
                            hline = 0,
                            area_alpha = 0.25,
                            legend_nrow = NULL,
                            total_label = "Total",
                            title = "",
                            sources = "",
                            last_point = "",
                            theme_extra = NULL) {
  p <- ggplot() +
    geom_ribbon(
      data = total,
      aes(x = time, ymin = 0, ymax = value, fill = total_label),
      color = DGT_col[c("noir")],
      alpha = area_alpha
    ) +
    geom_line(data = sample, aes(x = time, y = value, color = label)) +
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

  p
}

#' Famille 6 : Lignes en facets avec highlight (une série mise en couleur par facet, autres en grisé)
#'
#' @param sample tibble avec colonnes: time, value, label
#' @param series_map tibble avec colonnes: label, color
#' @param facet_ncol integer, nombre de colonnes dans facet_wrap (NULL pour automatique)
#' @param facet_nrow integer, nombre de lignes dans facet_wrap (NULL pour automatique)
#' @param y_limits numeric vecteur c(min, max) pour fixer les limites de l'axe Y (NULL pour automatique)
#' @param hline numeric, valeur de la ligne horizontale de référence (NULL pour aucune)
#' @param y_percent logical, formater l'axe Y en pourcentage (scale = 1, suffix = " %")
#' @param title character, titre du graphique
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @param theme_extra theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par défaut)
#' @export
plot_lines_facet <- function(sample, series_map,
                             facet_ncol = NULL,
                             facet_nrow = NULL,
                             y_limits = NULL,
                             hline = NULL,
                             y_percent = FALSE,
                             title = "",
                             sources = "",
                             last_point = "",
                             theme_extra = NULL) {
  if (!requireNamespace("gghighlight", quietly = TRUE)) {
    stop("plot_lines_facet() n\u00e9cessite le package gghighlight : install.packages(\"gghighlight\")", call. = FALSE)
  }
  p <- ggplot(sample, aes(x = time, y = value, colour = label, group = label)) +
    geom_line(linewidth = 0.8) +
    gghighlight::gghighlight(
      use_direct_label = FALSE,
      unhighlighted_params = list(colour = "grey80", linewidth = 0.4)
    ) +
    facet_wrap(~ label, ncol = facet_ncol, nrow = facet_nrow) +
    scale_colour_manual(values = setNames(series_map$color, series_map$label)) +
    theme_DGT() +
    theme(legend.position = "none") +
    labs(x = NULL, y = NULL)

  if (!is.null(hline)) p <- p + geom_hline(yintercept = hline, color = "black")

  if (y_percent || !is.null(y_limits)) {
    p <- p + scale_y_continuous(
      labels = if (y_percent) scales::percent else ggplot2::waiver(),
      limits = y_limits
    )
  }

  if (title != "") p <- p + labs(title = title)

  caption_layer <- add_caption(sources, last_point)
  if (!is.null(caption_layer)) p <- p + caption_layer

  if (!is.null(theme_extra)) p <- p + theme_extra

  p
}

#' Famille 7 : Barres empilées (contributions) + ligne (variation annuelle totale)
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
plot_contrib <- function(sample, var_annuelle, series_map,
                         total_label = "Variation annuelle",
                         y_percent = TRUE,
                         hline = 0,
                         legend_nrow = NULL,
                         title = "",
                         sources = "",
                         last_point = "",
                         theme_extra = NULL) {
  p <- ggplot() +
    geom_bar(
      data = sample,
      aes(x = time, y = values, fill = label),
      stat = "identity", position = position_stack()
    ) +
    geom_line(
      data = var_annuelle,
      aes(x = time, y = var_annuelle, color = total_label)
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

  p
}
