# Calcule le facteur d'echelle pour les graphiques a double axe

Deux modes disponibles :

- align_zero = FALSE (defaut) : transformation affine (a, b) qui mappe
  l'etendue (min, max) de la serie a scaler sur l'etendue (min, max) de
  l'autre serie. Utilise toute la hauteur du graphique mais le zero des
  deux axes ne coincide pas forcement.

- align_zero = TRUE : transformation purement multiplicative (b = 0),
  qui garde le zero aligne entre les deux axes. Utile quand le zero doit
  rester visible et comparable (ex: barres qui partent de 0). Dans ce
  mode, une des deux series peut ne pas utiliser toute la hauteur du
  graphique.

## Usage

``` r
calculate_scale_factor(
  data,
  group_col,
  value_col,
  scaled_group,
  align_zero = FALSE
)
```

## Arguments

- data:

  Data frame contenant les donnees

- group_col:

  Nom de la colonne de regroupement (ex: "measure", "series_key")

- value_col:

  Nom de la colonne des valeurs (ex: "value", "values")

- scaled_group:

  Valeur de group_col correspondant a la serie qui sera scalee (ex:
  "bar", ou le label passe en sec_series/scale_measure)

- align_zero:

  logical, si TRUE aligne le zero des deux axes (b = 0)

## Value

list(a = pente, b = ordonnee a l'origine) tel que value_scaled = value
\* a + b

## Examples

``` r
if (FALSE) { # \dontrun{
calculate_scale_factor(data, "measure", "value", scaled_group = "bar")
calculate_scale_factor(data, "measure", "value", scaled_group = "bar", align_zero = TRUE)
} # }
```
