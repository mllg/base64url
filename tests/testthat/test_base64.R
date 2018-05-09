context("base64url")

requireNamespace("base64enc", quietly = TRUE)

is_utf8 = function() {
  grepl("utf-?8", Sys.getlocale("LC_CTYPE"), ignore.case = TRUE)
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


base64enc_openssl = function(x) {
  vapply(x, function(x) openssl::base64_encode(x), NA_character_, USE.NAMES = FALSE)
}

base64dec_openssl = function(x) {
  vapply(x, function(x) rawToChar(openssl::base64_decode(x)), NA_character_, USE.NAMES = FALSE)
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
    # base64enc seems to have problems with the encoding :/
    # rfc <-> rfc is not working!
    plain = rand(1000, only.ascii = testOS("windows") || !is_utf8())
    enc_rfc = base64enc_rfc(plain)
    enc_url = base64_urlencode(plain)

    # do we get plain back?
    expect_equal(plain, base64_urldecode(enc_url), label = "url <-> url works")
    expect_equal(plain, base64dec_rfc(enc_rfc), label = "rfc <-> rfc works")

    # do we get the same encoding as rfc?
    expect_equal(enc_url, convert_to_url(enc_rfc))
    expect_equal(enc_rfc, convert_to_rfc(enc_url))

    # do we get the same decodings after conversion?
    expect_equal(plain, base64_urldecode(convert_to_url(enc_rfc)))
    expect_equal(plain, base64dec_rfc(convert_to_rfc(enc_url)))
  }
})

test_that("comparison with openssl", {
  for (i in 1:10) {
    # openssl seems to have problems with the encoding on windows :/
    # openssl <-> openssl is not working!
    plain = rand(1000, only.ascii = testOS("windows") || !is_utf8())
    enc_openssl = base64enc_openssl(plain)
    enc_url = base64_urlencode(plain)

    # do we get plain back?
    expect_equal(plain, base64_urldecode(enc_url), label = "url <-> url works")
    expect_equal(plain, base64dec_openssl(enc_openssl), label = "openssl <-> openssl works")

    # do we get the same encoding as openssl?
    expect_equal(enc_url, convert_to_url(enc_openssl))
    expect_equal(enc_openssl, convert_to_rfc(enc_url))

    # do we get the same decodings after conversion?
    expect_equal(plain, base64_urldecode(convert_to_url(enc_openssl)))
    expect_equal(plain, base64dec_openssl(convert_to_rfc(enc_url)))
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
