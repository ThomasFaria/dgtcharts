# Tableaux gt à la charte ---------------------------------------------------

#' Thème gt à la charte DG Trésor
#'
#' @param gt_tbl Un objet gt
#' @param ref_cols character, colonnes de référence à surligner (NULL pour aucune)
#' @return L'objet gt stylé
#' @export
theme_table_DGT <- function(gt_tbl,
                            ref_cols = NULL) {
  dark_grey <- "#535353"
  light_blue <- "#acd2fb"
  dark_blue <- "#003299"

  gt_tbl <- gt_tbl |>
    # On définit la police selon le format de sortie
    gt::opt_table_font(
      font = "Marianne"
    ) |>
    # Alignement : centrer toutes les colonnes sauf la première
    gt::cols_align(
      align = "center",
      columns = gt::everything()
    ) |>
    gt::cols_align(
      align = "left",
      columns = 1
    ) |>
    # Spanners
    gt::tab_style(
      style = list(
        # gt::cell_borders(sides = "all", dark_blue, "solid", gt::px(1)),
        gt::cell_fill(color = dark_blue),
        gt::cell_text(color = "#FFFFFF", weight = "bold")
      ),
      locations = gt::cells_column_spanners()
    ) |>
    # Column_labels
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "bottom", color = "#000000", "solid", gt::px(1)),
        gt::cell_borders(sides = "top", color = dark_blue, "solid", gt::px(1)),
        gt::cell_fill(color = dark_blue),
        gt::cell_text(color = "#FFFFFF", weight = "bold"),
        gt::cell_borders(sides = "bottom", color = "black", "solid", gt::px(1.5))
      ),
      locations = gt::cells_column_labels()
    ) |>
    # stubhead (colonne de gauche)
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = c("bottom", "top"), color = "red", "solid", gt::px(1)),
        gt::cell_borders(sides = c("bottom", "top"), color = "black", "solid", gt::px(1.5))
      ),
      locations = gt::cells_stubhead()
    ) |>
    # Labels
    gt::tab_style(
      style = list(
        gt::cell_borders(sides = "bottom", color = "transparent", "solid", gt::px(1)),
        gt::cell_borders(sides = "bottom", color = "transparent", "solid", gt::px(1))
      ),
      locations = gt::cells_row_groups()
    ) |>
    # title
    gt::tab_style(
      style = gt::cell_text(weight = "bold"),
      location = gt::cells_title(groups = "title")
    ) |>
    # Source note
    gt::tab_style(
      style = list(
        gt::cell_borders("bottom", "transparent", "solid", gt::px(5)),
        gt::cell_text(align = "center")
      ),
      locations = gt::cells_source_notes()
    ) |>
    # Stub
    gt::tab_style(
      style = list(
        gt::cell_fill(color = "#EEF6FA"),
        gt::cell_text(weight = "bold")
      ),
      locations = gt::cells_stub()
    ) |>
    # Row_stripping (zébrage)
    gt::opt_row_striping(row_striping = TRUE) |>
    # Options pour les footnotes
    gt::opt_footnote_marks(marks = "letters") |>
    # Taille de la police du corps du tableau
    gt::tab_style(
      style = gt::cell_text(size = gt::pct(100)),
      locations = gt::cells_body(columns = gt::everything())
    ) |>
    # Options générales de la table
    gt::tab_options(
      table.font.size = gt::pct(100),
      table.width = gt::pct(100),
      row.striping.background_color = "#EEF6FA",
      table.border.top.color = "transparent",
      ## Heading
      heading.align = "center",
      heading.title.font.size = gt::pct(100),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(100),
      heading.border.bottom.style = "hidden",
      heading.border.bottom.width = gt::px(1),
      heading.border.bottom.color = "#000000",
      ## Labels
      column_labels.border.top.style = "solid",
      column_labels.background.color = "transparent",
      column_labels.font.size = gt::pct(90),
      column_labels.font.weight = "bold",
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.width = gt::px(1.5),
      column_labels.border.bottom.color = "transparent",
      row_group.font.weight = "bold",
      # row_group.border.top.color = "#000000",
      # row_group.border.top.width = gt::px(1),
      row_group.border.bottom.width = gt::px(1),
      row_group.border.bottom.color = "#000000",
      column_labels.border.top.color = "transparent",
      ## Body
      table_body.border.top.style = "solid",
      table_body.border.top.color = "red",
      table_body.border.top.width = gt::px(1),
      table_body.border.bottom.style = "solid",
      table_body.border.bottom.width = gt::px(1.5),
      table_body.border.bottom.color = "#000000",
      ## Stub
      stub_row_group.border.color = "transparent",
      stub.border.color = "#000000",
      stub.border.width = gt::px(1),
      stub.font.size = "bold",
      stub.font.weight = NULL,
      ## Padding
      data_row.padding = gt::px(1),
      row_group.padding = gt::px(2),
      column_labels.padding = gt::px(2),
      summary_row.padding = gt::px(1),
      summary_row.border.width = gt::px(1),
      summary_row.border.color = "#000000",
      grand_summary_row.padding = gt::px(1),
      ## Footnote
      footnotes.background.color = NULL,
      footnotes.font.size = gt::pct(80),
      footnotes.padding = NULL,
      footnotes.marks = "letters",
      ## Source
      source_notes.font.size = gt::pct(80),
      source_notes.padding = NULL,
      source_notes.padding.horizontal = NULL,
      source_notes.border.bottom.style = NULL,
      source_notes.border.lr.style = "none"
    )


  # Surbrillance pour les colonnes de référence (si spécifiées)
  if (!is.null(ref_cols) && length(ref_cols) > 0) {
    gt_tbl <- gt_tbl |>
      gt::tab_style(
        style = gt::cell_fill(color = light_blue),
        locations = list(
          gt::cells_body(columns = gt::all_of(ref_cols))
        )
      )
  }

  gt_tbl
}

