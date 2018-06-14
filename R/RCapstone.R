#' Mastering Software Development in R Specialization Capstone Project
#' The goal of the capstone project is to integrate the skills developed
#' over the courses in this Specialization and to build a software package that can be used
#' to work with the NOAA Significant Earthquakes dataset.
#' Author: Julian Wolf


#' Loading required packages
library(tidyr)
library(dplyr)
library(devtools)
library(purrr)

#' Reading the NOAA earthquake data file
#' data_raw <<- readr::read_delim("/Users/julian/Documents/07 Sonstiges/R-Projekte/RCapstone/signif.txt.tsv", col_names=T, delim = "\t")

#' Function for cleaning the NOAA earthquake data file
#'
#' @param x is the dataframe of NOAA earthquake data
#' @return a dataframe which contains the Eathquake data with a date column created by uniting the year, month, day
#' and converting it to the Date class, furthermore LATITUDE, LONGITUDE and EQ_PRIMARY columns are converted to numeric class
#' @importFrom tidyr
#' @examples
#'\dontrun{
#' eq_clean_data(data_loc_clean)
#' }
#' @export
eq_clean_data <- function(x){
  data_clean <<- x %>%
    mutate(DAY = ifelse(is.na(DAY), 1, DAY), MONTH = ifelse(is.na(MONTH), 1, MONTH), LONGITUDE = as.numeric(LONGITUDE),
           LATITUDE = as.numeric(LATITUDE), EQ_PRIMARY = as.numeric(EQ_PRIMARY)) %>%
    mutate(DATE = purrr::pmap(list(YEAR, MONTH, DAY),
                              function(y, m, d) {
                                if (y < 0) {

                                  first_date <- as.numeric(as.Date('0 1 1', '%Y %m %d', origin = '1970-01-01'))

                                  mirror_date <-as.Date(paste(y * -1 - 1, 1, 1, sep = '-'), '%Y-%m-%d', origin = '1970-01-01')
                                  dt <- as.numeric(mirror_date) - first_date

                                  end_of_year_dt <- as.numeric(as.Date(paste(y * -1 + 2, 12, 31, sep = '-'), '%Y-%m-%d', origin = '1970-01-01')) -
                                    as.numeric(as.Date(paste(y * -1 + 2, m, d, sep = '-'), '%Y-%m-%d', origin = '1970-01-01'))
                                  DATE <- as.Date(first_date - dt - end_of_year_dt + 1, origin = '1970-01-01')
                                } else {
                                  DATE <- as.Date(paste(y, m, d, sep = '-'), '%Y-%m-%d')
                                }
                                DATE
                              })) %>% mutate(DATE = unlist(DATE), DATE = as.Date(DATE, origin = '1970-01-01'))
}

#' Clean Earthquake Location Field
#'
#' The function takes a data frame of NOAA earthquake data and cleans
#' the LOCATION_NAME field. It removes the country name (of form
#' "COUNTRY:" from the LOCATION_NAME data, and converts the remainder of the field
#' to Title Case. This will make the location name easier to read when plotting
#' and mapping.
#'
#' @param x A data frame of NOAA significant earthquake data.
#' @return A dataframe with the same supplied data, but with the
#'   LOCATION_NAME variable cleaned up to remove the country name that is
#'   supplied in the COUNTRY variable and convert
#'   the remainder of the words in LOCATION_NAME to Title Case.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' data_loc_clean <- eq_location_clean(data_raw)
#' }



eq_location_clean <- function(x){
  data_loc_clean <<- x %>% mutate(LOCATION_NAME = purrr::map2_chr(COUNTRY, LOCATION_NAME,
                                                            function(COUNTRY, LOCATION_NAME) {
                                                              gsub(paste0(COUNTRY, ":"), '', LOCATION_NAME)
                                                            }),
                            LOCATION_NAME = stringr::str_trim(LOCATION_NAME),
                            LOCATION_NAME = stringr::str_to_title(LOCATION_NAME)
  )
}
