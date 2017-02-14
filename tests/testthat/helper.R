library(checkmate)

rand = function(n, min = 1L, max = 32L) {
  chars = c(letters, LETTERS, c("=", "+", "-", "_", "/", "&", "ö", "=", "?", ":", ".", "`", "%", "\n"))
  replicate(n, paste0(sample(chars, sample(min:max, 1L), replace = TRUE), collapse = ""))
}
