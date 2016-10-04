#' @title Encode to base64 or Decode from base64
#'
#' @description
#' In contrast to RFC3548, the 62nd character ("+") is replaced by "-", the 63rd character ("/") is replaced by "_". 
#' Furthermore, the decoder does not insert "=" at the end of the string to pad to the right length.
#' As a result, all characters will comply to the pattern \dQuote{[A-Za-z0-9_-]} and can be used on basically all 
#' file systems and in URLs.
#'
#' @param x [\code{character(1)}]\cr
#'   Character vector to encode or decode.
#'
#' @return [\code{character}] of the same length as input \code{x}.
#' @useDynLib base64url b64e
#' @export
b64enc = function(x) {
  .Call(b64e, x)
}

#' @rdname b64enc
#' @useDynLib base64url b64d
#' @export
b64dec = function(x) {
  .Call(b64d, x)
}
