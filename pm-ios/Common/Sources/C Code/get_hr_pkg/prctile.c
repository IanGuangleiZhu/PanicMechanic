/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * prctile.c
 *
 * Code generation for function 'prctile'
 *
 */

/* Include files */
#include "prctile.h"
#include "get_hr.h"
#include "rt_nonfinite.h"
#include "sortIdx.h"
#include <math.h>

/* Function Declarations */
static double rt_roundd_snf(double u);

/* Function Definitions */
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

double prctile(const double x_data[], const int x_size[1])
{
  double y;
  int idx_data[628];
  int idx_size[1];
  int nj;
  double r;
  int i;
  if (x_size[0] == 0) {
    y = rtNaN;
  } else {
    sortIdx(x_data, x_size, idx_data, idx_size);
    nj = x_size[0];
    while ((nj > 0) && rtIsNaN(x_data[idx_data[nj - 1] - 1])) {
      nj--;
    }

    if (nj < 1) {
      y = rtNaN;
    } else if (nj == 1) {
      y = x_data[idx_data[0] - 1];
    } else {
      r = 0.75 * (double)nj;
      i = (int)rt_roundd_snf(r);
      if (i >= nj) {
        y = x_data[idx_data[nj - 1] - 1];
      } else {
        r -= (double)i;
        y = (0.5 - r) * x_data[idx_data[i - 1] - 1] + (r + 0.5) *
          x_data[idx_data[i] - 1];
      }
    }
  }

  return y;
}

/* End of code generation (prctile.c) */
