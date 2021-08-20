is.increasing <- function(x, printout = FALSE) {
  n <- length(x)
  dif.vec <- x[2:n] - x[1:(n-1)]
  if (printout == TRUE) print(dif.vec)
  if (sum(dif.vec <= 0) != 0) return(F)
  return(T)
}

x <- c(1:10)
is.increasing(x)

y <- c(5,5,5)
is.increasing(y)

z <- c(1,5,3,7,9)
is.increasing(z)

is.increasing(z,printout=T)


