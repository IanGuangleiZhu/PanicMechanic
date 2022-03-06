/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * fft1.c
 *
 * Code generation for function 'fft1'
 *
 */

/* Include files */
#include "fft1.h"
#include "get_hr.h"
#include "get_hr_emxutil.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Declarations */
static void b_r2br_r2dit_trig(const creal_T x_data[], const int x_size[1], int
  n1_unsigned, const double costab_data[], const double sintab_data[],
  emxArray_creal_T *y);
static void bluestein(const double x_data[], const int x_size[1], int nfft, int
                      nRows, const double costab_data[], const double
                      sintab_data[], const double costabinv_data[], const double
                      sintabinv_data[], const creal_T wwc_data[], const int
                      wwc_size[1], creal_T y_data[], int y_size[1]);
static void c_r2br_r2dit_trig(const emxArray_creal_T *x, int n1_unsigned, const
  double costab_data[], const double sintab_data[], emxArray_creal_T *y);
static void r2br_r2dit_trig_impl(const creal_T x_data[], const int x_size[1],
  int unsigned_nRows, const double costab_data[], const double sintab_data[],
  emxArray_creal_T *y);

/* Function Definitions */
static void b_r2br_r2dit_trig(const creal_T x_data[], const int x_size[1], int
  n1_unsigned, const double costab_data[], const double sintab_data[],
  emxArray_creal_T *y)
{
  int istart;
  int nRowsM2;
  int nRowsD2;
  int nRowsD4;
  int iy;
  int ix;
  int ju;
  int i;
  boolean_T tst;
  double temp_re;
  double temp_im;
  double twid_re;
  double twid_im;
  int temp_re_tmp;
  int ihi;
  istart = x_size[0];
  if (istart >= n1_unsigned) {
    istart = n1_unsigned;
  }

  nRowsM2 = n1_unsigned - 2;
  nRowsD2 = n1_unsigned / 2;
  nRowsD4 = nRowsD2 / 2;
  iy = y->size[0];
  y->size[0] = n1_unsigned;
  emxEnsureCapacity_creal_T(y, iy);
  if (n1_unsigned > x_size[0]) {
    iy = y->size[0];
    y->size[0] = n1_unsigned;
    emxEnsureCapacity_creal_T(y, iy);
    for (iy = 0; iy < n1_unsigned; iy++) {
      y->data[iy].re = 0.0;
      y->data[iy].im = 0.0;
    }
  }

  ix = 0;
  ju = 0;
  iy = 0;
  for (i = 0; i <= istart - 2; i++) {
    y->data[iy] = x_data[ix];
    iy = n1_unsigned;
    tst = true;
    while (tst) {
      iy >>= 1;
      ju ^= iy;
      tst = ((ju & iy) == 0);
    }

    iy = ju;
    ix++;
  }

  y->data[iy] = x_data[ix];
  if (n1_unsigned > 1) {
    for (i = 0; i <= nRowsM2; i += 2) {
      temp_re = y->data[i + 1].re;
      temp_im = y->data[i + 1].im;
      twid_re = y->data[i].re;
      twid_im = y->data[i].im;
      y->data[i + 1].re = y->data[i].re - y->data[i + 1].re;
      y->data[i + 1].im = y->data[i].im - y->data[i + 1].im;
      twid_re += temp_re;
      twid_im += temp_im;
      y->data[i].re = twid_re;
      y->data[i].im = twid_im;
    }
  }

  iy = 2;
  ix = 4;
  ju = ((nRowsD4 - 1) << 2) + 1;
  while (nRowsD4 > 0) {
    for (i = 0; i < ju; i += ix) {
      temp_re_tmp = i + iy;
      temp_re = y->data[temp_re_tmp].re;
      temp_im = y->data[temp_re_tmp].im;
      y->data[temp_re_tmp].re = y->data[i].re - y->data[temp_re_tmp].re;
      y->data[temp_re_tmp].im = y->data[i].im - y->data[temp_re_tmp].im;
      y->data[i].re += temp_re;
      y->data[i].im += temp_im;
    }

    istart = 1;
    for (nRowsM2 = nRowsD4; nRowsM2 < nRowsD2; nRowsM2 += nRowsD4) {
      twid_re = costab_data[nRowsM2];
      twid_im = sintab_data[nRowsM2];
      i = istart;
      ihi = istart + ju;
      while (i < ihi) {
        temp_re_tmp = i + iy;
        temp_re = twid_re * y->data[temp_re_tmp].re - twid_im * y->
          data[temp_re_tmp].im;
        temp_im = twid_re * y->data[temp_re_tmp].im + twid_im * y->
          data[temp_re_tmp].re;
        y->data[temp_re_tmp].re = y->data[i].re - temp_re;
        y->data[temp_re_tmp].im = y->data[i].im - temp_im;
        y->data[i].re += temp_re;
        y->data[i].im += temp_im;
        i += ix;
      }

      istart++;
    }

    nRowsD4 /= 2;
    iy = ix;
    ix += ix;
    ju -= iy;
  }
}

