#' Obtiene indicadores de entidades por período y entidad
#'
#' Filtra el dataset de indicadores financieros del BCRA por períodos seleccionados, entidad (por nombre o código) e indicador (por código).
#'
#' @param periodos Vector de períodos en formato "YYYY-MM". Si se pasan dos valores, se interpreta como rango.
#' @param entidad Nombre (o parte del nombre) de la entidad (ej: "Galicia"). Por defecto trae todas.
#' @param codigo_entidad Código(s) exacto(s) de la entidad. Opcional.
#' @param codigo_indicador Código(s) exacto(s) del indicador. Opcional.
#' @return Un dataframe filtrado.
#' @export
get_indicadores <- function(periodos = NULL, entidad = NULL, codigo_entidad = NULL, codigo_indicador = NULL) {
  # Dataset cargado por LazyData
  data <- indicadores_bancos

  # Crear columna periodo en formato "YYYY-MM"
  data <- dplyr::mutate(data, periodo = paste0(substr(fecha,1,4),'-',substr(fecha,5,6)))

  # Determinar períodos a filtrar
  if (is.null(periodos)) {
    # Si no se especifica período, tomar el último
    periodos_filtrar <- max(data$periodo)
  } else if (length(periodos) == 1) {
    # Período puntual
    periodos_filtrar <- periodos
  } else if (length(periodos) == 2) {
    # Interpretar como rango
    periodos_filtrar <- data$periodo[data$periodo >= min(periodos) & data$periodo <= max(periodos)]
  } else {
    # Lista de períodos específicos
    periodos_filtrar <- periodos
  }

  # Filtrar por período
  df_filtrado <- dplyr::filter(data, periodo %in% periodos_filtrar)

  # Filtrar por nombre de entidad si se especifica
  if (!is.null(entidad)) {
    df_filtrado <- dplyr::filter(df_filtrado, grepl(entidad, nombre_de_entidad, ignore.case = TRUE))
  }

  # Filtrar por código de entidad si se especifica
  if (!is.null(codigo_entidad )) {
    df_filtrado <- dplyr::filter(df_filtrado, codigo_de_entidad  %in% !!codigo_entidad )
  }

  # Filtrar por código de indicador si se especifica
  if (!is.null(codigo_indicador )) {
    df_filtrado <- dplyr::filter(df_filtrado, codigo_de_linea  %in% !!codigo_indicador )
  }

  return(df_filtrado)
}