#' Fonction générique principale de création de table
#'
#' @param prep_table_data Liste retournée par une fonction prep_table_*() contenant:
#'   - data: tibble avec les données
#'   - col_config: configuration des colonnes (labels, spanners)
#'   - ref_cols: colonnes de référence à surligner
#'   - format_config: configuration du formatage
#'   - metadata: métadonnées (titre, source, styles, etc.)
#'
#' @return Un objet gt (table formatée)
#' @export
create_table_standard <- function(prep_table_data) {
  # Extraction des éléments
  table_data <- prep_table_data$data
  col_config <- prep_table_data$col_config
  ref_cols <- prep_table_data$ref_cols
  format_config <- prep_table_data$format_config
  metadata <- prep_table_data$metadata

  # Création de la table gt de base
  gt_table <- gt::gt(table_data)

  # Application des labels de colonnes
  gt_table <- apply_column_labels(gt_table, col_config$col_labels)

  # Application des spanners (groupes de colonnes)
  if (!is.null(col_config$spanners)) {
    gt_table <- apply_spanners(gt_table, col_config$spanners)
  }

  # Ajout du titre et de la source
  if (!is.null(metadata$title)) {
    gt_table <- gt_table |> gt::tab_header(title = metadata$title)
  }
  if (!is.null(metadata$source)) {
    gt_table <- gt_table |> gt::tab_source_note(source_note = metadata$source)
  }

  # Ajout de la footnote si présente
  if (!is.null(metadata$footnote)) {
    # Si footnote_location est spécifié, l'utiliser, sinon footnote sans location
    if (!is.null(metadata$footnote_location)) {
      gt_table <- gt_table |>
        gt::tab_footnote(
          footnote = metadata$footnote,
          locations = metadata$footnote_location
        )
    } else {
      gt_table <- gt_table |> gt::tab_footnote(footnote = metadata$footnote)
    }
  }

  # Application du formatage (AVANT le thème pour éviter les conflits)
  gt_table <- apply_formatting(gt_table, format_config, table_data)

  # Application du thème DGT (styles visuels seulement, pas de formatage)
  gt_table <- theme_table_DGT(
    gt_table,
    ref_cols = ref_cols
  )

  # Application des styles de lignes (gras, italique, etc.)
  gt_table <- apply_row_styles(gt_table, metadata, table_data)

  # Gestion des valeurs manquantes si nécessaire
  if (!is.null(metadata$handle_missing) && metadata$handle_missing) {
    gt_table <- handle_missing_values(gt_table, metadata)
  }

  gt_table
}