static void bluestein(const double x_data[], const int x_size[1], int nfft, int
                      nRows, const double costab_data[], const double
                      sintab_data[], const double costabinv_data[], const double
                      sintabinv_data[], const creal_T wwc_data[], const int
                      wwc_size[1], creal_T y_data[], int y_size[1])
{
  int minNrowsNx;
  int xidx;
  int k;
  int a_re_tmp;
  emxArray_creal_T *fv;
  emxArray_creal_T *b_fv;
  double im;
  double d;
  minNrowsNx = x_size[0];
  if (nRows < minNrowsNx) {
    minNrowsNx = nRows;
  }

  y_size[0] = nRows;
  if (nRows > x_size[0]) {
    y_size[0] = nRows;
    if (0 <= nRows - 1) {
      memset(&y_data[0], 0, nRows * sizeof(creal_T));
    }
  }

  xidx = 0;
  for (k = 0; k < minNrowsNx; k++) {
    a_re_tmp = (nRows + k) - 1;
    y_data[k].re = wwc_data[a_re_tmp].re * x_data[xidx];
    y_data[k].im = wwc_data[a_re_tmp].im * -x_data[xidx];
    xidx++;
  }

  xidx = minNrowsNx + 1;
  if (xidx <= nRows) {
    memset(&y_data[xidx + -1], 0, ((nRows - xidx) + 1) * sizeof(creal_T));
  }

  emxInit_creal_T(&fv, 1);
  emxInit_creal_T(&b_fv, 1);
  r2br_r2dit_trig_impl(y_data, y_size, nfft, costab_data, sintab_data, fv);
  b_r2br_r2dit_trig(wwc_data, wwc_size, nfft, costab_data, sintab_data, b_fv);
  xidx = b_fv->size[0];
  b_fv->size[0] = fv->size[0];
  emxEnsureCapacity_creal_T(b_fv, xidx);
  minNrowsNx = fv->size[0];
  for (xidx = 0; xidx < minNrowsNx; xidx++) {
    im = fv->data[xidx].re * b_fv->data[xidx].im + fv->data[xidx].im *
      b_fv->data[xidx].re;
    b_fv->data[xidx].re = fv->data[xidx].re * b_fv->data[xidx].re - fv->
      data[xidx].im * b_fv->data[xidx].im;
    b_fv->data[xidx].im = im;
  }

  c_r2br_r2dit_trig(b_fv, nfft, costabinv_data, sintabinv_data, fv);
  minNrowsNx = 0;
  xidx = wwc_size[0];
  emxFree_creal_T(&b_fv);
  for (k = nRows; k <= xidx; k++) {
    im = wwc_data[k - 1].re;
    d = wwc_data[k - 1].im;
    y_data[minNrowsNx].re = im * fv->data[k - 1].re + d * fv->data[k - 1].im;
    y_data[minNrowsNx].im = im * fv->data[k - 1].im - d * fv->data[k - 1].re;
    minNrowsNx++;
  }

  emxFree_creal_T(&fv);
}

