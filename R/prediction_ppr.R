#' @rdname prediction
#' @export
prediction.ppr <- function(model, data = find_data(model, parent.frame()), at = NULL, calculate_se = FALSE, ...) {
    
    # extract predicted values
    data <- data
    if (missing(data) || is.null(data)) {
        pred <- make_data_frame(fitted = predict(model, ...),
                                se.fitted = NA_real_)
    } else {
        # setup data
        if (is.null(at)) {
            out <- data
        } else {
            out <- build_datalist(data, at = at, as.data.frame = TRUE)
            at_specification <- attr(out, "at_specification")
        }
        # calculate predictions
        tmp <- predict(model, 
                       newdata = out, 
                       ...)
        # cbind back together
        pred <- make_data_frame(out, fitted = tmp, se.fitted = rep(NA_real_, nrow(out)))
    }
    
    # variance(s) of average predictions
    vc <- NA_real_
    
    # output
    structure(pred, 
              class = c("prediction", "data.frame"),
              at = if (is.null(at)) at else at_specification,
              type = NA_character_,
              call = if ("call" %in% names(model)) model[["call"]] else NULL,
              model_class = class(model),
              row.names = seq_len(nrow(pred)),
              vcov = vc,
              jacobian = NULL,
              weighted = FALSE)
}
