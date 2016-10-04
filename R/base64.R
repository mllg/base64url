#' @title Encode to base64 or Decode from base64
#'
#' @description
#' In contrast to RFC3548, the 62nd character (\sQuote{+}) is replaced with \sQuote{-}, the 63rd character (\sQuote{/}) is replaced with \sQuote{_}.
#' Furthermore, the encoder does not fill the string with trailing \sQuote{=}.
#' The resulting encoded strings comply to the regular expression pattern \dQuote{[A-Za-z0-9_-]} and thus are safe to use in URLs
#' or for file names.
#'
#' @param x [\code{character(1)}]\cr
#'   Character vector to encode or decode.
#'
#' @return [\code{character}] of the same length as input \code{x}.
#' @useDynLib base64url b64e
#' @export
#' @examples
#' x = "plain text"
#' encoded = base64_urlencode(x)
#' decoded = base64_urldecode(encoded)
#' print(encoded)
#' print(decoded)
base64_urlencode = function(x) {
  .Call(b64e, x)
}

#' @rdname base64_urlencode
#' @useDynLib base64url b64d
#' @export
base64_urldecode = function(x) {
  .Call(b64d, x)
}
