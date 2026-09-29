# Famille 1 : Graphique lignes

Famille 1 : Graphique lignes

## Usage

``` r
plot_lines(
  sample,
  series_map,
  scaleFactor = NULL,
  sec_series = NULL,
  y_percent = FALSE,
  y_percent_sec = FALSE,
  hline = NULL,
  legend_nrow = NULL,
  title = "",
  sources = "",
  last_point = "",
  theme_extra = NULL
)
```

## Arguments

- sample:

  tibble avec colonnes: time, value, label

- series_map:

  tibble avec colonnes: label, color

- scaleFactor:

  list(a=, b=), transformation affine pour le double axe (NULL si pas de
  double axe)

- sec_series:

  character, nom du label de la série à mettre sur l'axe secondaire
  (obligatoire si scaleFactor non NULL)

- y_percent:

  logical, formater l'axe Y en pourcentage

- y_percent_sec:

  logical, formater l'axe Y secondaire en pourcentage (si dual_axis)

- hline:

  numeric, valeur de la ligne horizontale (NULL pour aucune ligne)

- legend_nrow:

  integer, nombre de lignes pour la légende (NULL pour automatique)

- title:

  character, titre du graphique

- sources:

  character, source des données (vide par défaut)

- last_point:

  character, dernier point des données (vide par défaut)

- theme_extra:

  theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par
  défaut)
