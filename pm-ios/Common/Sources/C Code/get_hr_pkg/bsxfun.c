/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * bsxfun.c
 *
 * Code generation for function 'bsxfun'
 *
 */

/* Include files */
#include "bsxfun.h"
#include "get_hr.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void bsxfun(const double a_data[], const int a_size[1], double b, double c_data[],
            int c_size[1])
{
  int acoef;
  int i;
  int k;
  c_size[0] = (short)a_size[0];
  if ((short)a_size[0] != 0) {
    acoef = (a_size[0] != 1);
    i = (short)a_size[0] - 1;
    for (k = 0; k <= i; k++) {
      c_data[k] = a_data[acoef * k] - b;
    }
  }
}

/* End of code generation (bsxfun.c) */
