library(checkmate)
requireNamespace("base64enc")

rand = function(n, min = 1L, max = 32L) {
  chars = c(letters, LETTERS, c("=", "+", "-", "_", "/", "&", "ö", "=", "?", ":", ".", "`"))
  replicate(n, paste0(sample(chars, sample(min:max, 1L), replace = TRUE), collapse = ""))
}

convert_to_url = function(x) {
  x = gsub("/", "_", x, fixed = TRUE)
  x = gsub("+", "-", x, fixed = TRUE)
  gsub("=+$", "", x)
}

convert_to_rfc = function(x) {
  x = gsub("_", "/", x, fixed = TRUE)
  x = gsub("-", "+", x, fixed = TRUE)
  pad = nchar(x) %% 4
  paste0(x, strrep("=", ifelse(pad == 0L, 0L, 4L - pad)))
}

base64enc_rfc = function(x) {
  vapply(x, function(x) base64enc::base64encode(charToRaw(x)), NA_character_, USE.NAMES = FALSE)
}

base64dec_rfc = function(x) {
  vapply(x, function(x) rawToChar(base64enc::base64decode(x)), NA_character_, USE.NAMES = FALSE)
}
