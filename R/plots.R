#' Generate a weave plot based on a palette of colors
#'
#' @param palette a character vector containing colors as either hex values (starting with #) or R colors
#'
#' @return a ggplot2 plot showing all intersections of the palette.
#' @export
#'
weave_plot <- function(palette) {

  n <- length(palette)

  h_data <- data.frame(xmin = 2*1:n,
                       xmax = 2*2:(n + 1) - 1,
                       ymin = 1,
                       ymax = n*2+2,
                       fill = palette)

  ggplot2::ggplot() +
    ggplot2::geom_rect(data = h_data,
                       ggplot2::aes(xmin = xmin,
                                    xmax = xmax,
                                    ymin = ymin,
                                    ymax = ymax,
                                    fill = fill)) +
    ggplot2::geom_rect(data = h_data,
                       ggplot2::aes(xmin = ymin,
                                    xmax = ymax,
                                    ymin = xmin,
                                    ymax = xmax,
                                    fill = fill)) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_y_reverse() +
    ggplot2::theme_classic()

}

#' Generate a plot in alpha-beta colorspace for a palette
#'
#' The resulting plot will be a 2-D projection onto the HSV/HSL chromaticity plane.
#' See https://en.wikipedia.org/wiki/HSL_and_HSV#Hue_and_chroma for more information.
#'
#' @param color_vec a character vector containing colors as either hex values (starting with #) or R colors
#' @param show_pures a logical value indicating whether or not to plot points for pure colors
#'
#' @return a ggplot2 plot with palette colors in alpha-beta space.
#' @export
#'
colorspace_plot <- function(color_vec,
                            show_pures = TRUE) {

  data <- col2ab(color_vec)

  p <- ggplot2::ggplot(data) +
    ggplot2::geom_point(ggplot2::aes(x = alpha,
                                     y = beta,
                                     color = color),
                        size = 2) +
    ggplot2::scale_color_identity() +
    ggplot2::theme_classic() +
    ggplot2::scale_x_continuous(limits = c(-1.1,1.1)) +
    ggplot2::scale_y_continuous(limits = c(-1.1,1.1))

  if(show_pures) {
    pure_colors <- c("#FF0000","#FFFF00","#00FF00","#00FFFF","#0000FF","#FF00FF")
    pure_df <- col2ab(pure_colors)
    p <- p +
      ggplot2::geom_point(data = pure_df,
                          ggplot2::aes(x = alpha,
                                       y = beta,
                                       fill = color),
                          size = 4,
                          pch = 21) +
      ggplot2::scale_fill_identity()
  }

  return(p)
}
