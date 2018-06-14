library(dplyr)
library(tidyr)
library(stringr)

#' Creates popup text for markers.
#'
#' This function takes the dataset as an argument and creates an HTML label that can be used as the annotation text
#' in the leaflet map. This function should put together a character string for each earthquake that will show the
#' cleaned location (as cleaned by the eq_location_clean() function), the magnitude (EQ_PRIMARY), and the
#' total number of deaths (TOTAL_DEATHS), with boldface labels for each ("Location", "Total deaths", and "Magnitude").
#'
#' @param eq_clean The clean earthquake data in a tbl_df object.
#' @return This function returns a character vector containing popup text to be used in a leaflet visualization.
#'
#' @examples
#' \dontrun{
#' data_clean %>%
#' dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#' dplyr::mutate(popup_text = eq_create_label(.)) %>%
#' eq_map(annot_col = "popup_text")
#' }
#'
#' @export

eq_create_label <- function(eq_clean=NULL) {

  #test that correct columns are present
  all_columns <- colnames(eq_clean)

  stopifnot(any('LOCATION_NAME' %in% all_columns),any('EQ_PRIMARY' %in% all_columns),
            any('TOTAL_DEATHS' %in% all_columns))

  #Creating the "popup_text" without using NA
  data <- eq_clean %>% dplyr::select(LOCATION_NAME, EQ_PRIMARY, TOTAL_DEATHS) %>%
    dplyr::mutate(new_LOCATION_NAME = ifelse(is.na(LOCATION_NAME), LOCATION_NAME, paste0("<b>Location:</b> ", LOCATION_NAME,"<br />"))) %>%
    dplyr::mutate(new_EQ_PRIMARY = ifelse(is.na(EQ_PRIMARY), EQ_PRIMARY, paste0("<b>Magnitude:</b> ", EQ_PRIMARY,"<br />"))) %>%
    dplyr::mutate(new_TOTAL_DEATHS = ifelse(is.na(TOTAL_DEATHS), TOTAL_DEATHS, paste0("<b>Total Deaths:</b> ", TOTAL_DEATHS))) %>%
    tidyr::unite('popup_values',c('new_LOCATION_NAME','new_EQ_PRIMARY','new_TOTAL_DEATHS'),sep ='') %>%
    dplyr::mutate(popup_values = stringr::str_replace_all(popup_values,"[,]*NA[,]*","")) %>%
    dplyr::mutate(popup_values = ifelse(popup_values=="","All Values are NA",popup_values))

  popup_values <- dplyr::collect(dplyr::select(data,.dots=c('popup_values')))[[1]]

  return(popup_values)

}
