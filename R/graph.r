
#' @importFrom ggplot2 ggplot
#' @method ggplot igraph
#' @importFrom stats setNames
#' @importFrom rlang .data
#' @importFrom igraph V
#' @export
ggplot.igraph <- function(data = NULL, 
        mapping = aes(), 
        layout = igraph::layout_nicely, 
        ..., 
        environment = parent.frame()
    ) {
    
    d <- as.data.frame(layout(data)) |> setNames(c("x", "y"))
    d$label <- V(data)$name

    p <- ggplot(d, aes(.data$x, .data$y), ...)
    assign("graph", data, envir = p$plot_env)
    class(p) <- c("ggflow", class(p))
    return(p)
}

#' layer to draw edges of a network
#' 
#' @param mapping aesthetic mapping, default is NULL
#' @param data data to plot, default is NULL
#' @param geom geometric layer to draw lines
#' @param ... additional parameter passed to 'geom'
#' @return line segments layer
#' @export
#' @examples 
#' flow_info <- data.frame(from = LETTERS[c(1,2,3,3,4,5,6)],
#'                         to = LETTERS[c(5,5,5,6,7,6,7)])
#' 
#' dd <- data.frame(
#'     label = LETTERS[1:7],
#'     v1 = abs(rnorm(7)),
#'     v2 = abs(rnorm(7)),
#'     v3 = abs(rnorm(7))
#' )
#' 
#' g = igraph::graph_from_data_frame(flow_info)
#' 
#' p <- ggplot(g)  + geom_edge()
#' library(ggplot2)
#' library(scatterpie)
#' 
#' p %<+% dd + 
#'     geom_scatterpie(cols = c("v1", "v2", "v3")) +
#'     geom_text(aes(label=label), nudge_y = .2) + 
#'     coord_fixed()
#'
geom_edge <- function(mapping=NULL, data=NULL, geom = geom_segment, ...) {
    structure(
        list(
            mapping = mapping,
            data = data,
            geom = geom,
            params = list(...)
        ),
        class = "layer_edge"
    )    
}

#' @importFrom igraph as_edgelist
#' @importFrom ggplot2 ggplot_add
#' @importFrom utils modifyList
#' @method ggplot_add layer_edge
#' @export 
ggplot_add.layer_edge <- function(object, plot, object_name) {
    params <- object$params

    if (is.null(object$data)) {
        g <- plot$plot_env$graph
        d <- plot$data
        e <- as_edgelist(g)
        d1 <- d[match(e[,1], d$label), c("x", "y")]
        d2 <- d[match(e[,2], d$label), c("x", "y")]
        names(d2) <- c("x2", "y2")

        params$data <- cbind(d1, d2)
    } else {
        params$data <- object$data
    }

    default_mapping <- aes(
        x=.data$x, y=.data$y, 
        xend=.data$x2, yend=.data$y2
    )

    if (is.null(object$mapping)) {
        params$mapping <- default_mapping
    } else {
        params$mapping <- modifyList(default_mapping, object$mapping)
    }

    layer <- do.call(object$geom, params)
    ggplot_add(layer, plot, object_name)
}






