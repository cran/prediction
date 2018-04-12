#' @rdname prediction
#' @export
prediction.speedglm <- 
function(model, 
         data = find_data(model, parent.frame()), 
         at = NULL, 
         type = c("response", "link"), 
         calculate_se = FALSE,
         ...) {
    
    type <- match.arg(type)
    
    # extract predicted values
    data <- data
    if (missing(data) || is.null(data)) {
        pred <- predict(model, type = type, ...)
        pred <- make_data_frame(fitted = pred, se.fitted = rep(NA_real_, length(pred)))
    } else {
        # reduce memory profile
        model[["model"]] <- NULL
        attr(model[["terms"]], ".Environment") <- NULL
        
        # setup data
        out <- build_datalist(data, at = at, as.data.frame = TRUE)
        at_specification <- attr(out, "at_specification")
        # calculate predictions
        tmp <- predict(model, newdata = out, type = type, se.fit = FALSE, ...)
        # cbind back together
        pred <- make_data_frame(out, fitted = tmp, se.fitted = rep(NA_real_, nrow(out)))
    }
    
    # obs-x-(ncol(data)+2) data frame
    structure(pred, 
              class = c("prediction", "data.frame"), 
              row.names = seq_len(nrow(pred)),
              at = if (is.null(at)) at else at_specification,
              model.class = class(model),
              type = type)
}