# Construit un bouton de téléchargement des données sous-jacentes d'un graphique

Génère un lien `<a download>` autonome (pas de fichier écrit sur disque,
pas de dépendance supplémentaire) pointant vers un CSV "à la française"
(séparateur `;`, virgule décimale, encodé en base64 avec BOM UTF-8 pour
un affichage correct des accents dans Excel FR). Stylé en `website.scss`
pour reprendre l'apparence des icônes de la barre d'outils ggiraph.

## Usage

``` r
build_data_download_button(data, filename = NULL)
```

## Arguments

- data:

  tibble à exporter

- filename:

  character, nom de fichier sans extension (défaut : label du chunk
  knitr courant, ou "donnees_graphique" si indisponible)

## Value

un objet `htmltools::tags$a`
