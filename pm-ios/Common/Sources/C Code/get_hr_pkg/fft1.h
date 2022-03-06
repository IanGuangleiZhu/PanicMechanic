/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * fft1.h
 *
 * Code generation for function 'fft1'
 *
 */

#ifndef FFT1_H
#define FFT1_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "get_hr_types.h"

/* Function Declarations */
extern void dobluesteinfft(const double x_data[], const int x_size[1], int N2,
  int n1, const double costab_data[], const double sintab_data[], const double
  sintabinv_data[], creal_T y_data[], int y_size[1]);
extern void generate_twiddle_tables(int nRows, boolean_T useRadix2, double
  costab_data[], int costab_size[2], double sintab_data[], int sintab_size[2],
  double sintabinv_data[], int sintabinv_size[2]);
extern void r2br_r2dit_trig(const double x_data[], const int x_size[1], int
  n1_unsigned, const double costab_data[], const double sintab_data[], creal_T
  y_data[], int y_size[1]);

#endif

/* End of code generation (fft1.h) */
