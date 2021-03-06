#' @rdname prediction
#' @export
prediction.betareg <- 
function(model, 
         data = find_data(model, parent.frame()),
         at = NULL, 
         type = c("response", "link", "precision", "variance", "quantile"), 
         calculate_se = FALSE,
         ...) {
    
    type <- match.arg(type)
    
    # extract predicted value
    data <- data
    if (missing(data) || is.null(data)) {
        pred <- make_data_frame(fitted = predict(model, type = type, ...), 
                                se.fitted = NA_real_)
    } else {
        # reduce memory profile
        model[["model"]] <- NULL
        
        # setup data
        if (is.null(at)) {
            out <- data
        } else {
            out <- build_datalist(data, at = at, as.data.frame = TRUE)
            at_specification <- attr(out, "at_specification")
        }
        # calculate predictions
        pred <- predict(model, newdata = out, type = type, ...)
        # cbind back together
        pred <- make_data_frame(out, fitted = pred, se.fitted = rep(NA_real_, length(pred)))
    }
    
    # variance(s) of average predictions
    vc <- NA_real_
    
    # output
    structure(pred, 
              class = c("prediction", "data.frame"),
              at = if (is.null(at)) at else at_specification,
              type = type,
              call = if ("call" %in% names(model)) model[["call"]] else NULL,
              model_class = class(model),
              row.names = seq_len(nrow(pred)),
              vcov = vc,
              jacobian = NULL,
              weighted = FALSE)
}
