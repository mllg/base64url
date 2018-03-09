context("encoding")

test_that("encoding", {
  x = "ööää"
  x.latin1 = iconv(x, to = "latin1")
  x.latin1.enc = base32_encode(x.latin1)
  x.latin1.dec = base32_decode(x.latin1.enc)
  x.utf8 = iconv(x, to = "UTF-8")
  x.utf8.enc = base32_encode(x.utf8)
  x.utf8.dec = base32_decode(x.utf8.enc)

  expect_identical(Encoding(x.latin1), "latin1")
  expect_identical(Encoding(x.utf8), "UTF-8")
  expect_identical(x.latin1.enc, x.utf8.enc)
  expect_identical(x.latin1.dec, x.utf8.dec)
})
