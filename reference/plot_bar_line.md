# Famille 2 : Graphique barres + ligne avec double axe

Famille 2 : Graphique barres + ligne avec double axe

## Usage

``` r
plot_bar_line(
  sample,
  series_map,
  scaleFactor = NULL,
  scale_measure = NULL,
  y_percent = FALSE,
  y_percent_sec = FALSE,
  hline = NULL,
  title = "",
  sources = "",
  last_point = "",
  theme_extra = NULL
)
```

## Arguments

- sample:

  tibble avec colonnes: time, value, measure ("bar" ou "line"), label

- series_map:

  tibble avec colonnes: label, color, fill

- scaleFactor:

  list(a=, b=), transformation affine pour le double axe (NULL si pas de
  double axe)

- scale_measure:

  character, "bar" ou "line" - indique quelle mesure scaler (obligatoire
  si scaleFactor non NULL)

- y_percent:

  logical, formater l'axe Y en pourcentage

- y_percent_sec:

  logical, formater l'axe Y secondaire en pourcentage (si dual_axis)

- hline:

  numeric, valeur de la ligne horizontale (NULL pour aucune ligne)

- title:

  character, titre du graphique

- sources:

  character, source des données (vide par défaut)

- last_point:

  character, dernier point des données (vide par défaut)

- theme_extra:

  theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par
  défaut)