static void c_r2br_r2dit_trig(const emxArray_creal_T *x, int n1_unsigned, const
  double costab_data[], const double sintab_data[], emxArray_creal_T *y)
{
  int j;
  int nRowsM2;
  int nRowsD2;
  int nRowsD4;
  int iDelta2;
  int ix;
  int ju;
  int iy;
  int i;
  boolean_T tst;
  double temp_re;
  double temp_im;
  double twid_re;
  double twid_im;
  int temp_re_tmp;
  j = x->size[0];
  if (j >= n1_unsigned) {
    j = n1_unsigned;
  }

  nRowsM2 = n1_unsigned - 2;
  nRowsD2 = n1_unsigned / 2;
  nRowsD4 = nRowsD2 / 2;
  iDelta2 = y->size[0];
  y->size[0] = n1_unsigned;
  emxEnsureCapacity_creal_T(y, iDelta2);
  if (n1_unsigned > x->size[0]) {
    iDelta2 = y->size[0];
    y->size[0] = n1_unsigned;
    emxEnsureCapacity_creal_T(y, iDelta2);
    for (iDelta2 = 0; iDelta2 < n1_unsigned; iDelta2++) {
      y->data[iDelta2].re = 0.0;
      y->data[iDelta2].im = 0.0;
    }
  }

  ix = 0;
  ju = 0;
  iy = 0;
  for (i = 0; i <= j - 2; i++) {
    y->data[iy] = x->data[ix];
    iDelta2 = n1_unsigned;
    tst = true;
    while (tst) {
      iDelta2 >>= 1;
      ju ^= iDelta2;
      tst = ((ju & iDelta2) == 0);
    }

    iy = ju;
    ix++;
  }

  y->data[iy] = x->data[ix];
  if (n1_unsigned > 1) {
    for (i = 0; i <= nRowsM2; i += 2) {
      temp_re = y->data[i + 1].re;
      temp_im = y->data[i + 1].im;
      twid_re = y->data[i].re;
      twid_im = y->data[i].im;
      y->data[i + 1].re = y->data[i].re - y->data[i + 1].re;
      y->data[i + 1].im = y->data[i].im - y->data[i + 1].im;
      twid_re += temp_re;
      twid_im += temp_im;
      y->data[i].re = twid_re;
      y->data[i].im = twid_im;
    }
  }

  iy = 2;
  iDelta2 = 4;
  ix = ((nRowsD4 - 1) << 2) + 1;
  while (nRowsD4 > 0) {
    for (i = 0; i < ix; i += iDelta2) {
      temp_re_tmp = i + iy;
      temp_re = y->data[temp_re_tmp].re;
      temp_im = y->data[temp_re_tmp].im;
      y->data[temp_re_tmp].re = y->data[i].re - y->data[temp_re_tmp].re;
      y->data[temp_re_tmp].im = y->data[i].im - y->data[temp_re_tmp].im;
      y->data[i].re += temp_re;
      y->data[i].im += temp_im;
    }

    ju = 1;
    for (j = nRowsD4; j < nRowsD2; j += nRowsD4) {
      twid_re = costab_data[j];
      twid_im = sintab_data[j];
      i = ju;
      nRowsM2 = ju + ix;
      while (i < nRowsM2) {
        temp_re_tmp = i + iy;
        temp_re = twid_re * y->data[temp_re_tmp].re - twid_im * y->
          data[temp_re_tmp].im;
        temp_im = twid_re * y->data[temp_re_tmp].im + twid_im * y->
          data[temp_re_tmp].re;
        y->data[temp_re_tmp].re = y->data[i].re - temp_re;
        y->data[temp_re_tmp].im = y->data[i].im - temp_im;
        y->data[i].re += temp_re;
        y->data[i].im += temp_im;
        i += iDelta2;
      }

      ju++;
    }

    nRowsD4 /= 2;
    iy = iDelta2;
    iDelta2 += iDelta2;
    ix -= iy;
  }

  if (y->size[0] > 1) {
    twid_re = 1.0 / (double)y->size[0];
    iy = y->size[0];
    for (iDelta2 = 0; iDelta2 < iy; iDelta2++) {
      y->data[iDelta2].re *= twid_re;
      y->data[iDelta2].im *= twid_re;
    }
  }
}

