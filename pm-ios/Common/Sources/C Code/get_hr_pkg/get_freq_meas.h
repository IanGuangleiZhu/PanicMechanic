/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * get_freq_meas.h
 *
 * Code generation for function 'get_freq_meas'
 *
 */

#ifndef GET_FREQ_MEAS_H
#define GET_FREQ_MEAS_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "get_hr_types.h"

/* Function Declarations */
extern void get_freq_meas(const double x_data[], const int x_size[1], double Fs,
  double *fd, double *fc, double *dom, double *fper);

#endif

/* End of code generation (get_freq_meas.h) */
