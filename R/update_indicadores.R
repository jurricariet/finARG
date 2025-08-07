#' Actualiza los datos de indicadores financieros del BCRA
#'
#' Verifica que exista un archivo en la fecha siguiente a la última y lo agrega al
#' objeto `indicadores_bancos.rda`.
#'
#' @return Nada. Guarda el archivo actualizado en `data/` del paquete.
#' @export
update_indicadores <- function() {
  library(lubridate)
  library(dplyr)
  library(readr)
  library(archive)

  if (file.exists("data/indicadores_bancos.rda")) {
    load("data/indicadores_bancos.rda")  # Carga objeto 'indicadores_bancos'
  } else {
    message("ℹ️ No existe el archivo indicadores_bancos.rda. No se puede actualizar.")
    return(invisible(NULL))
  }

  if (nrow(indicadores_bancos) > 0) {
    ultima_fecha <- max(as.integer(indicadores_bancos$fecha))
  } else {
    message("ℹ️ No existe el archivo a actualizar")
  }

  anio <- as.integer(substr(ultima_fecha, 1, 4))
  mes <- as.integer(substr(ultima_fecha, 5, 6))
  fecha_siguiente <- format(ymd(sprintf("%04d%02d01", anio, mes)) %m+% months(1), "%Y%m")

  nombre_archivo <- paste0(fecha_siguiente, "d.7z")
  url <- paste0("https://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/Entidades/", nombre_archivo)

  cat("Indicadores financieros (indicadores_bancos). Última actualización: ",ultima_fecha,"\n","🔍 Buscando actualización para:", fecha_siguiente, "\n")

  temp_file <- tempfile(fileext = ".7z")
  temp_dir <- tempdir()

  descargado <- tryCatch({
    download.file(url, destfile = temp_file, mode = "wb", quiet = TRUE)
    TRUE
  }, error = function(e) FALSE)

  # Validar existencia, tamaño y que no sea HTML
  if (!descargado || file.info(temp_file)$size < 1000) {
    message("ℹ️ No hay actualización disponible para", fecha_siguiente, ".")
    return(invisible(NULL))
  }

  # Leer primeras líneas como texto para detectar HTML
  primeras_lineas <- readLines(temp_file, warn = FALSE, n = 10)
  if (any(grepl("<html", tolower(primeras_lineas)))) {
    message("ℹ️ No hay actualización disponible para indicadores_bancos.")
    return(invisible(NULL))
  }

  cat("✅ Archivo descargado. Leyendo contenido...\n")

  ruta_objetivo <- "Entfin/Tec_Cont/indicad/completo.txt"
  archivos <- tryCatch(archive(temp_file), error = function(e) {
    message("⚠️ No se pudo leer el archivo como .7z. Puede estar corrupto.")
    return(NULL)
  })

  if (is.null(archivos) || !ruta_objetivo %in% archivos$path) {
    message("⚠️ No se encontró el archivo completo.txt en el .7z")
    return(invisible(NULL))
  }

  archive_extract(temp_file, file = ruta_objetivo, dir = temp_dir)
  archivo_extraido <- file.path(temp_dir, ruta_objetivo)

  nuevo_df <- read_delim(
    archivo_extraido,
    delim = "\t",
    col_names = FALSE,
    locale = locale(encoding = "Latin1"),
    show_col_types = FALSE
  ) %>%
    select(1:5, 10)

  colnames(nuevo_df) <- colnames(indicadores_bancos)

  if (!any(indicadores_bancos$fecha == fecha_siguiente)) {
    indicadores_bancos_actualizado <- bind_rows(indicadores_bancos, nuevo_df)
    save(indicadores_bancos_actualizado, file = "data/indicadores_bancos.rda", compress = "xz")
    cat("Datos de ", fecha_siguiente, " agregados exitosamente.\n")
  } else {
    cat("⚠️ Ya existen datos para ", fecha_siguiente, ". No se agregaron duplicados.\n")
  }

  invisible(NULL)
}

