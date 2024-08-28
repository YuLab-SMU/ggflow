#' draw rectangle box for flow chart
#' 
#' @title geom_rect_flow
#' @param mapping aesthetic mapping
#' @param asp aspect ration of rectangle box (width vs hight)
#' @param width width of the rectangles
#' @param ... additional parameters passed to 'geom_rect'
#' @importFrom ggplot2 geom_rect
#' @importFrom rlang .data
#' @export 
#' @author Guangchuang Yu 
geom_rect_flow <- function(
    mapping = NULL,
    asp = 1.5,
    width = .8,
    ...) {

    params <- list(...)
    structure(list(mapping = mapping,
                   asp     = asp,
                   width = .8,
                   params  = params),
              class = 'rect_flow')
}

##' @importFrom ggplot2 ggplot_add
##' @method ggplot_add rect_flow
##' @importFrom utils modifyList
##' @importFrom ggplot2 aes
##' @export
ggplot_add.rect_flow <- function(object, plot, object_name) {
    w <- object$width / 2
    h <- w / object$asp

    default_mapping <- aes(xmin = .data$x - w, xmax = .data$x + w,
                        ymin = .data$y - h, ymax = .data$y + h)
    
    if (!is.null(object$mapping)) {
        mapping <- modifyList(default_mapping, object$mapping)
    } else {
        mapping <- default_mapping
    }

    params <- object$params
    params$mapping <- mapping
    ly <- do.call("geom_rect", params)
    ggplot_add(ly, plot, object_name)
}
