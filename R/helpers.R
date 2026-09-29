# Utilitaires pour les graphiques ---------------------------------------------

#' Formate une date en français
#'
#' Formate une date selon le type spécifié (jour, mois, trimestre ou semestre) en français.
#'
#' @param date Une date (objet Date)
#' @param format_type "day" pour format journalier, "month" pour format mensuel, "quarter" pour trimestriel, "semester" pour semestriel
#' @return Chaîne de caractères formatée (ex: "12 janvier 2024", "janvier 2024", "T1 2024" ou "S1 2024")
#' @examples
#' \dontrun{
#' format_date_fr(as.Date("2024-03-15"), "day")     # "15 mars 2024"
#' format_date_fr(as.Date("2024-03-15"), "month")   # "mars 2024"
#' format_date_fr(as.Date("2024-03-15"), "quarter") # "T1 2024"
#' format_date_fr(as.Date("2024-03-15"), "semester") # "S1 2024"
#' }
#' @export
format_date_fr <- function(date, format_type = c("month", "quarter", "semester", "day")) {
  format_type <- match.arg(format_type)

  months_fr <- c(
    "janvier", "f\u00e9vrier", "mars", "avril", "mai", "juin",
    "juillet", "ao\u00fbt", "septembre", "octobre", "novembre", "d\u00e9cembre"
  )

  if (format_type == "day") {
    formatted <- paste0(
      as.integer(format(date, "%d")), " ",
      months_fr[as.integer(format(date, "%m"))],
      " ", format(date, "%Y")
    )
  } else if (format_type == "month") {
    formatted <- paste0(
      months_fr[as.integer(format(date, "%m"))],
      " ", format(date, "%Y")
    )
  } else if (format_type == "quarter") {
    quarter <- ceiling(as.integer(format(date, "%m")) / 3)
    formatted <- paste0("T", quarter, " ", format(date, "%Y"))
  } else if (format_type == "semester") {
    semester <- ceiling(as.integer(format(date, "%m")) / 6)
    formatted <- paste0("S", semester, " ", format(date, "%Y"))
  }

  return(formatted)
}

#' Formate la date la plus récente dans un jeu de données
#'
#' Extrait la date la plus récente et la formate en français
#' selon le type (mois, trimestre ou semestre).
#'
#' @param data Data frame contenant une colonne 'time'
#' @param id_col Nom de la colonne d'identifiant pour le regroupement
#' @param format_type "day" pour format journalier, "month" pour format mensuel, "quarter" pour trimestriel, "semester" pour semestriel
#' @return Chaîne de caractères formatée (ex: "12 janvier 2024", "janvier 2024", "T1 2024" ou "S1 2024")
#' @examples
#' \dontrun{
#' get_latest_date(data, "series_key", format_type = "day")
#' get_latest_date(data, "series_key", format_type = "month")
#' }
#' @export
get_latest_date <- function(data, id_col, format_type = c("month", "quarter", "semester", "day")) {
  format_type <- match.arg(format_type)

  latest_date <- data |>
    dplyr::group_by(.data[[id_col]]) |>
    dplyr::summarise(latest_date = max(time, na.rm = TRUE), .groups = "drop") |>
    dplyr::pull(latest_date) |>
    max()

  format_date_fr(latest_date, format_type)
}

#' Cree un tibble de mapping series/labels/couleurs
#'
#' Fonction utilitaire pour creer les series_map de maniere standardisee.
#'
#' @param codes Vecteur des codes de series
#' @param labels Vecteur des labels correspondants
#' @param colors Vecteur des couleurs (utilisant DGT_col)
#' @param ... Colonnes additionnelles a ajouter au tibble
#' @return Tibble avec colonnes code, label, color et eventuellement d'autres
#' @examples
#' \dontrun{
#' create_series_map(
#'   codes = c("CODE1", "CODE2"),
#'   labels = c("Label 1", "Label 2"),
#'   colors = c(DGT_col[1], DGT_col[2])
#' )
#' }
#' @export
create_series_map <- function(codes, labels, colors, ...) {
  tibble::tibble(
    code = codes,
    label = labels,
    color = colors,
    ...
  )
}

