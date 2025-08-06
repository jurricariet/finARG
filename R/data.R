#' Datos de indicadores de entidades financieras a partir del BCRA
#'
#' Incluye información desde enero 2011
#' Nota: no se encontraron datos para 2011-2, 2011-6 y 2013-5
#'
#' @format Un dataframe con 6 columnas:
#' \describe{
#'   \item{codigo_de_entidad}{Código de la entidad}
#'   \item{nombre_de_entidad}{Nombre de la entidad}
#'   \item{fecha}{Fecha}
#'   \item{codigo_de_linea}{Código de línea}
#'   \item{descripcion_del_indicador}{descripción del indicador}
#'   \item{valor}{Valor del indicador}
#' }
#' @source BCRA
"indicadores_bancos"

#' Datos del balance resumido de entidades financieras a partir del BCRA
#'
#' Incluye información desde enero 2011
#' Nota: no se encontraron datos para 2011-2, 2011-6 y 2013-5
#'
#' @format Un dataframe con 6 columnas:
#' \describe{
#'   \item{codigo_de_entidad}{Código de la entidad}
#'   \item{nombre_de_entidad}{Nombre de la entidad}
#'   \item{fecha}{Fecha}
#'   \item{codigo_de_linea}{Código de línea}
#'   \item{denominacion_de_la_cuenta}{Nombre de la cuenta}
#'   \item{valor}{Valor de la cuenta}
#' }
#' @source BCRA
"balres"


#' Datos de unidades de servicio por entidad de acuerdo a fechas de alta/baja y ubicación geográfica
#'
#' @format Un dataframe con 13 columnas:
#' \describe{
#'   \item{codigo_entidad}{Código de la entidad}
#'   \item{pais}{País de la unidad}
#'   \item{provincia}{Provincia de la unidad}
#'   \item{partido}{Partido o departamento de la unidad}
#'   \item{localidad}{Localidad de la unidad}
#'   \item{direccion}{Dirección de la unidad}
#'   \item{codigo_de_filial}{Código de filial}
#'   \item{tipo_de_unidad}{Tipo de unidad}
#'   \item{fecha_de_alta}{Fecha de alta de la unidad}
#'   \item{fecha_de_baja}{Fecha de baja de la unidad}
#'   \item{tipo_unidad}{Tipo de unidad}
#'   \item{nombre_entidad}{Nombre de la entidad}
#'   \item{grupo_entidad}{Grupo de la entidad}
#' }
#' @source BCRA
"uniser"
