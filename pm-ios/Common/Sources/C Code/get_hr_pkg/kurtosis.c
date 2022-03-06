/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * kurtosis.c
 *
 * Code generation for function 'kurtosis'
 *
 */

/* Include files */
#include "kurtosis.h"
#include "bsxfun.h"
#include "get_hr.h"
#include "nanmean.h"
#include "rt_nonfinite.h"

/* Function Definitions */
double kurtosis(const double x_data[], const int x_size[1])
{
  int vlen;
  double s2;
  int n;
  double x0_data[628];
  int x0_size[1];
  int b_k;
  if (x_size[0] == 0) {
    s2 = rtNaN;
  } else {
    vlen = x_size[0];
    s2 = 0.0;
    n = 0;
    for (b_k = 0; b_k < vlen; b_k++) {
      if (!rtIsNaN(x_data[b_k])) {
        s2 += x_data[b_k];
        n++;
      }
    }

    if (n == 0) {
      s2 = rtNaN;
    } else {
      s2 /= (double)n;
    }
  }

  bsxfun(x_data, x_size, s2, x0_data, x0_size);
  vlen = x0_size[0];
  for (n = 0; n < vlen; n++) {
    x0_data[n] *= x0_data[n];
  }

  s2 = nanmean(x0_data, x0_size);
  vlen = x0_size[0];
  for (n = 0; n < vlen; n++) {
    x0_data[n] *= x0_data[n];
  }

  return nanmean(x0_data, x0_size) / (s2 * s2);
}

/* End of code generation (kurtosis.c) */
