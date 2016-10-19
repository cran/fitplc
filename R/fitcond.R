#' @export
#' @rdname fitplc
fitcond <- function(dfr, varnames = c(K="K", WP="MPa"), 
                    Kmax=NULL,
                    WP_Kmax=NULL, ...){

  
  if(is.null(WP_Kmax) && is.null(Kmax)){
    stop("Provide either the maximum hydraulic conductance (Kmax), or the water potential threshold (WP_Kmax) (see help file).", .call=FALSE)
  }

  if(is.list(varnames))varnames <- unlist(varnames)
  
  # Get variables out of dataframe
  if(!varnames["K"] %in% names(dfr))
    stop("Check variable name for K!")
  if(!varnames["WP"] %in% names(dfr))
    stop("Check variable name for water potential!")
  
  K <- dfr[[varnames["K"]]]
  P <- dfr[[varnames["WP"]]]
  
  # Calculate Kmax based on WP threshold
  if(is.null(Kmax)){
    Kmax <- mean(K[P > WP_Kmax], na.rm=TRUE)
  }
      
  # Now calculate PLC
  dfr$plc <- 100 * (1 - K/Kmax)
  
  # Now do fit
  KmaxVal <- Kmax
  f <- fitplc(dfr, varnames=c(PLC = "plc", WP = varnames[["WP"]]), 
              calledfromfitcond=TRUE, Kmax=KmaxVal,
              ...)
  
return(f)
}

