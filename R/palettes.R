#' Generate a palette of related colors around a central color
#'
#' @param central_color a single color value around which to build the palette
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
build_palette <- function(central_color) {

  central_hsv <- grDevices::rgb2hsv(grDevices::col2rgb(central_color))

  central_hue <- central_hsv[1,1]
  central_sat <- central_hsv[2,1]
  central_val <- central_hsv[3,1]

  hue_set <- seq(central_hue - 0.049,central_hue + 0.05,0.001)
  hue_set[hue_set < 0] <- 1 + hue_set[hue_set < 0]
  hue_set[hue_set > 1] <- hue_set[hue_set > 1] - 1

  if(central_val > 0.8) {
    central_val <- 0.8
  } else if(central_val < 0.4) {
    central_val <- 0.4
  }
  val_set <- rep(seq(central_val - 0.25, central_val + 0.2, 0.05),10)

  colorset <- grDevices::hsv(h = hue_set,
                             s = central_sat,
                             v = val_set)

  set_nums <- c(68,10,65,50,100,35,84,38,14)

  colorset_plot_data <- data.frame(x = rep(1:10,each = 10),
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
    ggplot2::scale_color_identity()

  palette <- colorset[set_nums]

  palette_plot_data <- data.frame(x = 1:9, y = 1, fill = palette, number = set_nums)

  palette_plot <- ggplot2::ggplot(palette_plot_data) +
    ggplot2::geom_tile(ggplot2::aes(x = x, y = y, fill = fill)) +
    ggplot2::geom_text(ggplot2::aes(x = x, y = y, label = number)) +
    ggplot2::scale_fill_identity()

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
#'
#' @return a character vector of hex color values of length n_colors.
#' @export
#'
varibow <- function(n_colors) {
  sats <- rep_len(c(0.55,0.7,0.85,1),length.out = n_colors)
  vals <- rep_len(c(1,0.8,0.6),length.out = n_colors)
  sub("FF$","",grDevices::rainbow(n_colors, s = sats, v = vals))
}
