library(dplyr)
library(tidyr)
library(ggplot2)
library(grid)

#' Funcion for adding the Earthquakes's Location labels to an Earthquake's timeline
#'
#' geom_timeline_label works best when used with
#' geom_timeline, labeling the top earthquakes, by
#' magnitude, with a specified label field.  By default, the labels are for
#' the top 5 earthquakes for each country specified, however, the user may
#' adjust this with the n_max aesthetic.
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
#' @return the Earthquake's labels
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(ggplot2)
#'
#' data_clean %>%
#'   dplyr::filter(COUNTRY %in% c('USA', 'UK')) %>%
#'   dplyr::filter(DATE > '2000-01-01') %>%
#'   ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY)) +
#'   geom_timeline() +
#'   geom_timeline_label(aes(x = DATE, y = COUNTRY, magnitude = EQ_PRIMARY, label = LOCATION_NAME))
#'   }

geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", na.rm = FALSE,
                                show.legend = NA, inherit.aes = FALSE)
{
  ggplot2::layer(geom = GeomTimelineLabel, mapping = mapping, data = data, stat = stat, position = position,
                 show.legend = show.legend, inherit.aes = inherit.aes, params = list(na.rm = na.rm))
}

#' GeomTimelineLabel
#'
#' See \code{\link{geom_timeline_label}} for description.
#'
#' @format NULL
#' @usage NULL
#' @export
#'
GeomTimelineLabel <- ggplot2::ggproto("GeomTimelineLabel", ggplot2::Geom,
                                      required_aes = c('x', 'label', 'magnitude'),
                                      default_aes = ggplot2::aes(n_max = 5, y = 0, color = 'grey50', linetype = 1, alpha = 0.5),
                                      draw_key = ggplot2::draw_key_point,
                                      draw_panel = function(data, panel_scales, coord) {

                                        # get to n earthquakes by magnitude
                                        n_max <- data$n_max[1]

                                        data <- data %>%
                                          dplyr::group_by("group") %>%
                                          dplyr::top_n(n = n_max, wt = data$magnitude) %>%
                                          dplyr::ungroup()

                                        # Transform the data
                                        coords <- coord$transform(data, panel_scales)

                                        #1) Creating the location in the timelines (X-axis) where the location names will be placed
                                        Timeline_seg_grobs <- grid::segmentsGrob(x0 = grid::unit(coords$x, "npc"),
                                                                                 y0 = grid::unit(coords$y, "npc"),
                                                                                 x1 = grid::unit(coords$x, "npc"),
                                                                                 y1 = grid::unit(coords$y + 0.06/length(unique(coords$y)), "npc"),
                                                                                 default.units = "npc",
                                                                                 arrow = NULL,
                                                                                 name = NULL,
                                                                                 gp = grid::gpar(),
                                                                                 vp = NULL)

                                        #2) Adding the text to the grid
                                        Earthquake_text_grobs <- grid::textGrob(label = coords$label,
                                                                                x = unit(coords$x, "npc"),
                                                                                y = unit(coords$y + 0.06/length(unique(coords$y)), "npc"),
                                                                                rot = 45,
                                                                                just = "left",
                                                                                gp = grid::gpar(fontsize = 8))

                                        # Plotting the Eartquakes location label over the timeline
                                        grid::gTree(children = grid::gList(Timeline_seg_grobs, Earthquake_text_grobs))

                                      }
)

