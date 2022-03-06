/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * colon.c
 *
 * Code generation for function 'colon'
 *
 */

/* Include files */
#include "colon.h"
#include "get_hr.h"
#include "get_hr_emxutil.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
void eml_float_colon(double d, double b, emxArray_real_T *y)
{
  double ndbl;
  double apnd;
  double cdiff;
  int n;
  int nm1d2;
  int k;
  ndbl = floor(b / d + 0.5);
  apnd = ndbl * d;
  if (d > 0.0) {
    cdiff = apnd - b;
  } else {
    cdiff = b - apnd;
  }

  if (fabs(cdiff) < 4.4408920985006262E-16 * fabs(b)) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = (ndbl - 1.0) * d;
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = (int)ndbl;
  } else {
    n = 0;
  }

  nm1d2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = n;
  emxEnsureCapacity_real_T(y, nm1d2);
  if (n > 0) {
    y->data[0] = 0.0;
    if (n > 1) {
      y->data[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (k = 0; k <= nm1d2 - 2; k++) {
        ndbl = ((double)k + 1.0) * d;
        y->data[k + 1] = ndbl;
        y->data[(n - k) - 2] = apnd - ndbl;
      }

      if (nm1d2 << 1 == n - 1) {
        y->data[nm1d2] = apnd / 2.0;
      } else {
        ndbl = (double)nm1d2 * d;
        y->data[nm1d2] = ndbl;
        y->data[nm1d2 + 1] = apnd - ndbl;
      }
    }
  }
}

/* End of code generation (colon.c) */
