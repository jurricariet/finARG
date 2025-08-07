#' Obtiene el detalle de unidades de servicio por entidad
#'
#'  Permite filtrar por entidad para obtener sucursales, casas matrices y otros tipos de unidad por fecha de alta/baja y ubicacion geografica
#'
#' @param entidad Nombre (o parte del nombre) de la entidad (ej: "Galicia"). Por defecto trae todas.
#' @param codigo_entidad Codigo(s) exacto(s) de la entidad. Opcional.
#' @return Un dataframe filtrado.
#' @export
get_uniser <- function( entidad = NULL, codigo_entidad = NULL) {
  # Dataset cargado por LazyData
  df_filtrado <- uniser

  # Filtrar por nombre de entidad si se especifica
  if (!is.null(entidad)) {
    df_filtrado <- dplyr::filter(df_filtrado, grepl(entidad, nombre_entidad, ignore.case = TRUE))
  }

  # Filtrar por codigo de entidad si se especifica
  if (!is.null(codigo_entidad )) {
    df_filtrado <- dplyr::filter(df_filtrado, codigo_entidad  %in% !!codigo_entidad )
  }

  return(df_filtrado)
}
