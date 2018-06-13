library(ggplot2)

#' Function to build a layer for plotting a time line of earthquakes ranging from xmin to xmaxdates with a point for each earthquake.
#'
#' @importFrom ggplot2 layer
#'
#' @param mapping Set of aesthetic mappings created by aes or aes_. If specified and inherit.aes = TRUE (the default), it is combined with the default mapping at the top level of the plot. You must supply mapping if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three options: If NULL, the default, the data is inherited from the plot data as specified in the call to ggplot. A data.frame, or other object, will override the plot data. All objects will be fortified to produce a data frame. See fortify for which variables will be created. A function will be called with a single argument, the plot data. The return value must be a data.frame., and will be used as the layer data.
#' @param stat The statistical transformation to use on the data for this layer, as a string.
#' @param position Position adjustment, either as a string, or the result of a call to a position adjustment function.
#' @param na.rm If FALSE, the default, missing values are removed with a warning. If TRUE, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends? NA, the default, includes if any aesthetics are mapped. FALSE never includes, and TRUE always includes.
#' @param inherit.aes If FALSE, overrides the default aesthetics, rather than combining with them. This is most useful for helper functions that define both data and aesthetics and shouldn't inherit behaviour from the default plot specification, e.g. borders.
#'
#' @export
#' @examples
#' library(dplyr)
#' library(ggplot2)
#'
#' data_clean %>%
#'   dplyr::filter(COUNTRY %in% c('USA', 'UK')) %>%
#'   dplyr::filter(DATE > '2000-01-01') %>%
#'   ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY)) +
#'   geom_timeline()
geom_timeline <- function(mapping = NULL, data = NULL, stat = 'identity',
                           position = 'identity', na.rm = FALSE,
                           show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)

  )
}

#'Funcion for ploting an Earthquake's Location timeline building a GEOM Function from scratch

GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::Geom, required_aes = c('x'),
  default_aes = ggplot2::aes(y = 0, size = 1, color = 'grey50', alpha = 0.5, shape = 19, stroke = 0.5, fill = NA),
  draw_key = ggplot2::draw_key_point,
  draw_panel = function(data, panel_scales, coord) {
    coords <- coord$transform(data, panel_scales)
    coords$size <- coords$size / 3
    grid::pointsGrob(x = coords$x, y = coords$y, pch = coords$shape, gp = grid::gpar(col = coords$colour, alpha = coords$alpha, cex = coords$size
    ))
    }
)
