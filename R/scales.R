#' Force a list
#'
#' This is a helper function for varibow_pal() and is not exported.
#'
#' @param ... Parameters to change to a list.
#'
#' @return a list object
force_all <- function(...) {
  list(...)
}

#' Generate a varibow palette for ggplot
#'
#' This is a helper function for scale_color_varibow() and is not exported.
#'
#' @param alpha The alpha for the palette. if NULL, alpha hex values are trimmed. Default = 1.
#'
#' @return a varibow palette
varibow_pal <- function(alpha = 1) {
  force_all(alpha)
  function(n) {
    varibow(n, alpha)
  }
}

#' Varibow colorscale for ggplot2
#'
#' @param ... Parameters passed to ggplot2::discrete_scale()
#' @param alpha Alpha value
#' @param aesthetics Passed to ggplot2::discrete_scale(). Default is "colour".
#'
#' @return A ggplot2 discrete_scale() result.
#' @export
scale_color_varibow <- function(..., alpha = 1, aesthetics = "colour")
{
  ggplot2::discrete_scale(aesthetics, "varibow", varibow_pal(alpha), ...)
}

#' Varibow colorscale for ggplot2
#'
#' @param ... Parameters passed to ggplot2::discrete_scale()
#' @param alpha Alpha value
#' @param aesthetics Passed to ggplot2::discrete_scale(). Default is "fill".
#'
#' @return A ggplot2 discrete_scale() result.
#' @export
scale_fill_varibow <- function(..., alpha = 1, aesthetics = "fill")
{
  ggplot2::discrete_scale(aesthetics, "varibow", varibow_pal(alpha), ...)
}

#' Make guide points much larger in ggplot2.
#'
#' @return A ggplot2 guides() result.
#' @export
large_guides <- function() {
  guides(colour = guide_legend(override.aes = list(size=4)))
}
