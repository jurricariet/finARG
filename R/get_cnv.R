#' Obtiene series estadísticas de la CNV
#'
#' En base a la elección de la serie (ON, fideicomisos financieros), se filtra el período de emisiones para obtener la serie.
#'
#' @param serie Tipo de instrumento: "ON" (obligaciones negociables) o "fideicomisos".
#' @param periodo Vector de fechas en formato "YYYY-MM". Puede ser un solo valor, un rango (dos valores) o múltiples fechas.
#' @return Un dataframe filtrado.
#' @export
get_cnv <- function(serie = c("ON", "fideicomisos"), periodo = NULL) {
  # Validación de input
  serie <- match.arg(serie)

  # Cargar el dataset correspondiente
  data <- if (serie == "fideicomisos") fideicomisos_financieros_cnv else on_cnv

  # Asegurar que fecha_emision sea Date
  data <- dplyr::mutate(data, fecha_colocacion = as.Date(fecha_colocacion))

  # Crear columna periodo en formato "YYYY-MM"
  data <- dplyr::mutate(data, periodo_colocacion = format(fecha_colocacion, "%Y-%m"))

  # Determinar períodos a filtrar
  if (is.null(periodo)) {
    return(dplyr::filter(data,periodo_colocacion == max(periodo_colocacion)))  # Devuelve último período
  } else if (length(periodo) == 1) {
    periodos_filtrar <- periodo
  } else if (length(periodo) == 2) {
    # Interpretar como rango
    periodos_filtrar <- data$periodo_colocacion[
      data$periodo_colocacion >= min(periodo) & data$periodo_colocacion <= max(periodo)
    ]
  } else {
    # Lista de períodos específicos
    periodos_filtrar <- periodo
  }

  # Filtrar
  df_filtrado <- dplyr::filter(data, periodo_colocacion %in% periodos_filtrar)

  return(df_filtrado)
}
