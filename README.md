# base64url

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/base64url)](http://cran.r-project.org/package=base64url)
[![Build Status](https://travis-ci.org/mllg/base64url.svg?branch=master)](https://travis-ci.org/mllg/base64url)
[![Build status](https://ci.appveyor.com/api/projects/status/5329u3dk9vanak0p/branch/master?svg=true)](https://ci.appveyor.com/project/mllg/base64url/branch/master)

In contrast to RFC3548, the 62nd character (`'+'`) is replaced with `'-'`, the 63rd character (`'/'`) is replaced with `'_'`.
Furthermore, the encoder does not fill the string with trailing `'='`.
The resulting encoded strings comply to the regular expression pattern `'[A-Za-z0-9_-]'` and thus are safe to use in URLs or for file names.

## Installation
For the stable release, just install the latest version from [CRAN](https://cran.r-project.org/package=base64url):
```{R}
install.packages("base64url")
```
For the development version, use [devtools](https://cran.r-project.org/package=devtools):
```{R}
devtools::install_github("mllg/base64url")
```
