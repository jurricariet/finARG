#' Lista de entidades disponibles
#'
#' Devuelve un dataframe con el código y nombre de las entidades disponibles.
#'
#' @return Un dataframe con columnas: codigo_entidad, nombre_de_entidad.
#' @export
entidades_codigos <- function() {
  data <- indicadores_bancos

  entidades_unicas <- dplyr::distinct(data, codigo_de_entidad, nombre_de_entidad)

  return(entidades_unicas)
}
