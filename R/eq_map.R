library(leaflet)

#' Earthquakes Data in an Interactive Map.
#'
#' The Earthquakes will be mapped centered with their latitude and
#' longitude "epicenter". The epicenter is annotated based on an annot_col which the user can specify.
#' In addition, if the user specifies "popup_text" then a call to eq_create_label generates
#' the appropriate text for the popup.
#'
#' @references \url{http://rstudio.github.io/leaflet/}
#'
#' @param eq_clean The clean earthquake data in a tbl_df object.
#' @param annot_col Column in the tbl_df object to be used for annotation.
#'
#' @return This function returns an interactive map.
#'
#' @note If an invalid column name is provided, the function provides a warning
#' and uses the LOCATION_NAME column as the annotation column.
#'
#' @import leaflet
#'
#' @examples
#' \dontrun{
#'
#' data_clean %>%
#' dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#' eq_map(annot_col = "DATE")
#' }
#'
#' @export

eq_map <- function(eq_clean = NULL, annot_col = "DATE"){

  #test that correct columns are present
  all_columns <- colnames(eq_clean)

  stopifnot(any('DATE' %in% all_columns),any('LATITUDE' %in% all_columns),
            any('LONGITUDE' %in% all_columns),any('EQ_PRIMARY' %in% all_columns))

  #check to see if invalid column provided - print message and default to DATE
  if(!(any(annot_col %in% all_columns))) {
    warning("Invalid Column - DATE Displayed")
    annot_col = "DATE"
  }

  #call to leaflet
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(data = eq_clean, lng = ~ LONGITUDE, lat = ~ LATITUDE, radius = ~ EQ_PRIMARY,
                              weight=1, fillOpacity = 0.2, popup =~ paste(get(annot_col)))

}
