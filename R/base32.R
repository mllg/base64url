#' @title Encode to base32 or Decode from base32
#'
#' @description
#' Simple RFC4648 base32 encoder/decoder. Pads with \dQuote{=}.
#'
#' @param x [\code{character(1)}]\cr
#'   Character vector to encode or decode.
#'
#' @return [\code{character}] of the same length as input \code{x}.
#' @useDynLib base64url b32e
#' @export
#' @examples
#' x = "plain text"
#' encoded = base32_encode(x)
#' decoded = base32_decode(encoded)
#' print(encoded)
#' print(decoded)
base32_encode = function(x, use.padding = TRUE) {
  res = .Call(b32e, x)
  if (isTRUE(use.padding))
    return(res)
  sub("=+$", "", res)
}

#' @rdname base32_encode
#' @useDynLib base64url b32d
#' @export
base32_decode = function(x, use.padding = TRUE) {
  if (!isTRUE(use.padding)) {
    i = which(!is.na(x) & nzchar(x))
    if (length(i))
      x[i] = paste0(x[i], strrep("=",  7L - ((nchar(x[i]) - 1L) %% 8L)))
  }
  .Call(b32d, x)
}
