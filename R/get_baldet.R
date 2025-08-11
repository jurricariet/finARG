#' Actualiza los datos de balance detallado del BCRA
#'
#' Carga el balance detallado de todas las entidades para el periodo seleccionado desde la web del BCRA.
#' La carga puede demorar para periodos extensos debido al peso de cada archivo.
#'
#' @param fecha_inicio Fecha de inicio de los datos (por defecto "2025-01-01")
#' @param fecha_fin Fecha del ultimo dato (por defecto fecha actual)
#' @return Dataframe con los datos de balance detallado
#' @export
get_baldet <- function(fecha_inicio = "2025-01-01", fecha_fin = Sys.Date()) {

  # ---- Leer formato baldete ----
  # Tomamos el formato del ultimo archivo disponible
  url_formato <- "https://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/Entidades/202504d.7z"
  temp_file_fmt <- tempfile(fileext = ".7z")
  temp_dir_fmt <- tempdir()

  utils::download.file(url_formato, destfile = temp_file_fmt, mode = "wb", quiet = TRUE)
  archive::archive_extract(temp_file_fmt,
                           file = "Entfin/Tec_Cont/baldet/formato.txt",
                           dir = temp_dir_fmt)

  formato_baldet <- utils::read.table(
    file.path(temp_dir_fmt, "Entfin/Tec_Cont/baldet/formato.txt"),
    header = FALSE, sep = "\t", fileEncoding = "latin1"
  )

  # ---- Generar secuencia de fechas ----
  fechas_seq <- seq(as.Date(fecha_inicio), as.Date(fecha_fin), by = "month")
  fechas_vec <- format(fechas_seq, "%Y%m")
  urls <- paste0("https://www.bcra.gob.ar/Pdfs/PublicacionesEstadisticas/Entidades/", fechas_vec, "d.7z")

  # ---- Funcion interna para leer cada archivo ----
  leer_balance_det <- function(url) {
    base::cat("Procesando:", url, "\n")
    temp_file <- tempfile(fileext = ".7z")
    temp_dir <- tempdir()

    tryCatch({
      utils::download.file(url, destfile = temp_file, mode = "wb", quiet = TRUE)
      contenido <- archive::archive(temp_file)

      nombre_base <- sub(".*/", "", url)
      nombre_base <- sub("\\.7z$", "", nombre_base)
      rutas_posibles <- c(
        file.path("Entfin", "Tec_Cont", "baldet", "COMPLETO.TXT"),
        file.path(nombre_base, "Entfin", "Tec_Cont", "baldet", "COMPLETO.TXT")
      )
      archivo_target <- rutas_posibles[rutas_posibles %in% contenido$path]

      if (length(archivo_target) == 0) {
        base::cat("No se encontro COMPLETO.TXT en", url, "\n")
        return(NULL)
      }

      archive::archive_extract(temp_file, file = archivo_target[1], dir = temp_dir)
      archivo_extraido <- file.path(temp_dir, archivo_target[1])

      if (!file.exists(archivo_extraido) || file.info(archivo_extraido)$size == 0) {
        base::cat("Archivo vacio o inexistente en", url, "\n")
        return(NULL)
      }

      utils::read.table(archivo_extraido, header = FALSE, sep = "\t", encoding = "latin1", quote = "\"")

    }, error = function(e) {
      base::cat("Error procesando", url, ":", e$message, "\n")
      return(NULL)
    })
  }

  # ---- Descargar todos los periodos ----
  lista_balance <- purrr::map(urls, leer_balance_det)
  lista_df <- purrr::keep(lista_balance, is.data.frame)
  lista_df <- purrr::map(lista_df, ~ { .x$V1 <- as.numeric(.x$V1); .x })
  df_balance <- dplyr::bind_rows(lista_df)

  # ---- Asignar nombres de columnas segun formato ----
  colnames(df_balance) <- formato_baldet$V3[1:7]
  colnames(df_balance)[4] <- "codigo_cuenta"

  df_final <- janitor::clean_names(df_balance)

  return(df_final)
}

