% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DEL0-model.R
\name{DEL0}
\alias{DEL0}
\alias{DEL0.DEL}
\alias{DEL0.default}
\alias{DEL0.SC}
\alias{DEL0.SC0}
\alias{DEL0.TRI}
\alias{DEL0.TRI0}
\alias{DEL0.ARC}
\alias{DEL0.PATH}
\alias{DEL0.PATH0}
\alias{DEL0.BasicRaster}
\title{Convert object to a constrained-Delaunay triangulation}
\usage{
DEL0(x, ..., max_area = NULL)

\method{DEL0}{DEL}(x, ..., max_area = NULL)

\method{DEL0}{default}(x, ..., max_area = NULL)

\method{DEL0}{SC}(x, ..., max_area = NULL)

\method{DEL0}{SC0}(x, ..., max_area = NULL)

\method{DEL0}{TRI}(x, ..., max_area = NULL)

\method{DEL0}{TRI0}(x, ..., max_area = NULL)

\method{DEL0}{ARC}(x, ..., max_area = NULL)

\method{DEL0}{PATH}(x, ..., max_area = NULL)

\method{DEL0}{PATH0}(x, ..., max_area = NULL)

\method{DEL0}{BasicRaster}(x, ..., max_triangles = NULL)
}
\arguments{
\item{x}{object of class \link{PATH0} or understood by \code{\link[=PATH0]{PATH0()}}}

\item{...}{ignored}

\item{max_area}{the maximum area of a triangle}

\item{max_triangles}{limit on triangles to create, passed to terrainmeshr}
}
\value{
\link[=DEL0]{DEL0 class}
}
\description{
This \emph{structural-form} Delaunay-based triangulation model is analogous to the
\link[silicate:TRI]{TRI()} model in the silicate package and formally extends the
class of that model. A primitives-based shape-constrained triangulation. The
Delaunay model is the \emph{mostly Delaunay} scheme used by the provable-quality
meshers.
}
\details{
This is a more compact form of the \emph{relational-form} \code{\link[=DEL]{DEL()}} model.
}
\section{Topology}{


Note that for explicitly linear features, these still use a post-meshing
identification for which triangles belong in which feature. This can't make
sense for many line layers, but we leave it for now.

For point features, the mesher unproblematically creates a triangulation in
the convex hull of the points, any attributes names \code{z_}, \code{m_}, or \code{t_} are
automatically interpolated and include in the output. See the help for
\code{\link[RTriangle:triangulate]{RTriangle::triangulate()}} for how this works via the \verb{$PA} element.

Note that for a raster input the terrainmeshr package is used to determine
a sensible number of triangles based on local curvature. To avoid creating
this adative mesh and use \code{as.mesh3d(QUAD(raster))} to get quad primitives or
\code{as.mesh3d(QUAD(raster), triangles = TRUE)} to get triangle primitives directly
from raster cells.
}

\section{Licensing}{


The anglr package is released with license CC BY-NC-SA 4.0 to match the one
dependency RTriangle. Please note and respect the license of the RTriangle
package used by the \code{\link[=DEL]{DEL()}} or \code{\link[=DEL0]{DEL0()}} functions in anglr, and invoked
within 3D plot methods. These return high-quality constrained Delaunay
triangulations of polygonal regions, with the ability to control mesh
characteristics including maximum triangle area, minimum internal angle, and
conformance to the Delaunay criterion. If you are interested in
a less restrictive license for high-quality meshing in R please
get involved with \href{https://github.com/hypertidy/laridae}{the laridae package}
which aims to provide access to \href{https://www.cgal.org/}{CGAL}.
}

\examples{
a <- DEL0(cad_tas)
plot(a)

## ---- intepolate via triangulation, sample points from volcano
rgl::clear3d()
n <- 150
max_area <- .005 ## we working in x 0,1 y 0,1
library(anglr)
library(dplyr)
d <-
  data.frame(x = runif(n), y = runif(n), multipoint_id = 1) \%>\%
  dplyr::mutate(
    z = raster::extract(raster::raster(volcano), cbind(x, y)),
    multipoint_id = 1
  )
\donttest{
mesh <- DEL0(
  sfheaders::sf_multipoint(d, x = "x", y = "y", z = "z",
    multipoint_id = "multipoint_id"), max_area = max_area)

plot3d(mesh , color = "darkgrey", specular = "darkgrey") #sample(grey.colors(5)))
}
}
\seealso{
\link{DEL}
}
