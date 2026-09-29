#' Palette de couleurs DG Trésor (inspirée du DSFR)
#'
#' Vecteur nommé de 18 couleurs. Utiliser les noms plutôt que les positions
#' (`DGT_col["bleu_france"]`, `DGT_col[c("bleu_france", "rouge_marianne")]`).
#' Ne jamais coder une couleur en dur dans un graphique.
#'
#' @format Vecteur nommé de codes hexadécimaux.
#' @export
#' @examples
#' DGT_col[c("bleu_france", "rouge_marianne")]
DGT_col <- c(
  bleu_france    = "#000091", # 1. Bleu France (token DSFR)
  rouge_marianne = "#E1000F", # 2. Rouge Marianne (token DSFR)
  vert_succes    = "#18753C", # 3. Vert succès (token DSFR)
  orange_vif     = "#CC4A00", # 4. Orange vif (dérivé DSFR)
  violet         = "#6A1F7C", # 5. Violet (dérivé DSFR)
  vert_cyan      = "#009081", # 6. Vert cyan (dérivé DSFR)
  avertissement  = "#B34000", # 7. Avertissement (token DSFR)
  rose_magenta   = "#C9297E", # 8. Rose / magenta (dérivé DSFR)
  bleu_info      = "#0078F3", # 9. Bleu info (token DSFR)
  vert_olive     = "#6E7A2E", # 10. Vert olive (dérivé DSFR)
  gris_ardoise   = "#53657D", # 11. Gris ardoise (dérivé DSFR)
  bordeaux       = "#8B0029", # 12. Bordeaux (dérivé DSFR)
  bleu_lien      = "#0063CB", # 13. Bleu lien (token DSFR)
  bleu_azur      = "#5770BE", # 14. Bleu azur (dérivé DSFR)
  vert_clair     = "#5E9A26", # 15. Vert clair (dérivé DSFR)
  brun_terre     = "#7C5B37", # 16. Brun terre (dérivé DSFR)
  gris_clair     = "#929292", # 17. Gris clair (token DSFR)
  noir           = "#161616" # 18. Bleu nuit / noir (token DSFR)
)

#' Thème ggplot2 à la charte DG Trésor
#'
#' Police Marianne (embarquée dans le package), axes gris foncé, légende en
#' bas sans titre, cadre gris clair, palette discrète [DGT_col] par défaut.
#'
#' **Effet de bord** : comme dans le Flash, la fonction fixe l'épaisseur par
#' défaut des géométries `line` et `segment` à 1 pour toute la session
#' (`ggplot2::update_geom_defaults()`).
#'
#' Nécessite ggplot2 >= 4.0 (`theme_sub_*()`, `palette.colour.discrete`).
#'
#' @return Un objet `theme` ggplot2.
#' @export
#' @examples
#' library(ggplot2)
#' # La police Marianne est enregistrée via systemfonts : l'afficher avec un
#' # device compatible (ragg, svglite, ou dev = "svg" dans Quarto), pas pdf().
#' p <- ggplot(economics, aes(date, unemploy)) +
#'   geom_line(colour = DGT_col["bleu_france"]) +
#'   theme_DGT()
theme_DGT <- function() {
  dark_grey <- "#535353"
  light_grey <- "#D9D9D9"
  dark_blue <- "#003299"
  font_family <- "Marianne"

  size_text <- 16
  size_title <- 17
  size_subtitle <- 16
  size_caption <- 14
  size_strip <- 14
  line_size <- 1
  tick_length <- 7
  default_linewidth <- 1

  update_geom_defaults("line", list(linewidth = default_linewidth))
  update_geom_defaults("segment", list(linewidth = default_linewidth))

  theme_minimal() %+replace%
    theme_sub_axis(
      line = element_line(color = dark_grey, linewidth = line_size),
      ticks = element_line(color = dark_grey, linewidth = line_size),
      ticks.length = unit(tick_length, "pt"),
    ) +
    theme_sub_axis_x(
      title = element_blank(),
      text = element_text(
        family = font_family,
        size = size_text,
        margin = margin(t = 0.1, unit = "cm")
      ),
    ) +
    theme_sub_axis_left(
      title = element_blank(),
      text = element_text(family = font_family, size = size_text, hjust = 1),
    ) +
    theme_sub_axis_right(
      title = element_blank(),
      text = element_text(family = font_family, size = size_text, hjust = 0),
    ) +
    theme_sub_legend(
      margin = margin(t = -0.3, b = 0.1, unit = "cm"),
      text = element_text(family = font_family, size = size_text, colour = dark_grey),
      title = element_blank(),
      position = "bottom"
    ) +
    theme_sub_panel(
      background = element_rect(
        colour = light_grey,
        linewidth = line_size
      )
    ) +
    theme_sub_plot(
      caption = element_text(
        family = font_family,
        hjust = 0,
        size = size_caption,
        colour = dark_grey
      ),
      subtitle = element_text(family = font_family, size = size_subtitle, colour = dark_grey),
      title = element_text(
        family = font_family,
        size = size_title,
        face = "bold",
        colour = dark_grey,
        hjust = 0.5
      ),
      # margin = margin(l = 0, t = 0.1, r = 0.2, b = 0, unit = "cm")
    ) +
    theme_sub_strip(
      text.x = element_text(family = font_family, size = size_strip, colour = dark_grey),
      text.y = element_text(family = font_family, size = size_strip, colour = dark_grey),
    ) +
    theme(
      text = element_text(family = font_family),
      palette.colour.discrete = DGT_col,
    )
}
