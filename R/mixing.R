#' Mix two colors additively in RGB space
#'
#' @param col1 A hex or R color
#' @param col2 Another hex or R color
#'
#' @return The sum of col1 and col2 as a character hex color (e.g. "#FFFFFF")
#' @export
#'
#' @examples
#' color_sum("red","green")
#'
#' color_sum("#1B9E77","#D95F02")
color_sum <- function(col1,
                      col2) {

  rgbmat1 <- grDevices::col2rgb(col1)/255
  rgbmat2 <- grDevices::col2rgb(col2)/255

  mix <- rgbmat1 + rgbmat2

  mix[mix > 1] <- 1
  mix[mix < 0] <- 0

  grDevices::rgb(mix[1],mix[2],mix[3])

}

#' Compute the mean of multiple colors in RGB space
#'
#' @param color_vec A vector of hex or R colors
#'
#' @return The mean of the colors as a character hex color (e.g. "#FFFFFF")
#' @export
#'
color_mean <- function(color_vec) {
  rgbmat <- grDevices::col2rgb(color_vec)/255
  means <- rowMeans(rgbmat)
  grDevices::rgb(means[1], means[2], means[3])
}

#' Merge colors based on similarity and frequency
#'
#' @param color_vec A vector of hex or R colors
#' @param k The number of colors to retain
#'
#' @return a vector of merged colors with equal length to color_vec.
#' @export
#'
merge_nearest_colors <- function(color_vec,
                                 k = 12) {
  unique_color_vec <- unique(color_vec)

  while(length(unique_color_vec) > k) {
    unique_rgb <- grDevices::col2rgb(unique_color_vec)
    color_distances <- as.matrix(stats::dist(t(unique_rgb)))
    color_distances[lower.tri(color_distances, diag = TRUE)] <- NA
    colnames(color_distances) <- rownames(color_distances) <- unique_color_vec

    min_distance <- min(color_distances[upper.tri(color_distances)])

    min_matches <- subset(stats::na.omit(data.frame(expand.grid(dimnames(color_distances)),
                                                    value = c(color_distances))),
                          value == min_distance)
    min_matches$Var1 <- as.character(min_matches$Var1)
    min_matches$Var2 <- as.character(min_matches$Var2)
    col1 <- min_matches[1,1]
    col2 <- min_matches[1,2]

    freq1 <- sum(color_vec == col1)
    freq2 <- sum(color_vec == col2)

    if(freq1 > freq2) {
      color_vec[color_vec == col2] <- col1
    } else if(freq1 < freq2) {
      color_vec[color_vec == col1] <- col2
    } else if(freq1 == freq2) {
      new_col <- color_mean(c(col1, col2))
      color_vec[color_vec %in% c(col1, col2)] <- new_col
    }

    unique_color_vec <- unique(color_vec)
  }

  color_vec
}
