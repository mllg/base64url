/* Original source code taken from
 * https://svn.apache.org/repos/asf/apr/apr/trunk/encoding/apr_base64.c
 *
 * Changes by Michel Lang <michellang@gmail.com>:
 * - Replaced char 62 ('+') with '-'
 * - Replaced char 63 ('/') with '_'
 * - Removed padding with '=' at the end of the string
 * - Changed return type to void for Base64decode and Base64encode
 * - Added wrappers for R
 *
 */
/*
 * base64.c:  base64 encoding and decoding functions
 *
 * ====================================================================
 *    Licensed to the Apache Software Foundation (ASF) under one
 *    or more contributor license agreements.  See the NOTICE file
 *    distributed with this work for additional information
 *    regarding copyright ownership.  The ASF licenses this file
 *    to you under the Apache License, Version 2.0 (the
 *    "License"); you may not use this file except in compliance
 *    with the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing,
 *    software distributed under the License is distributed on an
 *    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *    KIND, either express or implied.  See the License for the
 *    specific language governing permissions and limitations
 *    under the License.
 * ====================================================================
 */

#include <R.h>
#include <Rinternals.h>
#include <string.h>

static const unsigned char pr2six[256] = {
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
    64,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 63,
    64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64
};

static const char basis_64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";


static int Base64decode_len(const char *bufcoded) {
    int nbytesdecoded;
    register const unsigned char *bufin;
    register int nprbytes;

    bufin = (const unsigned char *) bufcoded;
    while (pr2six[*(bufin++)] <= 63);

    nprbytes = (bufin - (const unsigned char *) bufcoded) - 1;
    nbytesdecoded = ((nprbytes + 3) / 4) * 3;

    return nbytesdecoded + 1;
}


static int Base64encode_len(int len) {
    return ((len + 2) / 3 * 4) + 1;
}


static void Base64decode(char *bufplain, const char *bufcoded) {
    register const unsigned char *bufin;
    register unsigned char *bufout;
    register int nprbytes;

    bufin = (const unsigned char *) bufcoded;
    while (pr2six[*(bufin++)] <= 63);
    nprbytes = (bufin - (const unsigned char *) bufcoded) - 1;

    bufout = (unsigned char *) bufplain;
    bufin = (const unsigned char *) bufcoded;

    while (nprbytes > 4) {
        *(bufout++) = (unsigned char) (pr2six[*bufin] << 2 | pr2six[bufin[1]] >> 4);
        *(bufout++) = (unsigned char) (pr2six[bufin[1]] << 4 | pr2six[bufin[2]] >> 2);
        *(bufout++) = (unsigned char) (pr2six[bufin[2]] << 6 | pr2six[bufin[3]]);
        bufin += 4;
        nprbytes -= 4;
    }

    if (nprbytes > 1)
        *(bufout++) = (unsigned char) (pr2six[*bufin] << 2 | pr2six[bufin[1]] >> 4);
    if (nprbytes > 2)
        *(bufout++) = (unsigned char) (pr2six[bufin[1]] << 4 | pr2six[bufin[2]] >> 2);
    if (nprbytes > 3)
        *(bufout++) = (unsigned char) (pr2six[bufin[2]] << 6 | pr2six[bufin[3]]);

    *(bufout++) = '\0';
}


static void Base64encode(char *encoded, const char *string, int len) {
    int i;
    char *p = encoded;

    for (i = 0; i < len - 2; i += 3) {
        *p++ = basis_64[(string[i] >> 2) & 0x3F];
        *p++ = basis_64[((string[i] & 0x3) << 4) | ((int) (string[i + 1] & 0xF0) >> 4)];
        *p++ = basis_64[((string[i + 1] & 0xF) << 2) | ((int) (string[i + 2] & 0xC0) >> 6)];
        *p++ = basis_64[string[i + 2] & 0x3F];
    }

    if (i < len) {
        *p++ = basis_64[(string[i] >> 2) & 0x3F];
        if (i == (len - 1)) {
            *p++ = basis_64[((string[i] & 0x3) << 4)];
        } else {
            *p++ = basis_64[((string[i] & 0x3) << 4) | ((int) (string[i + 1] & 0xF0) >> 4)];
            *p++ = basis_64[((string[i + 1] & 0xF) << 2)];
        }
    }

    *p++ = '\0';
}


SEXP b64e(SEXP strings) {
    if (!isString(strings))
        error("Argument must be a character vector");

    const R_xlen_t n = xlength(strings);
    SEXP result = PROTECT(allocVector(STRSXP, n));

    for (R_xlen_t i = 0; i < n; i++) {
        if (STRING_ELT(strings, i) == NA_STRING) {
            SET_STRING_ELT(result, i, NA_STRING);
        } else {
            const char *plain = translateCharUTF8(STRING_ELT(strings, i));
            char *encoded = malloc(sizeof(char) * Base64encode_len(strlen(plain)));
            Base64encode(encoded, plain, strlen(plain));
            SET_STRING_ELT(result, i, mkCharCE(encoded, CE_ANY));
            free(encoded);
        }
    }

    UNPROTECT(1);
    return result;
}


SEXP b64d(SEXP strings) {
    if (!isString(strings))
        error("Argument must be a character vector");

    const R_xlen_t n = xlength(strings);
    SEXP result = PROTECT(allocVector(STRSXP, n));

    for (R_xlen_t i = 0; i < n; i++) {
        if (STRING_ELT(strings, i) == NA_STRING) {
            SET_STRING_ELT(result, i, NA_STRING);
        } else {
            const char *encoded = translateCharUTF8(STRING_ELT(strings, i));
            char *plain = malloc(sizeof(char) * Base64decode_len(encoded));
            Base64decode(plain, encoded);
            SET_STRING_ELT(result, i, mkCharCE(plain, CE_UTF8));
            free(plain);
        }
    }

    UNPROTECT(1);
    return result;
}
