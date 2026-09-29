# Wrapper pour rendre les graphiques interactifs en HTML avec ggiraph

Cette fonction enveloppe un graphique ggplot et le rend interactif
uniquement pour les sorties HTML, en conservant le graphique statique
pour PDF/Word.

## Usage

``` r
render_interactive(
  gg_plot,
  tooltip_css = NULL,
  hover_css = NULL,
  hover_inv_opacity = 0.5,
  hover_r = 2.5,
  height_svg = 5,
  download_data = NULL,
  download_filename = NULL
)
```

## Arguments

- gg_plot:

  Un objet ggplot

- tooltip_css:

  Chaîne CSS pour personnaliser les tooltips (optionnel)

- hover_css:

  Chaîne CSS pour l'effet hover (optionnel)

- hover_inv_opacity:

  Opacité des éléments non survolés (défaut: 0.5)

- hover_r:

  Rayon des éléments survolés (défaut: 2.5)

- height_svg:

  Hauteur du SVG (défaut: 5)

- download_data:

  tibble (ou liste de tibbles compatibles, déjà combinés avec
  [`dplyr::bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html))
  contenant les données sous-jacentes du graphique. Si fourni, un bouton
  "Télécharger les données" (CSV) est ajouté en marge du graphique. NULL
  (défaut) pour ne pas afficher ce bouton.

- download_filename:

  character, nom de fichier (sans extension) du CSV téléchargé. Si NULL
  (défaut), utilise le label du chunk knitr courant (ex.
  "fig-demande-credit-treso") quand disponible.

## Value

Un objet girafe (éventuellement accompagné du bouton de téléchargement
des données) pour HTML, ou le ggplot original pour PDF/Word

## Details

La barre d'outils ggiraph est volontairement réduite à 2 boutons :
téléchargement de l'image (PNG) et plein écran. Le zoom (molette +
boutons) est désactivé : sans bouton pour l'activer/désactiver, un zoom
molette actif en arrière-plan surprend plus qu'il n'aide (ex. scroll de
page qui zoome le graphique par erreur), et le plein écran répond au
même besoin.

## Examples

``` r
if (FALSE) { # \dontrun{
p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point_interactive(aes(tooltip = rownames(mtcars)))
render_interactive(p)
} # }
```
