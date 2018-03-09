context("base32")

test_that("encode and decode on random strings", {
  for (i in 1:10) {
    plain = rand(1000)
    enc = base32_encode(plain, use.padding = TRUE)
    expect_character(enc, any.missing = FALSE, len = length(plain), pattern = "^[A-Z234567=]+$")
    unenc = base32_decode(enc, use.padding = TRUE)
    expect_character(unenc, any.missing = FALSE, len = length(plain), min.chars = 1L)
    expect_equal(plain, unenc)
  }
})

test_that("unexpected input", {
  expect_identical(base32_encode("", use.padding = TRUE), "")
  expect_identical(base32_decode("", use.padding = TRUE), "")
  expect_identical(base32_encode(NA_character_, use.padding = TRUE), NA_character_)
  expect_identical(base32_decode(NA_character_, use.padding = TRUE), NA_character_)
  expect_identical(base32_encode(character(0), use.padding = TRUE), character(0))
  expect_identical(base32_decode(character(0), use.padding = TRUE), character(0))
  expect_error(base32_encode(NA, use.padding = TRUE), "character vector")
  expect_error(base32_decode(NA, use.padding = TRUE), "character vector")

  expect_identical(base32_encode("", use.padding = FALSE), "")
  expect_identical(base32_decode("", use.padding = FALSE), "")
  expect_identical(base32_encode(NA_character_, use.padding = FALSE), NA_character_)
  expect_identical(base32_decode(NA_character_, use.padding = FALSE), NA_character_)
  expect_identical(base32_encode(character(0), use.padding = FALSE), character(0))
  expect_identical(base32_decode(character(0), use.padding = FALSE), character(0))
  expect_error(base32_encode(NA, use.padding = FALSE), "character vector")
  expect_error(base32_decode(NA, use.padding = FALSE), "character vector")
})
