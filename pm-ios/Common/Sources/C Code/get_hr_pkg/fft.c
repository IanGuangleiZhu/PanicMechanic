/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * fft.c
 *
 * Code generation for function 'fft'
 *
 */

/* Include files */
#include "fft.h"
#include "fft1.h"
#include "get_hr.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void fft(const double x_data[], const int x_size[1], double varargin_1, creal_T
         y_data[], int y_size[1])
{
  boolean_T guard1 = false;
  int i;
  boolean_T useRadix2;
  int N2blue;
  int pmax;
  static double costab_data[4097];
  int costab_size[2];
  double sintab_data[4097];
  int sintab_size[2];
  double sintabinv_data[4097];
  int sintabinv_size[2];
  int pmin;
  boolean_T exitg1;
  int k;
  int pow2p;
  guard1 = false;
  if (x_size[0] == 0) {
    guard1 = true;
  } else {
    i = (int)varargin_1;
    if (i == 0) {
      guard1 = true;
    } else {
      useRadix2 = ((i & (i - 1)) == 0);
      N2blue = 1;
      if (useRadix2) {
        pmax = i;
      } else {
        N2blue = (i + i) - 1;
        pmax = 31;
        if (N2blue <= 1) {
          pmax = 0;
        } else {
          pmin = 0;
          exitg1 = false;
          while ((!exitg1) && (pmax - pmin > 1)) {
            k = (pmin + pmax) >> 1;
            pow2p = 1 << k;
            if (pow2p == N2blue) {
              pmax = k;
              exitg1 = true;
            } else if (pow2p > N2blue) {
              pmax = k;
            } else {
              pmin = k;
            }
          }
        }

        N2blue = 1 << pmax;
        pmax = N2blue;
      }

      generate_twiddle_tables(pmax, useRadix2, costab_data, costab_size,
        sintab_data, sintab_size, sintabinv_data, sintabinv_size);
      if (useRadix2) {
        r2br_r2dit_trig(x_data, x_size, i, costab_data, sintab_data, y_data,
                        y_size);
      } else {
        dobluesteinfft(x_data, x_size, N2blue, i, costab_data, sintab_data,
                       sintabinv_data, y_data, y_size);
      }
    }
  }

  if (guard1) {
    N2blue = (int)varargin_1;
    y_size[0] = N2blue;
    if (N2blue > x_size[0]) {
      y_size[0] = N2blue;
      if (0 <= N2blue - 1) {
        memset(&y_data[0], 0, N2blue * sizeof(creal_T));
      }
    }
  }
}

/* End of code generation (fft.c) */
