#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP b32d(SEXP);
extern SEXP b32e(SEXP);
extern SEXP b64d(SEXP);
extern SEXP b64e(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"b32d", (DL_FUNC) &b32d, 1},
    {"b32e", (DL_FUNC) &b32e, 1},
    {"b64d", (DL_FUNC) &b64d, 1},
    {"b64e", (DL_FUNC) &b64e, 1},
    {NULL, NULL, 0}
};

void R_init_base64url(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
