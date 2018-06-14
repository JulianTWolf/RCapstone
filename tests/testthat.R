library(testthat)
library(RCapstone)
library(tidyr)
library(dplyr)
library(ggplot2)

context("Test functions in the package")

test_that("geom_timeline returns a 'ggplot' object", {
  g <- data_clean %>% dplyr::filter(COUNTRY %in% c("GREECE", "ITALY"), YEAR > 2000) %>%
    ggplot2::ggplot(ggplot2::aes(x = DATE,
                                 y = COUNTRY,
                                 color = as.numeric(TOTAL_DEATHS),
                                 size = as.numeric(EQ_PRIMARY)
    )) +
    geom_timeline()
  expect_is(g, "ggplot")
})



test_that("eq_map returns a 'leaflet' object", {
  l <- data_clean %>%
    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
    eq_map(annot_col = "DATE")
  expect_is(l, "leaflet")
})

test_that("eq_create_label returns a 'character' vector", {
  expect_is(eq_create_label(data_clean), "character")
})


