library(testthat)
library(checkmate)

rand = function(n, min = 1L, max = 32L, only.ascii = FALSE) {
  chars = c(letters, LETTERS, c("=", "+", "-", "_", "/", "&", "=", "?", ":", ".", "%"))
  if (!isTRUE(only.ascii))
    chars = c(chars, "ö", "`", "\n")
  replicate(n, paste0(sample(chars, sample(min:max, 1L), replace = TRUE), collapse = ""))
}