#' Applique les labels aux colonnes
#'
#' @param gt_table Un objet gt
#' @param col_labels Vecteur nommé de labels de colonnes
#'
#' @return L'objet gt avec les labels appliqués
#' @noRd
apply_column_labels <- function(gt_table, col_labels) {
  gt_table |> gt::cols_label(.list = as.list(col_labels))
}

#' Applique les spanners (groupes de colonnes)
#'
#' @param gt_table Un objet gt
#' @param spanners Liste de spanners, chaque élément contient label et columns
#'
#' @return L'objet gt avec les spanners appliqués
#' @noRd
apply_spanners <- function(gt_table, spanners) {
  for (spanner in spanners) {
    gt_table <- gt_table |>
      gt::tab_spanner(
        label = spanner$label,
        columns = spanner$columns
      )
  }
  gt_table
}

#' Applique le formatage des colonnes (nombres, pourcentages, etc.)
#'
#' @param gt_table Un objet gt
#' @param format_config Liste de configuration du formatage avec:
#'   - columns: liste nommée avec le formatage de chaque colonne
#'   - default: formatage par défaut pour les colonnes non spécifiées
#' @param table_data Les données de la table (pour vérifier les colonnes)
#'
#' @return L'objet gt avec le formatage appliqué
#' @noRd
apply_formatting <- function(gt_table, format_config, table_data) {
  # Configuration par défaut
  default_config <- format_config$default %||% list(
    type = "number",
    decimals = 1,
    force_sign = FALSE
  )

  # Obtenir toutes les colonnes numériques de la table
  all_cols <- names(table_data)
  numeric_cols <- all_cols[sapply(table_data, is.numeric)]

  # 1. Appliquer le formatage par défaut sur toutes les colonnes numériques
  if (default_config$type == "number") {
    gt_table <- gt_table |>
      gt::fmt_number(
        columns = tidyselect::where(is.numeric),
        decimals = default_config$decimals %||% 1,
        dec_mark = ",",
        sep_mark = " ",
        force_sign = default_config$force_sign %||% FALSE
      )
  }

  # 2. Appliquer le formatage spécifique colonne par colonne
  if (!is.null(format_config$columns)) {
    for (col_name in names(format_config$columns)) {
      col_config <- format_config$columns[[col_name]]

      # Vérifier que la colonne existe
      if (!col_name %in% all_cols) next

      # Type de formatage
      fmt_type <- col_config$type %||% "number"

      if (fmt_type == "number") {
        # Formatage en nombre
        gt_table <- gt_table |>
          gt::fmt_number(
            columns = !!col_name,
            decimals = col_config$decimals %||% 1,
            dec_mark = ",",
            sep_mark = " ",
            force_sign = col_config$force_sign %||% FALSE,
            scale_by = col_config$scale_by %||% 1
          )
      } else if (fmt_type == "percent") {
        # Formatage en pourcentage
        gt_table <- gt_table |>
          gt::fmt_percent(
            columns = !!col_name,
            decimals = col_config$decimals %||% 1,
            dec_mark = ",",
            force_sign = col_config$force_sign %||% TRUE,
            scale_values = col_config$scale %||% FALSE
          )
      }
    }
  }

  gt_table
}

