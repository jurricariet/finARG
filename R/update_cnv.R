#' Actualiza los datos de ON y Fideicomisos Financieros de CNV
#'
#' Descarga los archivos de series estadísticas del sitio de CNV y actualiza
#' los objetos `on_cnv` y `fideicomisos_financieros_cnv`.
#'
#' @return Nada. Guarda los archivos actualizados en `data/` del paquete.
#' @export
update_cnv <- function() {

  pagina_raw <- httr::content(httr::GET("https://www.cnv.gov.ar/sitioWeb/Informes?columna=4"), as = "text")

  blob_links <- stringr::str_extract_all(pagina_raw, "descargas/informes/blob/[a-zA-Z0-9\\-]+")[[1]]
  blob_links <- paste0("https://www.cnv.gov.ar/", blob_links)

  lista_dataframes <- list()

  for (i in seq_along(blob_links)) {

    destfile <- tempfile(fileext = ".xlsx")

    resp <- try(httr::GET(blob_links[i], httr::write_disk(destfile, overwrite = TRUE)), silent = TRUE)
    if (inherits(resp, "try-error") || resp$status_code != 200) {
      message("No se pudo descargar archivo ", i)
      next
    }

    tipo <- try(readxl::read_excel(destfile, range = "A1", col_names = FALSE)[[1]], silent = TRUE)
    if (inherits(tipo, "try-error")) {
      message("No se pudo leer la celda A1 del archivo ", i)
      tipo <- paste0("Archivo_", i)
    }

    df <- try(readxl::read_excel(destfile), silent = TRUE)
    if (inherits(df, "try-error")) {
      message("No se pudo leer el Excel completo del archivo ", i)
      next
    }

    nombre <- gsub("[^[:alnum:]_]", "_", tolower(tipo))
    if (nombre %in% names(lista_dataframes)) {
      nombre <- paste0(nombre, "_", i)
    }

    lista_dataframes[[nombre]] <- df
  }

  # Procesar ON
  if (!"emision_de_obligaciones_negociables" %in% names(lista_dataframes)) {
    stop("No se encontro el archivo de Obligaciones Negociables en la descarga.")
  }

  df_ON <- lista_dataframes$emision_de_obligaciones_negociables
  colnames(df_ON) <- df_ON[5,]

  on_cnv <- df_ON %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      fecha_colocacion = as.numeric(fecha_colocacion),
      fecha_de_emision_y_liquidacion = as.numeric(fecha_de_emision_y_liquidacion)
    ) %>%
    dplyr::filter(!is.na(fecha_colocacion)) %>%
    dplyr::mutate(
      fecha_colocacion = as.Date(fecha_colocacion, origin = "1899-12-30"),
      fecha_de_emision_y_liquidacion = as.Date(fecha_de_emision_y_liquidacion, origin = "1899-12-30")
    ) %>%
    dplyr::select(-na)

  # Procesar Fideicomisos
  if (!"emision_de_fideicomisos_financieros" %in% names(lista_dataframes)) {
    stop("No se encontro el archivo de Fideicomisos Financieros en la descarga.")
  }

  df_fideico <- lista_dataframes$emision_de_fideicomisos_financieros
  colnames(df_fideico) <- df_fideico[5,]

  fideicomisos_financieros_cnv <- df_fideico %>%
    janitor::clean_names() %>%
    dplyr::mutate(
      fecha_colocacion = as.numeric(fecha_colocacion),
      fecha_de_liquidacion_y_emision = as.numeric(fecha_de_liquidacion_y_emision)
    ) %>%
    dplyr::filter(!is.na(fecha_colocacion)) %>%
    dplyr::mutate(
      fecha_colocacion = as.Date(fecha_colocacion, origin = "1899-12-30"),
      fecha_de_liquidacion_y_emision = as.Date(fecha_de_liquidacion_y_emision, origin = "1899-12-30")
    ) %>%
    dplyr::select(-na)

  save(on_cnv, file = "data/on_cnv.rda", compress = "xz")
  save(fideicomisos_financieros_cnv, file = "data/fideicomisos_financieros_cnv.rda", compress = "xz")

  message("Archivos guardados exitosamente en la carpeta data/")
  invisible(NULL)
}

