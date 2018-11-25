cdef fmpz_series_coerce_operands(x, y):
    if typecheck(x, fmpz_series):
        if isinstance(y, (int, long, fmpz, fmpz_poly)):
            return x, fmpz_series(y)
        if isinstance(y, (fmpq, fmpq_poly, fmpq_series)):
            return fmpq_series(x), fmpq_series(y)
        #if isinstance(y, (nmod, nmod_poly, nmod_series)):
        #    return nmod_series(x), nmod_series(y)
        if isinstance(y, (float, arb, arb_poly, arb_series)):
            return arb_series(x), arb_series(y)
        if isinstance(y, (complex, acb, acb_poly, acb_series)):
            return acb_series(x), acb_series(y)
    else:
        if isinstance(x, (int, long, fmpz, fmpz_poly)):
            return fmpz_series(x), y
        if isinstance(x, (fmpq, fmpq_poly, fmpq_series)):
            return fmpq_series(x), fmpq_series(y)
        #if isinstance(x, (nmod, nmod_poly, nmod_series)):
        #    return nmod_series(x), nmod_series(y)
        if isinstance(x, (float, arb, arb_poly, arb_series)):
            return arb_series(x), arb_series(y)
        if isinstance(x, (complex, acb, acb_poly, acb_series)):
            return acb_series(x), acb_series(y)
    return NotImplemented, NotImplemented

cdef class fmpz_series(flint_series):

    cdef fmpz_poly_t val
    cdef long prec

    def __cinit__(self):
        fmpz_poly_init(self.val)
        self.prec = 0

    def __dealloc__(self):
        fmpz_poly_clear(self.val)

    def __init__(self, val=None, prec=None):
        if prec is None:
            self.prec = getcap()
        else:
            self.prec = prec
        if self.prec < 0:
            self.prec = -1
        if val is not None:
            if typecheck(val, fmpz_series):
                fmpz_poly_set(self.val, (<fmpz_series>val).val)
                self.prec = min((<fmpz_series>val).prec, getcap())
            elif typecheck(val, fmpz_poly):
                fmpz_poly_set(self.val, (<fmpz_poly>val).val)
