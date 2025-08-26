#' Actualiza los datos de balance resumido del BCRA
#'
#' Verifica que exista un archivo en la fecha siguiente a la ultima y lo agrega al
#' objeto `balres.rda`.
#'
#' @return Nada. Guarda el archivo actualizado en `data/` del paquete.
#' @export
update_balres <- function() {

  if (file.exists("data/balres.rda")) {
    load("data/balres.rda")  # Carga objeto 'balres'
  } else {
    message("No existe el archivo a actualizar.")
    return(invisible(NULL))
  }

  if (nrow(balres) > 0) {
    ultima_fecha <- max(as.integer(balres$fecha))
  } else {
    message("El archivo balres esta vacio. No se puede actualizar.")
    return(invisible(NULL))
  }

  anio <- as.integer(substr(ultima_fecha, 1, 4))
  mes <- as.integer(substr(ultima_fecha, 5, 6))
  fecha_siguiente <- format(lubridate::ymd(sprintf("%04d%02d01", anio, mes)) %m+% months(1), "%Y%m")

  nombre_archivo <- paste0(fecha_siguiente, "d.7z")
  url <- paste0("https://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/Entidades/", nombre_archivo)

  temp_file <- tempfile(fileext = ".7z")
  temp_dir <- tempdir()

  descargado <- tryCatch({
    utils::download.file(url, destfile = temp_file, mode = "wb", quiet = TRUE)
    TRUE
  }, error = function(e) FALSE)

  if (!descargado || file.info(temp_file)$size < 1000) {
    message("No hay actualizacion disponible para ", fecha_siguiente, ".")
    return(invisible(NULL))
  }

  primeras_lineas <- readLines(temp_file, warn = FALSE, n = 10)
  if (any(grepl("<html", stringr::str_to_lower(primeras_lineas)))) {
    message("No hay actualizacion disponible para balres.")
    return(invisible(NULL))
  }

  cat("Archivo descargado. Leyendo contenido...\n")

  ruta_objetivo <- "Entfin/Tec_Cont/balres/COMPLETO.TXT"
  archivos <- tryCatch(archive::archive(temp_file), error = function(e) {
    message("No se pudo leer el archivo como .7z. Puede estar corrupto.")
    return(NULL)
  })

  if (is.null(archivos) || !ruta_objetivo %in% archivos$path) {
    message("No se encontro el archivo COMPLETO.TXT en el .7z")
    return(invisible(NULL))
  }

  archive::archive_extract(temp_file, file = ruta_objetivo, dir = temp_dir)
  archivo_extraido <- file.path(temp_dir, ruta_objetivo)

  nuevo_df <- readr::read_delim(
    archivo_extraido,
    delim = "\t",
    col_names = FALSE,
    locale = readr::locale(encoding = "Latin1"),
    show_col_types = FALSE
  ) %>%
    dplyr::select(1:5, 10)

  colnames(nuevo_df) <- colnames(balres)

  if (!any(balres$fecha == fecha_siguiente)) {
    balres_actualizado <- dplyr::bind_rows(balres, nuevo_df)
    balres <- balres_actualizado
    save(balres, file = "data/balres.rda", compress = "xz")
    cat("Datos de ", fecha_siguiente, " agregados exitosamente.\n")
  } else {
    cat("Ya existen datos para ", fecha_siguiente, ". No se agregaron duplicados.\n")
  }

  invisible(NULL)
}
