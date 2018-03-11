library(testthat)
library(checkmate)

rand = function(n, min = 5L, max = 50L, only.ascii = FALSE) {
  chars = c(letters, LETTERS, c("=", "+", "-", "_", "/", "&", "=", "?", ":", ".", "%"))
  if (!isTRUE(only.ascii))
    chars = c(chars, "ö", "`", "\n", "♏")
  replicate(n, paste0(sample(chars, sample(min:max, 1L), replace = TRUE), collapse = ""))
}