static void r2br_r2dit_trig_impl(const creal_T x_data[], const int x_size[1],
  int unsigned_nRows, const double costab_data[], const double sintab_data[],
  emxArray_creal_T *y)
{
  int istart;
  int nRowsM2;
  int nRowsD2;
  int nRowsD4;
  int iy;
  int ix;
  int ju;
  int i;
  boolean_T tst;
  double temp_re;
  double temp_im;
  double twid_re;
  double twid_im;
  int temp_re_tmp;
  int ihi;
  istart = x_size[0];
  if (istart >= unsigned_nRows) {
    istart = unsigned_nRows;
  }

  nRowsM2 = unsigned_nRows - 2;
  nRowsD2 = unsigned_nRows / 2;
  nRowsD4 = nRowsD2 / 2;
  iy = y->size[0];
  y->size[0] = unsigned_nRows;
  emxEnsureCapacity_creal_T(y, iy);
  if (unsigned_nRows > x_size[0]) {
    iy = y->size[0];
    y->size[0] = unsigned_nRows;
    emxEnsureCapacity_creal_T(y, iy);
    for (iy = 0; iy < unsigned_nRows; iy++) {
      y->data[iy].re = 0.0;
      y->data[iy].im = 0.0;
    }
  }

  ix = 0;
  ju = 0;
  iy = 0;
  for (i = 0; i <= istart - 2; i++) {
    y->data[iy] = x_data[ix];
    iy = unsigned_nRows;
    tst = true;
    while (tst) {
      iy >>= 1;
      ju ^= iy;
      tst = ((ju & iy) == 0);
    }

    iy = ju;
    ix++;
  }

  y->data[iy] = x_data[ix];
  if (unsigned_nRows > 1) {
    for (i = 0; i <= nRowsM2; i += 2) {
      temp_re = y->data[i + 1].re;
      temp_im = y->data[i + 1].im;
      twid_re = y->data[i].re;
      twid_im = y->data[i].im;
      y->data[i + 1].re = y->data[i].re - y->data[i + 1].re;
      y->data[i + 1].im = y->data[i].im - y->data[i + 1].im;
      twid_re += temp_re;
      twid_im += temp_im;
      y->data[i].re = twid_re;
      y->data[i].im = twid_im;
    }
  }

  iy = 2;
  ix = 4;
  ju = ((nRowsD4 - 1) << 2) + 1;
  while (nRowsD4 > 0) {
    for (i = 0; i < ju; i += ix) {
      temp_re_tmp = i + iy;
      temp_re = y->data[temp_re_tmp].re;
      temp_im = y->data[temp_re_tmp].im;
      y->data[temp_re_tmp].re = y->data[i].re - y->data[temp_re_tmp].re;
      y->data[temp_re_tmp].im = y->data[i].im - y->data[temp_re_tmp].im;
      y->data[i].re += temp_re;
      y->data[i].im += temp_im;
    }

    istart = 1;
    for (nRowsM2 = nRowsD4; nRowsM2 < nRowsD2; nRowsM2 += nRowsD4) {
      twid_re = costab_data[nRowsM2];
      twid_im = sintab_data[nRowsM2];
      i = istart;
      ihi = istart + ju;
      while (i < ihi) {
        temp_re_tmp = i + iy;
        temp_re = twid_re * y->data[temp_re_tmp].re - twid_im * y->
          data[temp_re_tmp].im;
        temp_im = twid_re * y->data[temp_re_tmp].im + twid_im * y->
          data[temp_re_tmp].re;
        y->data[temp_re_tmp].re = y->data[i].re - temp_re;
        y->data[temp_re_tmp].im = y->data[i].im - temp_im;
        y->data[i].re += temp_re;
        y->data[i].im += temp_im;
        i += ix;
      }

      istart++;
    }

    nRowsD4 /= 2;
    iy = ix;
    ix += ix;
    ju -= iy;
  }
}

