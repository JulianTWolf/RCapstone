library(testthat)
library(RCapstone)

context("Test functions in the package")

data_raw <<- readr::read_delim("/Users/julian/Documents/07 Sonstiges/R-Projekte/RCapstone/signif.txt.tsv", col_names=T, delim = "\t")
data_clean <- eq_clean_data(eq_location_clean(data_raw))

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


