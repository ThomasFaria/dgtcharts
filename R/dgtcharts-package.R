#' dgtcharts : graphiques et tableaux à la charte DG Trésor
#'
#' Thème ggplot2 ([theme_DGT()]), palette ([DGT_col]), police Marianne
#' embarquée, graphiques standardisés statiques (`plot_*()`) et interactifs
#' (`plot_*_interactive()`, via ggiraph) et tableaux gt
#' ([theme_table_DGT()], [create_table_standard()]).
#'
#' Les graphiques prennent en entrée le format standardisé des fonctions
#' `prep_*()` du Flash : `sample(time, value, label[, tooltip])` et
#' `series_map(label, color[, fill])`.
#'
#' @keywords internal
"_PACKAGE"

#' @import ggplot2
#' @import ggiraph
#' @importFrom stats setNames
NULL

`%||%` <- function(x, y) if (is.null(x)) y else x
