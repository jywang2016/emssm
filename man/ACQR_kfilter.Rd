% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ACQR_kfilter.R
\name{ACQR_kfilter}
\alias{ACQR_kfilter}
\title{Kalman filter}
\usage{
ACQR_kfilter(y, A, C, Q, R, x10, P10, nx, ny)
}
\arguments{
\item{y:}{data. Matrix ny*nt
A: matrix nx*nx
C: matrix ny*nx}
}
\value{
y by rows, ny = nrow(y), nt = ncol(y)
}
\description{
Kalman filter for state space model
}
