#' Lista de indicadores financieros disponibles en el txt Entfin/Tec_Cont/indicad
#'
#' Devuelve un dataframe con el código y nombre de los indicadores disponibles.
#'
#' @return Un dataframe con columnas: codigo_indicador, nombre_indicador.
#' @export
indicadores_codigos <- function() {
  data <- indicadores_bancos

  indicadores_unicos <- dplyr::distinct(data, codigo_de_linea, descripcion_del_indicador)

  return(indicadores_unicos)
}
