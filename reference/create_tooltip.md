# Fonction helper pour créer des tooltips formatés

Fonction helper pour créer des tooltips formatés

## Usage

``` r
create_tooltip(date, value, unit = NULL, format_date = "month", label = NULL)
```

## Arguments

- date:

  La date

- value:

  La valeur

- unit:

  Unité affichée après la valeur (ex. "%", "Md€") ; NULL pour aucune

- format_date:

  Si on veut la date en mois ou trimestre

- label:

  Le nom de la série

## Value

Une chaîne HTML formatée pour le tooltip
