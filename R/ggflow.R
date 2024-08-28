#' draw flow chart
#' 
#' @title ggflow
#' @param data a data frame containing two columns indicating 'from->to' relationship
#' @param layout flow chart layout
#' @param start_shave offset of the line segment (the from end)
#' @param end_shave offset of the line segment (the to end)
#' @param type_shave type of the 'start_shave' and 'end_shave', one of 'proportion' or 'distance'
#' @param ... additional parameters passed to 'ggtree'
#' @importFrom treeio as.phylo
#' @importFrom ggplot2 coord_cartesian
#' @importFrom ggtree ggtree
#' @importFrom igraph layout_as_tree
#' @importFrom ggarchery position_attractsegment
#' @export 
#' @author Guangchuang Yu 
#' @examples
#' library(ggplot2)
#' library(ggflow)
#' 
#' d <- data.frame(
#'   from = c("A", "A", "A", "B", "C", "F"),
#'   to = c("B", "C", "D", "E", "F", "G")
#' )
#' ggflow(d, arrow=arrow(type='closed')) + 
#'     geom_scatter_rect(fill=NA, color='black') +
#'     geom_text(aes(label=label), size=20)
ggflow <- function(
            data, 
            layout = igraph::layout_as_tree, 
            start_shave = 0.3,
            end_shave = 0.3,
            type_shave = "proportion",
            ...) {
    
    if (inherits(data, c("treedata", "phylo"))) {
        tree <- data
    } else {
        tree <- as.phylo(data)
    }

    p <- ggtree(tree,
        layout = layout,
        position = ggarchery::position_attractsegment(
            start_shave=start_shave, 
            end_shave=end_shave,
            type_shave=type_shave
        ),
        ...
    )

    p <- p + coord_cartesian() 
    return(p)    
}

