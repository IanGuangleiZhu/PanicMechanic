/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * get_freq_meas.c
 *
 * Code generation for function 'get_freq_meas'
 *
 */

/* Include files */
#include "get_freq_meas.h"
#include "colon.h"
#include "fft.h"
#include "get_hr.h"
#include "get_hr_emxutil.h"
#include "mean.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Declarations */
static double rt_hypotd_snf(double u0, double u1);
static double rt_powd_snf(double u0, double u1);

/* Function Definitions */
static double rt_hypotd_snf(double u0, double u1)
{
  double y;
  double a;
  a = fabs(u0);
  y = fabs(u1);
  if (a < y) {
    a /= y;
    y *= sqrt(a * a + 1.0);
  } else if (a > y) {
    y /= a;
    y = a * sqrt(y * y + 1.0);
  } else {
    if (!rtIsNaN(y)) {
      y = a * 1.4142135623730951;
    }
  }

  return y;
}

static double rt_powd_snf(double u0, double u1)
{
  double y;
  double d;
  double d1;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else {
    d = fabs(u0);
    d1 = fabs(u1);
    if (rtIsInf(u1)) {
      if (d == 1.0) {
        y = 1.0;
      } else if (d > 1.0) {
        if (u1 > 0.0) {
          y = rtInf;
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = rtInf;
      }
    } else if (d1 == 0.0) {
      y = 1.0;
    } else if (d1 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > floor(u1))) {
      y = rtNaN;
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

void get_freq_meas(const double x_data[], const int x_size[1], double Fs, double
                   *fd, double *fc, double *dom, double *fper)
{
  double f;
  int nx;
  double n;
  double df;
  int b_x_size[1];
  int loop_ub;
  int i;
  double b_x_data[628];
  static creal_T c_x_data[2048];
  int c_x_size[1];
  emxArray_real_T *P1;
  double P2_data[2048];
  int nz;
  emxArray_real_T *y;
  emxArray_real_T *freqs;
  emxArray_boolean_T *r;
  emxArray_boolean_T *r1;
  emxArray_boolean_T *x;
  emxArray_real_T *ms;
  int trueCount;
  emxArray_int32_T *r2;
  double m0;
  emxArray_int32_T *r3;
  emxArray_real_T *b_x;
  emxArray_int32_T *r4;
  emxArray_real_T *b_y;
  emxArray_int32_T *r5;
  int b_trueCount;
  boolean_T exitg1;

  /*  Computes frequency didspersion and centroidal frequency as per  */
  /*  Prietio et al, TBME, 1996. Also computes dominant frequency. */
  /*  Input: */
  /*  x - (nx1 or 1xn) signal */
  /*  Fs - (1x1) sampling rate in Hz */
  /*  fr - (1,2) frequency range in Hz to consider (e.g., [0.15, 5]) */
  /*  Output: */
  /*  fd - (1x1) frequency dispersion */
  /*  fc - (1x1) centroidal frequency */
  /*  dom - (1x1) dominant frequency */
  /*  fper - (1x1) percentage of signal power within physical range */
  /*  shp = size(x); */
  /*  if shp(2)>shp(1) */
  /*      x = x.'; */
  /*  end */
  /*  Compute fft */
  f = frexp(x_size[0], &nx);
  if (f == 0.5) {
    nx--;
  }

  n = rt_powd_snf(2.0, (double)nx + 1.0);

  /*  Compute single sided spectrum */
  df = mean(x_data, x_size);
  b_x_size[0] = x_size[0];
  loop_ub = x_size[0];
  for (i = 0; i < loop_ub; i++) {
    b_x_data[i] = x_data[i] - df;
  }

  fft(b_x_data, b_x_size, n, c_x_data, c_x_size);
  nx = x_size[0];
  loop_ub = c_x_size[0];
  for (i = 0; i < loop_ub; i++) {
    if (c_x_data[i].im == 0.0) {
      f = c_x_data[i].re / (double)nx;
      df = 0.0;
    } else if (c_x_data[i].re == 0.0) {
      f = 0.0;
      df = c_x_data[i].im / (double)nx;
    } else {
      f = c_x_data[i].re / (double)nx;
      df = c_x_data[i].im / (double)nx;
    }

    c_x_data[i].re = f;
    c_x_data[i].im = df;
  }

  nx = c_x_size[0];
  for (loop_ub = 0; loop_ub < nx; loop_ub++) {
    P2_data[loop_ub] = rt_hypotd_snf(c_x_data[loop_ub].re, c_x_data[loop_ub].im);
  }

  emxInit_real_T(&P1, 1);
  nx = (int)(n / 2.0 + 1.0);
  i = P1->size[0];
  P1->size[0] = nx;
  emxEnsureCapacity_real_T(P1, i);
  for (i = 0; i < nx; i++) {
    P1->data[i] = P2_data[i];
  }

  if (2.0 > (double)nx - 1.0) {
    i = 0;
    nx = 0;
    nz = 0;
  } else {
    i = 1;
    nx--;
    nz = 1;
  }

  loop_ub = nx - i;
  for (nx = 0; nx < loop_ub; nx++) {
    P1->data[nz + nx] = 2.0 * P2_data[i + nx];
  }

  emxInit_real_T(&y, 2);

  /*  Define frequency range */
  df = Fs / n;
  f = Fs / 2.0;
  if (rtIsNaN(df) || rtIsNaN(f)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(y, i);
    y->data[0] = rtNaN;
  } else if ((df == 0.0) || ((0.0 < f) && (df < 0.0)) || ((f < 0.0) && (df > 0.0)))
  {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (rtIsInf(f) && (rtIsInf(df) || (0.0 == f))) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(y, i);
    y->data[0] = rtNaN;
  } else if (rtIsInf(df)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(y, i);
    y->data[0] = 0.0;
  } else if (floor(df) == df) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    loop_ub = (int)floor(f / df);
    y->size[1] = loop_ub + 1;
    emxEnsureCapacity_real_T(y, i);
    for (i = 0; i <= loop_ub; i++) {
      y->data[i] = df * (double)i;
    }
  } else {
    eml_float_colon(df, f, y);
  }

  emxInit_real_T(&freqs, 1);
  i = freqs->size[0];
  freqs->size[0] = y->size[1];
  emxEnsureCapacity_real_T(freqs, i);
  loop_ub = y->size[1];
  for (i = 0; i < loop_ub; i++) {
    freqs->data[i] = y->data[i];
  }

  emxInit_boolean_T(&r, 1);

  /*  Determine freqs to consider for computing moments */
  i = r->size[0];
  r->size[0] = freqs->size[0];
  emxEnsureCapacity_boolean_T(r, i);
  loop_ub = freqs->size[0];
  for (i = 0; i < loop_ub; i++) {
    r->data[i] = (freqs->data[i] > 0.66666666666666663);
  }

  emxInit_boolean_T(&r1, 1);
  i = r1->size[0];
  r1->size[0] = freqs->size[0];
  emxEnsureCapacity_boolean_T(r1, i);
  loop_ub = freqs->size[0];
  for (i = 0; i < loop_ub; i++) {
    r1->data[i] = (freqs->data[i] < 3.6666666666666665);
  }

  emxInit_boolean_T(&x, 1);

  /*  Compute moments */
  i = x->size[0];
  x->size[0] = r->size[0];
  emxEnsureCapacity_boolean_T(x, i);
  loop_ub = r->size[0];
  for (i = 0; i < loop_ub; i++) {
    x->data[i] = (r->data[i] && r1->data[i]);
  }

  nx = x->size[0];
  if (x->size[0] == 0) {
    nz = 0;
  } else {
    nz = x->data[0];
    for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
      nz += x->data[loop_ub - 1];
    }
  }

  emxFree_boolean_T(&x);
  if (nz < 1) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    loop_ub = nz - 1;
    y->size[1] = loop_ub + 1;
    emxEnsureCapacity_real_T(y, i);
    for (i = 0; i <= loop_ub; i++) {
      y->data[i] = (double)i + 1.0;
    }
  }

  emxInit_real_T(&ms, 1);
  i = ms->size[0];
  ms->size[0] = y->size[1];
  emxEnsureCapacity_real_T(ms, i);
  loop_ub = y->size[1];
  for (i = 0; i < loop_ub; i++) {
    ms->data[i] = y->data[i];
  }

  emxFree_real_T(&y);
  loop_ub = r->size[0] - 1;
  trueCount = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      trueCount++;
    }
  }

  emxInit_int32_T(&r2, 1);
  i = r2->size[0];
  r2->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r2, i);
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      r2->data[nz] = nx + 1;
      nz++;
    }
  }

  nx = r2->size[0];
  if (r2->size[0] == 0) {
    m0 = 0.0;
  } else {
    m0 = P1->data[r2->data[0] - 1];
    for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
      m0 += P1->data[r2->data[loop_ub - 1] - 1];
    }
  }

  emxFree_int32_T(&r2);
  loop_ub = r->size[0] - 1;
  trueCount = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      trueCount++;
    }
  }

  emxInit_int32_T(&r3, 1);
  i = r3->size[0];
  r3->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r3, i);
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      r3->data[nz] = nx + 1;
      nz++;
    }
  }

  emxInit_real_T(&b_x, 1);
  i = b_x->size[0];
  b_x->size[0] = ms->size[0];
  emxEnsureCapacity_real_T(b_x, i);
  loop_ub = ms->size[0];
  for (i = 0; i < loop_ub; i++) {
    b_x->data[i] = df * ms->data[i] * P1->data[r3->data[i] - 1];
  }

  emxFree_int32_T(&r3);
  nx = b_x->size[0];
  if (b_x->size[0] == 0) {
    f = 0.0;
  } else {
    f = b_x->data[0];
    for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
      f += b_x->data[loop_ub - 1];
    }
  }

  loop_ub = r->size[0] - 1;
  trueCount = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      trueCount++;
    }
  }

  emxInit_int32_T(&r4, 1);
  i = r4->size[0];
  r4->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r4, i);
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      r4->data[nz] = nx + 1;
      nz++;
    }
  }

  emxInit_real_T(&b_y, 1);
  loop_ub = ms->size[0];
  for (i = 0; i < loop_ub; i++) {
    ms->data[i] *= df;
  }

  i = b_y->size[0];
  b_y->size[0] = ms->size[0];
  emxEnsureCapacity_real_T(b_y, i);
  nx = ms->size[0];
  for (loop_ub = 0; loop_ub < nx; loop_ub++) {
    b_y->data[loop_ub] = rt_powd_snf(ms->data[loop_ub], 2.0);
  }

  emxFree_real_T(&ms);
  i = b_x->size[0];
  b_x->size[0] = b_y->size[0];
  emxEnsureCapacity_real_T(b_x, i);
  loop_ub = b_y->size[0];
  for (i = 0; i < loop_ub; i++) {
    b_x->data[i] = b_y->data[i] * P1->data[r4->data[i] - 1];
  }

  emxFree_real_T(&b_y);
  emxFree_int32_T(&r4);
  nx = b_x->size[0];
  if (b_x->size[0] == 0) {
    n = 0.0;
  } else {
    n = b_x->data[0];
    for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
      n += b_x->data[loop_ub - 1];
    }
  }

  emxFree_real_T(&b_x);

  /*  Compute frequency dispersion */
  *fd = sqrt(1.0 - f * f / (m0 * n));

  /*  Compute centroidal frequency */
  *fc = sqrt(n / m0);

  /*  Compute freq percentage */
  loop_ub = r->size[0] - 1;
  trueCount = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      trueCount++;
    }
  }

  emxInit_int32_T(&r5, 1);
  i = r5->size[0];
  r5->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r5, i);
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      r5->data[nz] = nx + 1;
      nz++;
    }
  }

  nx = r5->size[0];
  if (r5->size[0] == 0) {
    f = 0.0;
  } else {
    f = P1->data[r5->data[0] - 1];
    for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
      f += P1->data[r5->data[loop_ub - 1] - 1];
    }
  }

  emxFree_int32_T(&r5);
  nx = P1->size[0];
  n = P1->data[0];
  for (loop_ub = 2; loop_ub <= nx; loop_ub++) {
    n += P1->data[loop_ub - 1];
  }

  *fper = f / n;

  /*  Find dominant frequency of signal */
  loop_ub = r->size[0] - 1;
  trueCount = 0;
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      trueCount++;
    }

    if (r->data[nx] && r1->data[nx]) {
      P1->data[nz] = P1->data[nx];
      nz++;
    }
  }

  i = P1->size[0];
  P1->size[0] = trueCount;
  emxEnsureCapacity_real_T(P1, i);
  loop_ub = r->size[0] - 1;
  b_trueCount = 0;
  nz = 0;
  for (nx = 0; nx <= loop_ub; nx++) {
    if (r->data[nx] && r1->data[nx]) {
      b_trueCount++;
    }

    if (r->data[nx] && r1->data[nx]) {
      freqs->data[nz] = freqs->data[nx];
      nz++;
    }
  }

  emxFree_boolean_T(&r1);
  emxFree_boolean_T(&r);
  i = freqs->size[0];
  freqs->size[0] = b_trueCount;
  emxEnsureCapacity_real_T(freqs, i);
  if (trueCount <= 2) {
    if (trueCount == 1) {
      nx = 1;
    } else if ((P1->data[0] < P1->data[1]) || (rtIsNaN(P1->data[0]) && (!rtIsNaN
                 (P1->data[1])))) {
      nx = 2;
    } else {
      nx = 1;
    }
  } else {
    if (!rtIsNaN(P1->data[0])) {
      nx = 1;
    } else {
      nx = 0;
      loop_ub = 2;
      exitg1 = false;
      while ((!exitg1) && (loop_ub <= trueCount)) {
        if (!rtIsNaN(P1->data[loop_ub - 1])) {
          nx = loop_ub;
          exitg1 = true;
        } else {
          loop_ub++;
        }
      }
    }

    if (nx == 0) {
      nx = 1;
    } else {
      f = P1->data[nx - 1];
      i = nx + 1;
      for (loop_ub = i; loop_ub <= trueCount; loop_ub++) {
        df = P1->data[loop_ub - 1];
        if (f < df) {
          f = df;
          nx = loop_ub;
        }
      }
    }
  }

  emxFree_real_T(&P1);
  *dom = freqs->data[nx - 1];
  emxFree_real_T(&freqs);
}

/* End of code generation (get_freq_meas.c) */
