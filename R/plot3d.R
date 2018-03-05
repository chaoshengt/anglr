#' 3D object plot
#'
#' @param x silicate model, SC, TRI, ARC, or PATH
#' @param ... 
#' @param add 
#' 
#' @return vertices and segment indices, invisibly
#' @export
#' @importFrom rgl plot3d
#' @export plot3d
#' @examples
#' library(silicate)
#' x <- SC(sf::read_sf(system.file("shape", "nc.shp", package = "sf")) %>% 
#'    mutate(color_ = rainbow(100)))
#' plot3d(x); rglwidget()
plot3d.SC <- function(x, ..., add = FALSE) {
  if (!"color_" %in% names(x$object)) {
    x$object$color_ <- trimesh_cols(nrow(x$object))
  }
  if (!requireNamespace("rgl", quietly = TRUE))
    stop("rgl required")
  haveZ <- "z_" %in% names(x$vertex)
  if (haveZ) {
    vb <- cbind(x$vertex$x_, x$vertex$y_, x$vertex$z_)
  } else {
    vb <- cbind(x$vertex$x_, x$vertex$y_, 0)
  }
  pindex <- dplyr::inner_join(x$object_link_edge, x$object[, c("object_", "color_")], "object_")
  vindex <- rbind(match(x$edge$.vertex0, x$vertex$vertex_),
                  match(x$edge$.vertex1, x$vertex$vertex_))
  if (!add) {
    rgl::rgl.clear()
  }
  rgl::segments3d(vb[vindex,], 
      col = rep(pindex$color_[match(x$edge$edge_, pindex$edge_)], each = 2))
   if (getOption("rgl.useNULL") && interactive() && runif(1, 0, 1) > 0.96) {
     message("rgl NULL device in use, do you need to run rgl::rglwidget()?")
   }
  ## TODO need an rgl level classed object
  invisible(list(v = vb, is = vindex))
}
#' @name plot3d
#' @export
plot3d.PATH <- function(x, ..., add = FALSE) {
  plot3d(silicate::SC(x), ...)
}
#' @name plot3d
#' @export
plot3d.sf <- function(x, ..., add = FALSE) {
  plot3d(silicate::SC(x), ...)
}
#' @name plot3d
#' @export
plot3d.sfc <- function(x, ..., add = FALSE) {
  plot3d(silicate::SC(x), ...)
}
#' @name plot3d
#' @export
plot3d.Spatial <- function(x, ..., add = FALSE) {
  plot3d(silicate::SC(x), ...)
}
#' @name plot3d
#' @export
plot3d.trip <- function(x, ..., add = FALSE) {
  plot3d(silicate::SC(x), ...)
}


#' @name plot3d
#' @export
plot3d.ARC <- function(x, ..., add = FALSE) {
  if (!"color_" %in% names(x$object)) {
    x$object$color_ <- trimesh_cols(nrow(x$object))
  }
  haveZ <- "z_" %in% names(x$vertex)
  if (haveZ) {
    vb <- cbind(x$vertex$x_, x$vertex$y_, x$vertex$z_)
  } else {
    vb <- cbind(x$vertex$x_, x$vertex$y_, 0)
  }
  pindex <- dplyr::inner_join(x$object_link_arc, x$object[, c("object_", "color_")], "object_")
  vindex <- dplyr::inner_join(x$arc_link_vertex, x$vertex, "vertex_")
 v_id <- lapply(split(vindex, vindex$arc_), function(x) as.vector(path2seg(x$vertex_)))
  if (!add) {
    rgl::rgl.clear()
  }
 vindex <- match(unlist(v_id), x$vertex$vertex_)
  rgl::segments3d(vb[vindex,], 
                  col = rep(pindex$color_[match(x$arc_link_vertex$arc_, pindex$arc_)], each = 2))
  if (getOption("rgl.useNULL") && interactive() && runif(1, 0, 1) > 0.96) {
    message("rgl NULL device in use, do you need to run rgl::rglwidget()?")
  }
  ## TODO need an rgl level classed object
  invisible(list(v = vb, is = vindex))
  
}
#' @name plot3d
#' @export
plot3d.TRI <- function(x, ..., add = FALSE) {
  if (!"color_" %in% names(x$object)) {
    x$object$color_ <- trimesh_cols(nrow(x$object))
  }
  haveZ <- "z_" %in% names(x$vertex)
  if (haveZ) {
    vb <- cbind(x$vertex$x_, x$vertex$y_, x$vertex$z_)
  } else {
    vb <- cbind(x$vertex$x_, x$vertex$y_, 0)
  }
  pindex <- dplyr::inner_join(x$triangle, x$object[, c("object_", "color_")], "object_")
  ##vindex <- dplyr::inner_join(x$triangle, x$vertex, "vertex_")
vindex <- match(c(t(as.matrix(pindex[c(".vertex0", ".vertex1", ".vertex2")]))), x$vertex$vertex_)
  #v_id <- lapply(split(vindex, vindex$arc_), function(x) as.vector(path2seg(x$vertex_)))
  if (!add) {
    rgl::rgl.clear()
  }
  #vindex <- match(unlist(v_id), x$vertex$vertex_)
  rgl::triangles3d(vb[vindex,], col = rep(pindex$color_, each = 3))
  if (getOption("rgl.useNULL") && interactive() && runif(1, 0, 1) > 0.96) {
    message("rgl NULL device in use, do you need to run rgl::rglwidget()?")
  }
  ## TODO need an rgl level classed object
  invisible(list(v = vb, it = vindex))
  
}