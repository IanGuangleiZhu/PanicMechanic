/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * nanmean.c
 *
 * Code generation for function 'nanmean'
 *
 */

/* Include files */
#include "nanmean.h"
#include "get_hr.h"
#include "rt_nonfinite.h"

/* Function Definitions */
double nanmean(const double varargin_1_data[], const int varargin_1_size[1])
{
  double y;
  int vlen;
  int c;
  int k;
  if (varargin_1_size[0] == 0) {
    y = rtNaN;
  } else {
    vlen = varargin_1_size[0];
    y = 0.0;
    c = 0;
    for (k = 0; k < vlen; k++) {
      if (!rtIsNaN(varargin_1_data[k])) {
        y += varargin_1_data[k];
        c++;
      }
    }

    if (c == 0) {
      y = rtNaN;
    } else {
      y /= (double)c;
    }
  }

  return y;
}

/* End of code generation (nanmean.c) */
