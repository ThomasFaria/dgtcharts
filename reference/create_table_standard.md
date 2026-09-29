# Fonction générique principale de création de table

Fonction générique principale de création de table

## Usage

``` r
create_table_standard(prep_table_data)
```

## Arguments

- prep_table_data:

  Liste retournée par une fonction prep_table\_\*() contenant:

  - data: tibble avec les données

  - col_config: configuration des colonnes (labels, spanners)

  - ref_cols: colonnes de référence à surligner

  - format_config: configuration du formatage

  - metadata: métadonnées (titre, source, styles, etc.)

## Value

Un objet gt (table formatée)
