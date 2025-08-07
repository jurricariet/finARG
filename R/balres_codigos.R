#' Lista de cuentas del balance resumido disponible en el txt Entfin/Tec_Cont/balres
#'
#' Devuelve un dataframe con el codigo y nombre de las cuentas disponibles.
#'
#' @return Un dataframe con columnas: codigo_de_linea, denominacion_de_la_cuenta
#' @export
balres_codigos <- function() {
  data <- balres

  balres_unicos <- dplyr::distinct(data, codigo_de_linea, denominacion_de_la_cuenta)

  return(balres_unicos)
}