#' Applique les styles aux lignes (gras, italique, couleurs)
#'
#' @param gt_table Un objet gt
#' @param metadata Métadonnées contenant les règles de style
#' @param table_data Les données de la table
#'
#' @return L'objet gt avec les styles appliqués
#' @noRd
apply_row_styles <- function(gt_table, metadata, table_data) {
  # Lignes en gras (par fonction)
  if (!is.null(metadata$bold_rows) && is.function(metadata$bold_rows)) {
    gt_table <- gt_table |>
      gt::tab_style(
        style = gt::cell_text(weight = "bold"),
        locations = gt::cells_body(rows = metadata$bold_rows(table_data))
      )
  }

  # Lignes en gras (par labels)
  if (!is.null(metadata$bold_labels)) {
    gt_table <- gt_table |>
      gt::tab_style(
        style = gt::cell_text(weight = "bold"),
        locations = gt::cells_body(rows = table_data$label %in% metadata$bold_labels)
      )
  }

  # Lignes en italique (par fonction)
  if (!is.null(metadata$italic_rows) && is.function(metadata$italic_rows)) {
    gt_table <- gt_table |>
      gt::tab_style(
        style = gt::cell_text(style = "italic"),
        locations = gt::cells_body(rows = metadata$italic_rows(table_data))
      )
  }

  # Ligne totale avec fond bleu
  if (!is.null(metadata$total_row)) {
    gt_table <- gt_table |>
      gt::tab_style(
        style = list(
          gt::cell_fill(color = "#003299"),
          gt::cell_text(color = "white", weight = "bold")
        ),
        locations = list(
          gt::cells_body(rows = table_data$label == metadata$total_row)
        )
      )
  }

  # Gestion de la hiérarchie parent-enfant
  if (!is.null(metadata$has_hierarchy) && metadata$has_hierarchy && "parent" %in% names(table_data)) {
    # Cacher la colonne parent
    gt_table <- gt_table |>
      gt::cols_hide(columns = parent)

    # Identifier les lignes enfants (celles qui ont un parent non-NA)
    child_rows <- !is.na(table_data$parent)

    if (any(child_rows)) {
      # On calcule la hiérarchie de chaque enfant
      row_depths <- get_depth(table_data$label, table_data$parent)

      # Style pour les enfants : italique + plus petit + indenté
      gt_table <- gt_table |>
        # Italique et taille réduite à 90%
        gt::tab_style(
          style = list(
            gt::cell_text(style = "italic", size = gt::pct(90))
          ),
          locations = gt::cells_body(rows = child_rows)
        ) |>
        # Indentation (on rajoute 4 espaces pour chaque niveau de hierarchie)
        gt::text_transform(
          locations = gt::cells_body(columns = label),
          fn = function(x) {
            spaces <- vapply(row_depths, function(d) {
              paste0(rep("&nbsp;", d * 4), collapse = "")
            }, "")
            paste0(spaces, x)
          }
        )
    }
  }

  gt_table
}

#' Gère les valeurs manquantes dans la table
#'
#' @param gt_table Un objet gt
#' @param metadata Métadonnées contenant les informations sur les valeurs manquantes
#'
#' @return L'objet gt avec les valeurs manquantes gérées
#' @noRd
handle_missing_values <- function(gt_table, metadata) {
  gt_table <- gt_table |>
    gt::sub_missing(
      columns = gt::everything(),
      missing_text = ""
    )

  # Griser les cellules manquantes si spécifié
  if (!is.null(metadata$missing_cols) && !is.null(metadata$sample_data)) {
    sample <- metadata$sample_data
    for (col in metadata$missing_cols) {
      if (col %in% names(sample)) {
        gt_table <- gt_table |>
          gt::tab_style(
            style = gt::cell_fill(color = "#ebebebe7"),
            locations = gt::cells_body(
              columns = !!col,
              rows = which(is.na(sample[[col]]))
            )
          )
      }
    }
  }

  gt_table
}

#' Calcule la profondeur hiérarchique de chaque ligne
#'
#' @param ids vecteur des libellés de lignes
#' @param parents vecteur des libellés parents (NA pour la racine)
#' @return integer, profondeur de chaque ligne (0 pour la racine)
#' @noRd
get_depth <- function(ids, parents) {
  depths <- setNames(rep(0, length(ids)), ids)
  # On boucle pour remonter la chaîne des parents
  for (i in seq_along(ids)) {
    curr_parent <- parents[i]
    while (!is.na(curr_parent) && curr_parent %in% ids) {
      depths[i] <- depths[i] + 1
      curr_parent <- parents[which(ids == curr_parent)]
    }
  }
  return(unname(depths))
}
