#' @title Encode to base32 or Decode from base32
#'
#' @description
#' Simple RFC4648 base32 encoder/decoder. Pads with \dQuote{=}.
#'
#' @param x [\code{character(1)}]\cr
#'   Character vector to encode or decode.
#' @param use.padding [\code{logical(1)}]\cr
#'   If \code{TRUE}, \code{base32_encode} returns a string whose length is a multiple of 8,
#'   padded with trailing \dQuote{=} if required.
#'   \code{base32_decode} expects such a string unless this is set to \code{FALSE} (default).
#'   The internal algorithm currently works with padding, thus it is faster to set this to \code{TRUE}.
#' @return [\code{character}] of the same length as input \code{x}.
#' @references Implementation based on base32 encoder/decoder in the GNU lib: \url{https://www.gnu.org/software/gnulib/}.
#' @useDynLib base64url b32e
#' @export
#' @examples
#' x = "plain text"
#' encoded = base32_encode(x)
#' decoded = base32_decode(encoded)
#' print(encoded)
#' print(decoded)
base32_encode = function(x, use.padding = FALSE) {
  res = .Call(b32e, x)
  if (isTRUE(use.padding))
    return(res)
  sub("=+$", "", res)
}

#' @rdname base32_encode
#' @useDynLib base64url b32d
#' @import backports
#' @export
base32_decode = function(x, use.padding = FALSE) {
  if (!isTRUE(use.padding)) {
    i = which(!is.na(x) & nzchar(x))
    if (length(i))
      x[i] = paste0(x[i], strrep("=",  7L - ((nchar(x[i]) - 1L) %% 8L)))
  }
  .Call(b32d, x)
}
