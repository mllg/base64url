context("base64url")

requireNamespace("base64enc", quietly = TRUE)

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

test_that("encode and decode on random strings", {
  for (i in 1:10) {
    plain = rand(1000)
    enc = base64_urlencode(plain)
    expect_character(enc, any.missing = FALSE, len = length(plain), pattern = "^[[:alnum:]_-]+$")
    unenc = base64_urldecode(enc)
    expect_character(unenc, any.missing = FALSE, len = length(plain), min.chars = 1L)
    expect_equal(plain, unenc)
  }
})

test_that("comparison with base64enc", {
  for (i in 1:10) {
    plain = rand(1000)
    enc_rfc = base64enc_rfc(plain)
    enc_url = base64_urlencode(plain)

    expect_equal(plain, base64_urldecode(enc_url))
    expect_equal(plain, base64dec_rfc(enc_rfc))

    expect_equal(enc_url, convert_to_url(enc_rfc))
    expect_equal(enc_rfc, convert_to_rfc(enc_url))

    expect_equal(plain, base64_urldecode(convert_to_url(enc_rfc)))
    expect_equal(plain, base64dec_rfc(convert_to_rfc(enc_url)))
  }
})

test_that("unexpected input", {
  expect_identical(base64_urlencode(""), "")
  expect_identical(base64_urldecode(""), "")
  expect_identical(base64_urlencode(NA_character_), NA_character_)
  expect_identical(base64_urldecode(NA_character_), NA_character_)
  expect_identical(base64_urlencode(character(0)), character(0))
  expect_identical(base64_urldecode(character(0)), character(0))
  expect_error(base64_urlencode(NA), "character vector")
  expect_error(base64_urldecode(NA), "character vector")
})
