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

#' Datos de emisiones de obligaciones negociables publicado por la CNV. Datos desde 2015.
#'
#' @format Un dataframe con 12 columnas:
#' \describe{
#'   \item{fecha_colocacion}{Fecha de colocación de la ON}
#'   \item{fecha_de_emision_y_liquidacion}{Fecha de liquidación de la ON}
#'   \item{sociedad}{Nombre de la sociedad emisora}
#'   \item{serie_clase}{Serie/clase de la ON}
#'   \item{moneda}{Moneda}
#'   \item{monto_nominal_moneda_emision}{Monto nominal de la emisión}
#'   \item{regimen_de_emision}{Régimen de la emisión}
#'   \item{tipo_de_tasa}{Tipo de tasa}
#'   \item{precio_de_corte}{Precio de corte}
#'   \item{tna_inicial}{TNA inicial}
#'   \item{tir_inicial}{TIR inicial}
#'   \item{plazo_meses}{Plazo en meses}
#' }
#' @source CNV
"on_cnv"

#' Datos de constitución de fideicomisos financieros desde 2015 publicado por CNV.
#'
#' @format Un dataframe con 13 columnas:
#' \describe{
#'   \item{fecha_colocacion}{Fecha de colocación}
#'   \item{fecha_de_liquidacion_y_emision}{Fecha de emisión y liquidación del fideicomiso}
#'   \item{fiduciario}{Nombre del fiduciario}
#'   \item{fiduciante}{Nombre del fiduciante}
#'   \item{denominacion_f_f}{Denominación del fideicomiso financiero}
#'   \item{moneda}{Moneda}
#'   \item{monto_nominal_ff_moneda_emision}{Monto nominal de la emisión}
#'   \item{categoria}{Categoría}
#'   \item{precio_de_corte_vrd_senior}{Precio de corte}
#'   \item{tipo_de_tasa}{Tipo de tasa}
#'   \item{tna_inicial_vrd_senior}{TNA inicial VRD senior}
#'   \item{tir_vrd_senior}{TIR VRD senior}
#'   \item{plazo_ff_meses}{Plazo en meses}
#' }
#' @source CNV
"on_cnv"
