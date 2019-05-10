#' Fade colors by reducing Value in HSV space
#'
#' @param color_vec a vector of hex or R colors
#' @param deval_frac numeric (0 to 1) - the amount to subtract from Value in HSV
#' @param val_floor numeric (0 to 1) - a minimum Value to retain for each color
#'
#' @return a character vector of faded hex colors
#' @export
#'
fade_color <- function(color_vec,
                       deval_frac = 0.5,
                       val_floor = 0.1) {
  color_rgb <- grDevices::col2rgb(color_vec)
  color_hsv <- grDevices::rgb2hsv(color_rgb)
  color_hsv[3,] <- color_hsv[3,] - deval_frac
  color_hsv[3,color_hsv[3,] < val_floor] <- val_floor
  grDevices::hsv(color_hsv[1,],
                 color_hsv[2,],
                 color_hsv[3,])
}

#' Desaturate colors by reducing Saturation in HSV space
#'
#' @param color_vec a vector of hex or R colors
#' @param deval_frac numeric (0 to 1) - the amount to subtract from Saturation in HSV
#' @param val_floor numeric (0 to 1) - a minimum Saturation to retain for each color
#'
#' @return a character vector of desaturated hex colors
#' @export
#'
desaturate_color <- function(color_vec,
                             desat_frac = 0.5,
                             sat_floor = 0.1) {
  color_rgb <- grDevices::col2rgb(color_vec)
  color_hsv <- grDevices::rgb2hsv(color_rgb)
  color_hsv[2,] <- color_hsv[2,] - desat_frac
  color_hsv[2,color_hsv[2,] < sat_floor] <- sat_floor
  grDevices::hsv(color_hsv[1,],
                 color_hsv[2,],
                 color_hsv[3,])
}
