/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * median.c
 *
 * Code generation for function 'median'
 *
 */

/* Include files */
#include "median.h"
#include "get_hr.h"
#include "rt_nonfinite.h"
#include "vmedian.h"
#include <string.h>

/* Function Definitions */
double median(const double x_data[], const int x_size[1])
{
  double y;
  int b_x_size[1];
  int loop_ub;
  double b_x_data[1256];
  if (x_size[0] == 0) {
    y = rtNaN;
  } else {
    b_x_size[0] = x_size[0];
    loop_ub = x_size[0];
    if (0 <= loop_ub - 1) {
      memcpy(&b_x_data[0], &x_data[0], loop_ub * sizeof(double));
    }

    y = vmedian(b_x_data, b_x_size, x_size[0]);
  }

  return y;
}

/* End of code generation (median.c) */
