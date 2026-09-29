# Famille 3 : Plusieurs lignes + aire pour le total (version interactive)

Famille 3 : Plusieurs lignes + aire pour le total (version interactive)

## Usage

``` r
plot_lines_area_interactive(
  sample,
  total,
  series_map,
  hline = 0,
  area_alpha = 0.25,
  legend_nrow = NULL,
  total_label = "Total",
  title = "",
  sources = "",
  last_point = "",
  theme_extra = NULL
)
```

## Arguments

- sample:

  tibble avec colonnes: time, value, group

- total:

  tibble avec colonnes: time, value

- series_map:

  tibble avec colonnes: group, color

- hline:

  numeric, valeur de la ligne horizontale (NULL pour aucune ligne)

- area_alpha:

  numeric, transparence de l'aire (0-1)

- legend_nrow:

  integer, nombre de lignes pour la légende (NULL pour automatique)

- total_label:

  character, libellé du Total dans la légende ("Total" par défaut)

- title:

  character, titre du graphique

- sources:

  character, source des données (vide par défaut)

- last_point:

  character, dernier point des données (vide par défaut)

- theme_extra:

  theme ggplot2, thème supplémentaire à ajouter au graphique (NULL par
  défaut)
