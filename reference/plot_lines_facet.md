# Famille 6 : Lignes en facets avec highlight (une série mise en couleur par facet, autres en grisé)

Famille 6 : Lignes en facets avec highlight (une série mise en couleur
par facet, autres en grisé)

## Usage

``` r
plot_lines_facet(
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
  theme_extra = NULL
)
```

## Arguments

- sample:

  tibble avec colonnes: time, value, label

- series_map:

  tibble avec colonnes: label, color

- facet_ncol:

  integer, nombre de colonnes dans facet_wrap (NULL pour automatique)

- facet_nrow:

  integer, nombre de lignes dans facet_wrap (NULL pour automatique)

- y_limits:

  numeric vecteur c(min, max) pour fixer les limites de l'axe Y (NULL
  pour automatique)

- hline:

  numeric, valeur de la ligne horizontale de référence (NULL pour
  aucune)

- y_percent:

  logical, formater l'axe Y en pourcentage (scale = 1, suffix = " %")

- title:

  character, titre du graphique

- sources:

  character, source des données (vide par défaut)

- last_point:

  character, dernier point des données (vide par défaut)

- theme_extra:

  theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par
  défaut)
