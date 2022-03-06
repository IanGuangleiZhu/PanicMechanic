/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * mean.c
 *
 * Code generation for function 'mean'
 *
 */

/* Include files */
#include "mean.h"
#include "get_hr.h"
#include "rt_nonfinite.h"

/* Function Definitions */
double mean(const double x_data[], const int x_size[1])
{
  double y;
  int vlen;
  int k;
  vlen = x_size[0];
  if (x_size[0] == 0) {
    y = 0.0;
  } else {
    y = x_data[0];
    for (k = 2; k <= vlen; k++) {
      y += x_data[k - 1];
    }
  }

  y /= (double)x_size[0];
  return y;
}

/* End of code generation (mean.c) */
