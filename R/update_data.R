#' Ejecuta todas las funciones de actualización de datos del paquete
#'
#' Llama en orden a las funciones update_XXX() que descargan y procesan datos de las distintas fuentes.
#'
#' @return Nada. Ejecuta funciones con efecto de escritura en la carpeta `data/`.
#' @export
update_data <- function() {
  message("🔄 Iniciando actualización de todas las fuentes de datos...\n")

  tryCatch(update_balres(), error = function(e) message("⚠️ Error en update_balres(): ", e$message))
  tryCatch(update_indicadores(), error = function(e) message("⚠️ Error en update_indicadores(): ", e$message))
  tryCatch(update_uniser(), error = function(e) message("⚠️ Error en update_uniser(): ", e$message))
  tryCatch(update_cnv(), error = function(e) message("⚠️ Error en update_cnv(): ", e$message))

  message("\n✅ Actualización completa.")
}