void dobluesteinfft(const double x_data[], const int x_size[1], int N2, int n1,
                    const double costab_data[], const double sintab_data[],
                    const double sintabinv_data[], creal_T y_data[], int y_size
                    [1])
{
  int nInt2m1;
  int wwc_size[1];
  int idx;
  int rt;
  static creal_T wwc_data[4095];
  int nInt2;
  int k;
  int y;
  double nt_im;
  double nt_re;
  nInt2m1 = (n1 + n1) - 1;
  wwc_size[0] = nInt2m1;
  idx = n1;
  rt = 0;
  wwc_data[n1 - 1].re = 1.0;
  wwc_data[n1 - 1].im = 0.0;
  nInt2 = n1 << 1;
  for (k = 0; k <= n1 - 2; k++) {
    y = ((k + 1) << 1) - 1;
    if (nInt2 - rt <= y) {
      rt += y - nInt2;
    } else {
      rt += y;
    }

    nt_im = -3.1415926535897931 * (double)rt / (double)n1;
    if (nt_im == 0.0) {
      nt_re = 1.0;
      nt_im = 0.0;
    } else {
      nt_re = cos(nt_im);
      nt_im = sin(nt_im);
    }

    wwc_data[idx - 2].re = nt_re;
    wwc_data[idx - 2].im = -nt_im;
    idx--;
  }

  idx = 0;
  nInt2m1--;
  for (k = nInt2m1; k >= n1; k--) {
    wwc_data[k] = wwc_data[idx];
    idx++;
  }

  bluestein(x_data, x_size, N2, n1, costab_data, sintab_data, costab_data,
            sintabinv_data, wwc_data, wwc_size, y_data, y_size);
}

void generate_twiddle_tables(int nRows, boolean_T useRadix2, double costab_data[],
  int costab_size[2], double sintab_data[], int sintab_size[2], double
  sintabinv_data[], int sintabinv_size[2])
{
  double e;
  int n;
  int costab1q_size_idx_1;
  double costab1q_data[2049];
  int nd2;
  int k;
  int i;
  e = 6.2831853071795862 / (double)nRows;
  n = nRows / 2 / 2;
  costab1q_size_idx_1 = n + 1;
  costab1q_data[0] = 1.0;
  nd2 = n / 2 - 1;
  for (k = 0; k <= nd2; k++) {
    costab1q_data[k + 1] = cos(e * ((double)k + 1.0));
  }

  nd2 += 2;
  i = n - 1;
  for (k = nd2; k <= i; k++) {
    costab1q_data[k] = sin(e * (double)(n - k));
  }

  costab1q_data[n] = 0.0;
  if (!useRadix2) {
    n = costab1q_size_idx_1 - 1;
    nd2 = (costab1q_size_idx_1 - 1) << 1;
    costab_size[0] = 1;
    costab_size[1] = (short)(nd2 + 1);
    sintab_size[0] = 1;
    sintab_size[1] = (short)(nd2 + 1);
    costab_data[0] = 1.0;
    sintab_data[0] = 0.0;
    sintabinv_size[0] = 1;
    sintabinv_size[1] = (short)(nd2 + 1);
    for (k = 0; k < n; k++) {
      sintabinv_data[k + 1] = costab1q_data[(n - k) - 1];
    }

    for (k = costab1q_size_idx_1; k <= nd2; k++) {
      sintabinv_data[k] = costab1q_data[k - n];
    }

    for (k = 0; k < n; k++) {
      costab_data[k + 1] = costab1q_data[k + 1];
      sintab_data[k + 1] = -costab1q_data[(n - k) - 1];
    }

    for (k = costab1q_size_idx_1; k <= nd2; k++) {
      costab_data[k] = -costab1q_data[nd2 - k];
      sintab_data[k] = -costab1q_data[k - n];
    }
  } else {
    n = costab1q_size_idx_1 - 1;
    nd2 = (costab1q_size_idx_1 - 1) << 1;
    costab_size[0] = 1;
    costab_size[1] = (short)(nd2 + 1);
    sintab_size[0] = 1;
    sintab_size[1] = (short)(nd2 + 1);
    costab_data[0] = 1.0;
    sintab_data[0] = 0.0;
    for (k = 0; k < n; k++) {
      costab_data[k + 1] = costab1q_data[k + 1];
      sintab_data[k + 1] = -costab1q_data[(n - k) - 1];
    }

    for (k = costab1q_size_idx_1; k <= nd2; k++) {
      costab_data[k] = -costab1q_data[nd2 - k];
      sintab_data[k] = -costab1q_data[k - n];
    }

    sintabinv_size[0] = 1;
    sintabinv_size[1] = 0;
  }
}

