#' Generate a palette of related colors around a central color
#'
#' @param central_color a single color value around which to build the palette
#' @param n_colors the number of colors to return in the primary palette (max = 100, default = 10)
#' @param hue_range how much variation in hue is allowed in the palette (range = 0 to 1, default = 0.1)
#' @param val_range how much variation in value is allowed in the palette (range = 0 to 1, default = 0.45)
#'
#'
#' @return a list of palette results, containing:
#' \itemize{
#' \item palette: a character vector with a 10-color palette realted to the central_color.
#' \item palette_plot: a ggplot2 object showing the 10 colors in palette.
#' \item colorset: A character vector with the full set of 100 colors from which the palette was selected.
#' \item colorset_plot: A ggplot2 object displaying all 100 colors in the colorset.
#' \item weave: a ggplot2 object generated with weave_plot() showing the intersection of all of the collors in the palette.
#' }
#' @export
#'
build_palette <- function(central_color,
                          n_colors = 10,
                          hue_range = 0.1,
                          sat_range = 0.4,
                          val_range = 0.45) {

  central_hsv <- grDevices::rgb2hsv(grDevices::col2rgb(central_color))

  central_hue <- central_hsv[1,1]
  central_sat <- central_hsv[2,1]
  central_val <- central_hsv[3,1]

  hue_set <- seq(central_hue - hue_range / 2,
                 central_hue + hue_range / 2,
                 length.out = 100)

  hue_set[hue_set < 0] <- 1 + hue_set[hue_set < 0]
  hue_set[hue_set > 1] <- hue_set[hue_set > 1] - 1


  if(central_sat > 1 - sat_range / 2) {
    central_sat <- 1 - sat_range / 2
  } else if(central_sat < sat_range / 2) {
    central_sat <- sat_range / 2
  }

  sat_set <- seq(central_sat - sat_range / 2,
                 central_sat + sat_range / 2,
                 length.out = 10)

  sat_set[sat_set < 0] <- 0
  sat_set[sat_set > 1] <- 1

  sat_set <- rep(c(sat_set, rev(sat_set)),
                 5)

  if(central_val > 1 - val_range / 2) {
    central_val <- 1 - val_range / 2
  } else if(central_val < val_range / 2) {
    central_val <- val_range / 2
  }

  val_set <- seq(central_val - val_range / 2,
                     central_val + val_range / 2,
                     length.out = 10)

  val_set[val_set < 0] <- 0
  val_set[val_set > 1] <- 1

  val_set <- rep(c(val_set, rev(val_set)),
                 5)

  colorset <- grDevices::hsv(h = hue_set,
                             s = sat_set,
                             v = val_set)

  set_nums <- quantile(1:100,
                       probs = seq(0, 1, length.out = n_colors))
  set_nums <- round(set_nums, 0)
  #set_nums <- c(68,10,65,50,100,35,84,38,14)

  colorset_plot_data <- data.frame(x = rep(1:10, each = 10),
                                   y = rep(1:10, 10),
                                   fill = colorset,
                                   number = 1:100)

  colorset_plot_data$color <- ifelse(colorset_plot_data$number %in% set_nums,
                                     "white",
                                     "black")

  colorset_plot <- ggplot2::ggplot(colorset_plot_data) +
    ggplot2::geom_tile(ggplot2::aes(x = x, y = y, fill = fill)) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = y, label = number, color = color)) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_color_identity() +
    ggplot2::theme_void()

  palette <- colorset[set_nums]

  palette_plot_data <- data.frame(x = 1:n_colors, y = 1, fill = palette, number = set_nums)

  palette_plot <- ggplot2::ggplot(palette_plot_data) +
    ggplot2::geom_tile(ggplot2::aes(x = x, y = y, fill = fill)) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = y, label = number)) +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void()

  weave <- weave_plot(palette)

  results <- list(palette = palette,
                  palette_plot = palette_plot,
                  colorset = colorset,
                  colorset_plot = colorset_plot,
                  weave = weave)
}


#' Generate a rainbow palette with variation in saturation and value
#'
#' @param n_colors The number of colors to generate
#' @param alpha Opacity of color from 0 to 1; Default is NULL, which omits alpha.
#'
#' @return a character vector of hex color values of length n_colors.
#' @export
#'
varibow <- function(n_colors, alpha = NULL) {
  sats <- rep_len(c(0.55,0.7,0.85,1),length.out = n_colors)
  vals <- rep_len(c(1,0.8,0.6),length.out = n_colors)
  grDevices::rainbow(n_colors, s = sats, v = vals, alpha = alpha)
}
