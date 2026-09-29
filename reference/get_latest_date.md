# Formate la date la plus récente dans un jeu de données

Extrait la date la plus récente et la formate en français selon le type
(mois, trimestre ou semestre).

## Usage

``` r
get_latest_date(
  data,
  id_col,
  format_type = c("month", "quarter", "semester", "day")
)
```

## Arguments

- data:

  Data frame contenant une colonne 'time'

- id_col:

  Nom de la colonne d'identifiant pour le regroupement

- format_type:

  "day" pour format journalier, "month" pour format mensuel, "quarter"
  pour trimestriel, "semester" pour semestriel

## Value

Chaîne de caractères formatée (ex: "12 janvier 2024", "janvier 2024",
"T1 2024" ou "S1 2024")

## Examples

``` r
if (FALSE) { # \dontrun{
get_latest_date(data, "series_key", format_type = "day")
get_latest_date(data, "series_key", format_type = "month")
} # }
```