void r2br_r2dit_trig(const double x_data[], const int x_size[1], int n1_unsigned,
                     const double costab_data[], const double sintab_data[],
                     creal_T y_data[], int y_size[1])
{
  int iDelta2;
  int nRowsM2;
  int nRowsD2;
  int nRowsD4;
  int ix;
  int ju;
  int iy;
  int i;
  boolean_T tst;
  double twid_re;
  double temp_re;
  double twid_im;
  double temp_im;
  double re;
  double im;
  int temp_re_tmp;
  int ihi;
  iDelta2 = x_size[0];
  if (iDelta2 >= n1_unsigned) {
    iDelta2 = n1_unsigned;
  }

  nRowsM2 = n1_unsigned - 2;
  nRowsD2 = n1_unsigned / 2;
  nRowsD4 = nRowsD2 / 2;
  y_size[0] = n1_unsigned;
  if (n1_unsigned > x_size[0]) {
    y_size[0] = n1_unsigned;
    if (0 <= n1_unsigned - 1) {
      memset(&y_data[0], 0, n1_unsigned * sizeof(creal_T));
    }
  }

  ix = 0;
  ju = 0;
  iy = 0;
  for (i = 0; i <= iDelta2 - 2; i++) {
    y_data[iy].re = x_data[ix];
    y_data[iy].im = 0.0;
    iy = n1_unsigned;
    tst = true;
    while (tst) {
      iy >>= 1;
      ju ^= iy;
      tst = ((ju & iy) == 0);
    }

    iy = ju;
    ix++;
  }

  y_data[iy].re = x_data[ix];
  y_data[iy].im = 0.0;
  if (n1_unsigned > 1) {
    for (i = 0; i <= nRowsM2; i += 2) {
      twid_re = y_data[i + 1].re;
      temp_re = twid_re;
      twid_im = y_data[i + 1].im;
      temp_im = twid_im;
      re = y_data[i].re;
      im = y_data[i].im;
      twid_re = y_data[i].re - twid_re;
      y_data[i + 1].re = twid_re;
      twid_im = y_data[i].im - twid_im;
      y_data[i + 1].im = twid_im;
      y_data[i].re = re + temp_re;
      y_data[i].im = im + temp_im;
    }
  }

  iy = 2;
  iDelta2 = 4;
  nRowsM2 = ((nRowsD4 - 1) << 2) + 1;
  while (nRowsD4 > 0) {
    for (i = 0; i < nRowsM2; i += iDelta2) {
      temp_re_tmp = i + iy;
      temp_re = y_data[temp_re_tmp].re;
      temp_im = y_data[temp_re_tmp].im;
      y_data[temp_re_tmp].re = y_data[i].re - y_data[temp_re_tmp].re;
      y_data[temp_re_tmp].im = y_data[i].im - y_data[temp_re_tmp].im;
      y_data[i].re += temp_re;
      y_data[i].im += temp_im;
    }

    ix = 1;
    for (ju = nRowsD4; ju < nRowsD2; ju += nRowsD4) {
      twid_re = costab_data[ju];
      twid_im = sintab_data[ju];
      i = ix;
      ihi = ix + nRowsM2;
      while (i < ihi) {
        temp_re_tmp = i + iy;
        temp_re = twid_re * y_data[temp_re_tmp].re - twid_im *
          y_data[temp_re_tmp].im;
        temp_im = twid_re * y_data[temp_re_tmp].im + twid_im *
          y_data[temp_re_tmp].re;
        y_data[temp_re_tmp].re = y_data[i].re - temp_re;
        y_data[temp_re_tmp].im = y_data[i].im - temp_im;
        y_data[i].re += temp_re;
        y_data[i].im += temp_im;
        i += iDelta2;
      }

      ix++;
    }

    nRowsD4 /= 2;
    iy = iDelta2;
    iDelta2 += iDelta2;
    nRowsM2 -= iy;
  }
}

/* End of code generation (fft1.c) */
