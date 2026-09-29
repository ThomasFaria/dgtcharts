# Famille 5 : petits multiples (une série par facette, les autres en fond gris) — version interactive

Famille 5 : petits multiples (une série par facette, les autres en fond
gris) — version interactive

## Usage

``` r
plot_lines_facet_interactive(
  sample,
  series_map,
  facet_ncol = NULL,
  facet_nrow = NULL,
  y_limits = NULL,
  hline = NULL,
  y_percent = FALSE,
  title = "",
  sources = "",
  last_point = "",
  theme_extra = NULL,
  height_svg = 5
)
```

## Arguments

- sample:

  tibble avec colonnes: time, value, label, tooltip

- series_map:

  tibble avec colonnes: label, color

- facet_ncol, facet_nrow:

  integer, disposition des facettes

- y_limits:

  numeric(2), bornes de l'axe Y (NULL pour automatique)

- hline:

  numeric, valeur de la ligne horizontale de référence (NULL pour
  aucune)

- y_percent:

  logical, formater l'axe Y en pourcentage

- title:

  character, titre du graphique

- sources:

  character, source des données (vide par défaut)

- last_point:

  character, dernier point des données (vide par défaut)

- theme_extra:

  theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par
  défaut)

- height_svg:

  numeric, hauteur du SVG (5 par défaut)
