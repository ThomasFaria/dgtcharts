# dgtcharts

Graphiques et tableaux à la charte de la **Direction générale du Trésor** (non officielle):
thème ggplot2, palette inspirée du DSFR, police Marianne embarquée,
graphiques standardisés statiques et interactifs (ggiraph), tableaux gt.

Développé par le PAESF, utilisé pour le *Flash du financement de l'économie*.

## Installation

```r
renv::install("github::thomasfaria/dgtcharts@v0.1.0")
```

Nécessite **ggplot2 >= 4.0**. La police Marianne est enregistrée automatiquement
au chargement du package si elle n'est pas installée sur le poste.

## Faire un graphique à la charte

```r
library(ggplot2)
library(dgtcharts)

ggplot(economics, aes(date, unemploy / 1000)) +
  geom_line(colour = DGT_col["bleu_france"]) +
  theme_DGT() +
  add_caption(sources = "FRED", last_point = "avril 2015")
```

## Graphiques standardisés

Les fonctions `plot_*()` prennent le format standardisé des `prep_*()` du
Flash : `sample` (`time`, `value`, `label`, `tooltip` pour l'interactif) et
`series_map` (`label`, `color`, `fill` pour les barres).

| Famille | Statique | Interactif (HTML) |
|---|---|---|
| Lignes (double axe possible) | `plot_lines()` | `plot_lines_interactive()` |
| Barres + ligne | `plot_bar_line()` | `plot_bar_line_interactive()` |
| Lignes + aire du total | `plot_lines_area()` | `plot_lines_area_interactive()` |
| Petits multiples | `plot_lines_facet()` | `plot_lines_facet_interactive()` |
| Contributions empilées + total | `plot_contrib()` | `plot_contrib_interactive()` |

Dans un document Quarto :

```r
plot_func <- if (knitr::is_html_output()) plot_lines_interactive else plot_lines
plot_func(res$sample, res$series_map, sources = res$source, last_point = res$latest_value)
```

Outils associés : `create_tooltip()`, `create_series_map()`,
`calculate_scale_factor()` (double axe), `format_date_fr()`,
`get_latest_date()`, `render_interactive()` (pour vos propres ggplot).

Le bouton « Télécharger les données » ajouté par les versions interactives est
stylé par l'extension Quarto `thomasfaria/paesf`
(`website.scss`). Hors de cette extension, il s'affiche sans mise en forme.

## Tableaux

`theme_table_DGT()` applique la charte à une table gt ;
`create_table_standard()` construit la table complète à partir de la liste
renvoyée par une fonction `prep_table_*()` (données, libellés, spanners,
formats, hiérarchie parent/enfant).

## Tests

```r
devtools::test()
```
