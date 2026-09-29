# Rendu interactif ggiraph et bouton de téléchargement ------------------------

#' Wrapper pour rendre les graphiques interactifs en HTML avec ggiraph
#'
#' Cette fonction enveloppe un graphique ggplot et le rend interactif uniquement
#' pour les sorties HTML, en conservant le graphique statique pour PDF/Word.
#'
#' La barre d'outils ggiraph est volontairement réduite à 2 boutons :
#' téléchargement de l'image (PNG) et plein écran. Le zoom (molette + boutons)
#' est désactivé : sans bouton pour l'activer/désactiver, un zoom molette actif
#' en arrière-plan surprend plus qu'il n'aide (ex. scroll de page qui zoome le
#' graphique par erreur), et le plein écran répond au même besoin.
#'
#' @param gg_plot Un objet ggplot
#' @param tooltip_css Chaîne CSS pour personnaliser les tooltips (optionnel)
#' @param hover_css Chaîne CSS pour l'effet hover (optionnel)
#' @param hover_inv_opacity Opacité des éléments non survolés (défaut: 0.5)
#' @param hover_r Rayon des éléments survolés (défaut: 2.5)
#' @param height_svg Hauteur du SVG (défaut: 5)
#' @param download_data tibble (ou liste de tibbles compatibles, déjà combinés
#'   avec `dplyr::bind_rows()`) contenant les données sous-jacentes du
#'   graphique. Si fourni, un bouton "Télécharger les données" (CSV) est ajouté
#'   en marge du graphique. NULL (défaut) pour ne pas afficher ce bouton.
#' @param download_filename character, nom de fichier (sans extension) du CSV
#'   téléchargé. Si NULL (défaut), utilise le label du chunk knitr courant
#'   (ex. "fig-demande-credit-treso") quand disponible.
#'
#' @return Un objet girafe (éventuellement accompagné du bouton de
#'   téléchargement des données) pour HTML, ou le ggplot original pour PDF/Word
#'
#' @examples
#' \dontrun{
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point_interactive(aes(tooltip = rownames(mtcars)))
#' render_interactive(p)
#' }
#' @export
render_interactive <- function(gg_plot,
                               tooltip_css = NULL,
                               hover_css = NULL,
                               hover_inv_opacity = 0.5,
                               hover_r = 2.5,
                               height_svg = 5,
                               download_data = NULL,
                               download_filename = NULL) {
  # CSS par défaut pour les tooltips
  if (is.null(tooltip_css)) {
    tooltip_css <- paste0(
      "font-family: Marianne;",
      "background-color: snow;",
      "border-radius: 5px;",
      "border-color: gray;",
      "border-style: solid;",
      "border-width: 0.5px;",
      "font-size: 9pt;",
      "padding: 4px;",
      "box-shadow: 2px 2px 2px gray;"
    )
  }

  # CSS par défaut pour le hover
  if (is.null(hover_css)) {
    hover_css <- glue::glue("r:{hover_r}px;")
  }

  # Créer l'objet girafe
  girafe_obj <- ggiraph::girafe(
    ggobj = gg_plot,
    bg = "transparent",
    height_svg = height_svg
  ) |>
    ggiraph::girafe_options(
      ggiraph::opts_hover_inv(css = glue::glue("opacity:{hover_inv_opacity};")),
      ggiraph::opts_hover(css = hover_css),
      ggiraph::opts_tooltip(css = tooltip_css),
      # Seuls les boutons du groupe "misc" (saveaspng + fullscreen) restent
      # visibles ; on masque le zoom et la sélection.
      ggiraph::opts_toolbar(saveaspng = TRUE, hidden = c("zoom", "selection")),
      ggiraph::opts_sizing(rescale = TRUE, width = 1)
    )

  if (is.null(download_data) || nrow(download_data) == 0) {
    return(girafe_obj)
  }

  download_btn <- build_data_download_button(download_data, download_filename)

  htmltools::browsable(
    htmltools::tags$div(
      class = "chart-download-wrapper",
      download_btn,
      girafe_obj
    )
  )
}

#' Construit un bouton de téléchargement des données sous-jacentes d'un graphique
#'
#' Génère un lien `<a download>` autonome (pas de fichier écrit sur disque,
#' pas de dépendance supplémentaire) pointant vers un CSV "à la française"
#' (séparateur `;`, virgule décimale, encodé en base64 avec BOM UTF-8 pour un
#' affichage correct des accents dans Excel FR). Stylé en `website.scss` pour
#' reprendre l'apparence des icônes de la barre d'outils ggiraph.
#'
#' @param data tibble à exporter
#' @param filename character, nom de fichier sans extension (défaut : label du
#'   chunk knitr courant, ou "donnees_graphique" si indisponible)
#' @return un objet `htmltools::tags$a`
#' @export
build_data_download_button <- function(data, filename = NULL) {
  # Format long (time, value, label) -> large (1 colonne par série) pour un
  # fichier plus lisible dans Excel. Sinon, export tel quel (fallback sûr
  # pour les familles de graphiques aux colonnes moins standardisées).
  export_data <- data
  if (all(c("time", "value", "label") %in% names(data))) {
    export_data <- tidyr::pivot_wider(
      dplyr::select(data, "time", "value", "label"),
      names_from = "label",
      values_from = "value"
    )
  }

  if (is.null(filename)) {
    chunk_label <- tryCatch(knitr::opts_current$get("label"), error = function(e) NULL)
    filename <- if (!is.null(chunk_label)) chunk_label else "donnees_graphique"
  }
  filename <- gsub("[^A-Za-z0-9_-]+", "_", filename)

  csv_b64 <- encode_csv_fr(export_data)

  htmltools::tags$a(
    class = "chart-data-download-btn",
    href = glue::glue("data:text/csv;base64,{csv_b64}"),
    download = glue::glue("{filename}.csv"),
    title = "T\u00e9l\u00e9charger les donn\u00e9es (CSV)",
    "aria-label" = "T\u00e9l\u00e9charger les donn\u00e9es du graphique (CSV)"
  )
}

#' Encode un tibble en CSV "à la française" (séparateur `;`, virgule décimale)
#' encodé en base64 avec BOM UTF-8, pour un lien de téléchargement autonome.
#'
#' @param data tibble à encoder
#' @return character, chaîne base64
#' @noRd
encode_csv_fr <- function(data) {
  # write_csv2 = convention européenne (";", ",") - même logique que write.csv2()
  csv_text <- readr::format_csv2(data, na = "")
  bom <- as.raw(c(0xef, 0xbb, 0xbf))
  csv_bytes <- c(bom, charToRaw(enc2utf8(csv_text)))
  base64enc::base64encode(csv_bytes)
}
