# Thème ggplot2 à la charte DG Trésor

Police Marianne (embarquée dans le package), axes gris foncé, légende en
bas sans titre, cadre gris clair, palette discrète
[DGT_col](https://thomasfaria.github.io/dgtcharts/reference/DGT_col.md)
par défaut.

## Usage

``` r
theme_DGT()
```

## Value

Un objet `theme` ggplot2.

## Details

**Effet de bord** : comme dans le Flash, la fonction fixe l'épaisseur
par défaut des géométries `line` et `segment` à 1 pour toute la session
([`ggplot2::update_geom_defaults()`](https://ggplot2.tidyverse.org/reference/update_defaults.html)).

Nécessite ggplot2 \>= 4.0 (`theme_sub_*()`, `palette.colour.discrete`).

## Examples

``` r
library(ggplot2)
# La police Marianne est enregistrée via systemfonts : l'afficher avec un
# device compatible (ragg, svglite, ou dev = "svg" dans Quarto), pas pdf().
p <- ggplot(economics, aes(date, unemploy)) +
  geom_line(colour = DGT_col["bleu_france"]) +
  theme_DGT()
```
