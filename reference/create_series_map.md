# Cree un tibble de mapping series/labels/couleurs

Fonction utilitaire pour creer les series_map de maniere standardisee.

## Usage

``` r
create_series_map(codes, labels, colors, ...)
```

## Arguments

- codes:

  Vecteur des codes de series

- labels:

  Vecteur des labels correspondants

- colors:

  Vecteur des couleurs (utilisant DGT_col)

- ...:

  Colonnes additionnelles a ajouter au tibble

## Value

Tibble avec colonnes code, label, color et eventuellement d'autres

## Examples

``` r
if (FALSE) { # \dontrun{
create_series_map(
  codes = c("CODE1", "CODE2"),
  labels = c("Label 1", "Label 2"),
  colors = c(DGT_col[1], DGT_col[2])
)
} # }
```
