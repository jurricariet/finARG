#' Actualiza los datos de unidades de servicio del BCRA
#'
#' Verifica que exista un cambio en el excel uniser y, de existir, guarda la nueva
#' versión en el objeto `uniser.rda`.
#'
#' @return Nada. Guarda el archivo actualizado en `data/` del paquete.
#' @export
update_uniser <- function() {
  library(tidyverse)
  library(lubridate)
  library(readxl)
  library(janitor)

  message("🔄 Verificando actualización de datos UNISER...")

  # Cargar archivo anterior si existe
  path_rda <- "data/uniser.rda"
  uniser_antiguo <- NULL
  if (file.exists(path_rda)) {
    load(path_rda)  # carga el objeto "uniser"
    uniser_antiguo <- uniser
    message("Achivo anterior cargado.")
  } else {
    message("ℹ️ No existe un archivo anterior. Se descargará el actual por primera vez.")
  }

  # Descargar nuevo archivo desde la web
  url_uniser <- "https://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/uniser.xls"
  temp_file <- tempfile(fileext = ".xls")
  download.file(url_uniser, destfile = temp_file, mode = "wb", quiet = TRUE)

  # También cargar el archivo de entidades (para el join)
  url_entser <- "http://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/entser.xls"
  temp_ent <- tempfile(fileext = ".xls")
  download.file(url_entser, destfile = temp_ent, mode = "wb", quiet = TRUE)

  ent_ser <- read_excel(temp_ent, sheet = 2, skip = 20)
  ent_ser_ultimo <- ent_ser %>%
    group_by(ent011) %>%
    filter(ent014 == max(ent014))

  # Códigos de unidades
  cod_unidad <- data.frame(
    stringsAsFactors = FALSE,
    tipo_unidad_cod = c(1L,2L,3L,4L,5L,6L,7L,8L,9L,10L,13L,14L,15L,20L,21L,22L,23L,24L,25L,26L,27L,31L,32L,33L,34L,35L,37L),
    tipo_unidad = c("Casa Central","Casa Matriz","Sucursal","Agencia","Delegación","Oficina","Agencia móvil",
                    "Filiales autorizadas sólo compra/venta moneda extranjera","Filiales cerradas",
                    "Filiales operativas en el exterior","Oficina Atención Transitoria",
                    "Dependencia especial de atención - agencia","Dependencia especial de atención - oficina",
                    "Anexo operativo","Local para desarrollar determinadas actividades",
                    "Cajeros automáticos (fuera de las casas operativas)",
                    "Otras (autorizadas expresamente por BCRA)","Dependencias en empresas de clientes",
                    "Cajeros automáticos dentro de las casas operativas",
                    "Terminales de autoservicio dentro de las casas operativas","Otros dispositivos automáticos",
                    "Casa central no operativa","Oficina administrativa","Anexo no operativo",
                    "Oficina de representación en el exterior","Otros puestos de promoción",
                    "Agencias complementarias de servicios financieros")
  )

  # Leer nuevo archivo
  uniser_nuevo <- read_excel(temp_file, sheet = 2, skip = 19) %>%
    clean_names() %>%
    filter(!is.na(entidad)) %>%
    mutate(
      fecha_alta = ymd(fecha_de_alta),
      fecha_baja = ymd(fecha_de_baja)
    ) %>%
    left_join(ent_ser_ultimo, by = c("entidad" = "ent011")) %>%
    left_join(cod_unidad, by = c("tipo_de_unidad" = "tipo_unidad_cod")) %>%
    select(
      codigo_entidad = entidad,
      pais, provincia, partido, localidad, direccion,
      codigo_de_filial, tipo_de_unidad, fecha_alta, fecha_baja,
      tipo_unidad, nombre_entidad = ent012, grupo_entidad = ent013
    )

  # Comparar con el anterior
  if (!is.null(uniser_antiguo)) {
    iguales <- all.equal(uniser_nuevo, uniser_antiguo, ignore_col_order = TRUE, ignore_row_order = TRUE)

    if (isTRUE(iguales)) {
      message("✅ No hay cambios en el archivo UNISER. No se actualizó.")
      return(invisible(NULL))
    }
  }

  # Guardar nuevo archivo si no es igual
  uniser <- uniser_nuevo  # para que se llame igual que en .rda
  save(uniser, file = path_rda, compress = "xz")
  message("📁 Datos UNISER actualizados exitosamente.")
}
