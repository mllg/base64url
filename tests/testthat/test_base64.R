context("base64url")

test_that("encode and decode on random strings", {
  for (i in 1:10) {
    plain = rand(1000)
    enc = b64enc(plain)
    expect_character(enc, any.missing = FALSE, len = length(plain), pattern = "^[[:alnum:]_-]+$")
    unenc = b64dec(enc)
    expect_character(unenc, any.missing = FALSE, len = length(plain), min.chars = 1L)
    expect_equal(plain, unenc)
  }
})

test_that("comparison with base64enc", {
  for (i in 1:10) {
    plain = rand(1000)
    enc_rfc = base64enc_rfc(plain)
    enc_url = b64enc(plain)

    expect_equal(plain, b64dec(enc_url))
    expect_equal(plain, base64dec_rfc(enc_rfc))

    expect_equal(enc_url, convert_to_url(enc_rfc))
    expect_equal(enc_rfc, convert_to_rfc(enc_url))

    expect_equal(plain, b64dec(convert_to_url(enc_rfc)))
    expect_equal(plain, base64dec_rfc(convert_to_rfc(enc_url)))
  }
})

test_that("unexpected input", {
  expect_identical(b64enc(""), "")
  expect_identical(b64dec(""), "")
  expect_identical(b64enc(NA_character_), NA_character_)
  expect_identical(b64dec(NA_character_), NA_character_)
  expect_identical(b64enc(character(0)), character(0))
  expect_identical(b64dec(character(0)), character(0))
  expect_error(b64enc(NA), "character vector")
  expect_error(b64dec(NA), "character vector")
})
