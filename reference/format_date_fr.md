# Formate une date en français

Formate une date selon le type spécifié (jour, mois, trimestre ou
semestre) en français.

## Usage

``` r
format_date_fr(date, format_type = c("month", "quarter", "semester", "day"))
```

## Arguments

- date:

  Une date (objet Date)

- format_type:

  "day" pour format journalier, "month" pour format mensuel, "quarter"
  pour trimestriel, "semester" pour semestriel

## Value

Chaîne de caractères formatée (ex: "12 janvier 2024", "janvier 2024",
"T1 2024" ou "S1 2024")

## Examples

``` r
if (FALSE) { # \dontrun{
format_date_fr(as.Date("2024-03-15"), "day")     # "15 mars 2024"
format_date_fr(as.Date("2024-03-15"), "month")   # "mars 2024"
format_date_fr(as.Date("2024-03-15"), "quarter") # "T1 2024"
format_date_fr(as.Date("2024-03-15"), "semester") # "S1 2024"
} # }
```
