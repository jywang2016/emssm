#'
#' forecasting function
#'
#' forecasting function
#'
#' @param y data
#' @export
#' @return
#' y by rows, m = nrow(y), nt = ncol(y)
#'
ABCDQR_predict <- function(y,u,A,B,C,D,Q,R,m1,P1,nx,ny,nu,u_new,n_ahead,conf_level=0.95){

  # data as matrices
  y = as.matrix(y)
  if (nrow(y) != ny){
    y = t(y)
  }
  nt = ncol(y)

  u = as.matrix(u)
  if (nrow(u) != nu){
    u = t(u)
  }

  u_new = as.matrix(u_new)
  if (nrow(u_new) != nu){
    u_new = t(u_new)
  }

  A <- matrix(A, nrow = nx, ncol = nx)
  B <- matrix(B, nrow = nx, ncol = nu)
  C <- matrix(C, nrow=ny, ncol = nx)
  D <- matrix(D, nrow = ny, ncol = nu)
  Q <- matrix(Q, nrow = nx, ncol = nx)
  R <- matrix(R, nrow = ny, ncol = ny)
  x10 <- m1
  P10 <- matrix(P1, nrow = nx, ncol = nx)

  # predicted values
  yp <- array(0,c(ny,n_ahead))
  # root mean square perdiction errors
  rmspe <- array(0,c(ny,n_ahead))

  # kalman filter
  kf <- ABCDQR_kfilter(y,u,A,B,C,D,Q,R,x10,P10,nx,ny,nu)

  # forecasting
  xp <- kf$xtt1[,nt+1]
  Pp <- kf$Ptt1[,,nt+1]
  for (t in 1:n_ahead){

    # predictions
    yp[,t] <- C %*% xp + D %*% u_new[,t]

    #  innovations
    St = C %*% Pp %*% t(C) + R # variance
    rmspe[,t] <- sqrt(diag(St))

    # Kalman gain
    Kt = Pp %*% t(C) %*% solve(St)

    # values for the next step
    xp = A %*% xp + B %*% u[,t]
    Pp = A %*% ( Pp - Kt %*% C %*% Pp ) %*% t(A) + Q
  }
  # prediction interval
  alpha = 1-conf_level
  ypi1 = yp - qnorm(1-alpha/2)*rmspe
  ypi2 = yp + qnorm(1-alpha/2)*rmspe

  return(list(yp=yp,rmspe=rmspe,ypi1=ypi1,ypi2=ypi2))

}