#' Fonction helper pour créer des tooltips formatés
#'
#' @param label Le nom de la série
#' @param date La date
#' @param value La valeur
#' @param unit Unité affichée après la valeur (ex. "%", "Md€") ; NULL pour aucune
#' @param format_date Si on veut la date en mois ou trimestre
#'
#' @return Une chaîne HTML formatée pour le tooltip
#' @export
create_tooltip <- function(date, value, unit = NULL, format_date = "month", label = NULL) {
  value_formatted <- format(value, big.mark = " ", decimal.mark = ",")
  date_formatted  <- format_date_fr(date, format_date)
  prefix <- if (!is.null(label)) glue::glue("{label} : ") else ""

  glue::glue(
    "<strong>{date_formatted}</strong><br>",
    "{prefix}{value_formatted} {unit}"
  )
}

#' Ajouter une caption avec sources et dernier point
#'
#' @param sources character, source des données (vide par défaut)
#' @param last_point character, dernier point des données (vide par défaut)
#' @return ggplot2 labs object ou NULL si aucune caption n'est nécessaire
#' @export
add_caption <- function(sources = "", last_point = "") {
  if (sources != "" || last_point != "") {
    caption_parts <- c()
    if (sources != "") caption_parts <- c(caption_parts, paste0("Source : ", sources))
    if (last_point != "") caption_parts <- c(caption_parts, paste0("Dernier point : ", last_point))
    caption_text <- paste(caption_parts, collapse = ". ")
    caption_text <- paste0(caption_text, ".")
    return(labs(caption = caption_text))
  }
  return(NULL)
}

#' Calcule le facteur d'echelle pour les graphiques a double axe
#'
#' Deux modes disponibles :
#' - align_zero = FALSE (defaut) : transformation affine (a, b) qui mappe
#'   l'etendue (min, max) de la serie a scaler sur l'etendue (min, max) de
#'   l'autre serie. Utilise toute la hauteur du graphique mais le zero des
#'   deux axes ne coincide pas forcement.
#' - align_zero = TRUE : transformation purement multiplicative (b = 0), qui
#'   garde le zero aligne entre les deux axes. Utile quand le zero doit rester
#'   visible et comparable (ex: barres qui partent de 0). Dans ce mode, une
#'   des deux series peut ne pas utiliser toute la hauteur du graphique.
#'
#' @param data Data frame contenant les donnees
#' @param group_col Nom de la colonne de regroupement (ex: "measure", "series_key")
#' @param value_col Nom de la colonne des valeurs (ex: "value", "values")
#' @param scaled_group Valeur de group_col correspondant a la serie qui sera
#'   scalee (ex: "bar", ou le label passe en sec_series/scale_measure)
#' @param align_zero logical, si TRUE aligne le zero des deux axes (b = 0)
#' @return list(a = pente, b = ordonnee a l'origine) tel que value_scaled = value * a + b
#' @examples
#' \dontrun{
#' calculate_scale_factor(data, "measure", "value", scaled_group = "bar")
#' calculate_scale_factor(data, "measure", "value", scaled_group = "bar", align_zero = TRUE)
#' }
#' @export
calculate_scale_factor <- function(data, group_col, value_col, scaled_group, align_zero = FALSE) {
  range_series <- data |>
    dplyr::group_by(.data[[group_col]]) |>
    dplyr::summarise(
      min = min(.data[[value_col]], na.rm = TRUE),
      max = max(.data[[value_col]], na.rm = TRUE),
      .groups = "drop"
    )

  scaled_row <- range_series[range_series[[group_col]] == scaled_group, ]
  target_row <- range_series[range_series[[group_col]] != scaled_group, ]

  if (nrow(scaled_row) != 1 || nrow(target_row) != 1) {
    stop("scaled_group doit correspondre a exactement un des deux groupes presents dans group_col")
  }

  if (align_zero) {
    # Transformation multiplicative pure : le zero reste au meme endroit sur les 2 axes
    a <- max(abs(target_row$min), abs(target_row$max)) /
         max(abs(scaled_row$min), abs(scaled_row$max))
    b <- 0
  } else {
    # Transformation affine : maximise l'usage de la hauteur, zero non aligne
    a <- (target_row$max - target_row$min) / (scaled_row$max - scaled_row$min)
    b <- target_row$min - scaled_row$min * a
  }

  list(a = a, b = b)
}
