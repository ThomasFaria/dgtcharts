# Famille 6 : Barres empilées (contributions) + ligne (variation annuelle totale) — version interactive

Famille 6 : Barres empilées (contributions) + ligne (variation annuelle
totale) — version interactive

## Usage

``` r
plot_contrib_interactive(
  sample,
  var_annuelle,
  series_map,
  total_label = "Variation annuelle",
  y_percent = TRUE,
  hline = 0,
  legend_nrow = NULL,
  title = "",
  sources = "",
  last_point = "",
  theme_extra = NULL
)
```

## Arguments

- sample:

  tibble avec colonnes: time, values (contribution décimale), label,
  tooltip

- var_annuelle:

  tibble avec colonnes: time, var_annuelle (taux décimal), tooltip

- series_map:

  tibble avec colonnes: label, color

- total_label:

  character, libellé de la ligne totale dans la légende

- y_percent:

  logical, formater l'axe Y en pourcentage

- hline:

  numeric, valeur de la ligne horizontale (NULL pour aucune)

- legend_nrow:

  integer, nombre de lignes pour la légende

- title:

  character, titre du graphique

- sources:

  character, source des données

- last_point:

  character, dernier point des données

- theme_extra:

  theme ggplot2 supplémentaire
