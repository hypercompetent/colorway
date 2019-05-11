#' Which colors pass tests in logical space?
#'
#' \code{color_which()} takes a vector of R or hex colors and performs logical tests
#' on RGB values (r, g, and/or b) and/or HSV values (h, s, and v) supplied in the form
#' of logial expressions (see Examples).
#'
#' @param color_vec A vector of hex or R colors.
#' @param test A logical test to perform on the set of colors
#'
#' @return an integer vector indicating which indices of the color vector pass the test(s)
#' @export
#'
#' @examples
#'
#' color_vec <- c("#FF0000","dodgerblue","orange","808080","#000000")
#'
#' # Which colors have an R value > 0.5 in RGB space (scaled between 0 and 1)?
#' color_which(color_vec,
#'             r > 0.5)
#'
#' # Which colors have R or B > 0.3 in RGB space?
#' color_which(color_vec,
#'             r > 0.3 | g > 0.3)
#'
#' # Which colors are highly saturated (S > 0.8 in HSV space)?
#' color_which(color_vec,
#'             s > 0.8)
#'
#' # Which colors are dark (low V in HSV space)?
#' color_which(color_vec,
#'             v < 0.2)
#'
#' # Which colors are bright, saturated red?
#' color_which(color_vec,
#'             r > 0.7 & s > 0.7 & v > 0.7)
color_which <- function(color_vec,
                        test) {
  test <- rlang::enquo(test)

  color_rgb <- col2rgb(color_vec) / 255
  color_hsv <- rgb2hsv(color_rgb, maxColorValue = 1)

  color_df <- data.frame(cbind(t(color_rgb), t(color_hsv)))
  names(color_df) <- c("r","g","b","h","s","v")

  color_df$idx <- 1:nrow(color_df)

  color_df <- dplyr::filter(color_df, !!test)

  return(color_df$idx)
}

#' Perform logical tests on colors in RGB and/or HSV space
#'
#' \code{color_which()} takes a vector of R or hex colors and performs logical tests
#' on RGB values (r, g, and/or b) and/or HSV values (h, s, and v) supplied in the form
#' of logial expressions (see Examples).
#'
#' @param color_vec A vector of hex or R colors.
#' @param test A logical test to perform on the set of colors
#'
#' @return a logical vector indicating which members of the color vector pass the test(s)
#' @export
#'
#' @examples
#'
#' color_vec <- c("#FF0000","dodgerblue","orange","808080","#000000")
#'
#' # Which colors have an R value > 0.5 in RGB space (scaled between 0 and 1)?
#' color_lgl(color_vec,
#'           r > 0.5)
#'
#' # Which colors have R or B > 0.3 in RGB space?
#' color_lgl(color_vec,
#'           r > 0.3 | g > 0.3)
#'
#' # Which colors are highly saturated (S > 0.8 in HSV space)?
#' color_lgl(color_vec,
#'           s > 0.8)
#'
#' # Which colors are dark (low V in HSV space)?
#' color_lgl(color_vec,
#'           v < 0.2)
#'
#' # Which colors are bright, saturated red?
#' color_lgl(color_vec,
#'           r > 0.7 & s > 0.7 & v > 0.7)
color_lgl <- function(color_vec,
                      ...) {

  out <- logical(length(color_vec))
  out[color_which(color_vec, ...)] <- TRUE

  return(out)
}
