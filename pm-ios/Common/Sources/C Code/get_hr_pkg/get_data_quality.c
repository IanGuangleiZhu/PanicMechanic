/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * get_data_quality.c
 *
 * Code generation for function 'get_data_quality'
 *
 */

/* Include files */
#include "get_data_quality.h"
#include "get_freq_meas.h"
#include "get_hr.h"
#include "kurtosis.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Definitions */
double get_data_quality(const double sig_data[], const int sig_size[1], const
  double xf_data[], const int xf_size[1], double Fs)
{
  double qual;
  double fd;
  double fc;
  double dom;
  double fper;
  int nx;
  int y_size_idx_0;
  int k;
  double y_data[1256];
  double b_y_data[1256];
  double num;
  boolean_T exitg1;
  double y;
  double x_data[1255];
  double b_y;
  double b_dom[7];
  static const double b[7] = { 1.4376, 1.2665, -1.1959, -0.7447, 0.0403, -0.1639,
    0.0561 };

  /*  Extract features  */
  /*  Frequency domain characteristics */
  get_freq_meas(sig_data, sig_size, Fs, &fd, &fc, &dom, &fper);

  /*  Time domain characteristics */
  nx = xf_size[0];
  y_size_idx_0 = xf_size[0];
  for (k = 0; k < nx; k++) {
    y_data[k] = fabs(xf_data[k]);
  }

  if (0 <= y_size_idx_0 - 1) {
    memcpy(&b_y_data[0], &y_data[0], y_size_idx_0 * sizeof(double));
  }

  if (xf_size[0] <= 2) {
    if (xf_size[0] == 1) {
      num = b_y_data[0];
    } else if ((b_y_data[0] < b_y_data[1]) || (rtIsNaN(b_y_data[0]) && (!rtIsNaN
                 (b_y_data[1])))) {
      num = b_y_data[1];
    } else {
      num = b_y_data[0];
    }
  } else {
    if (!rtIsNaN(b_y_data[0])) {
      nx = 1;
    } else {
      nx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= y_size_idx_0)) {
        if (!rtIsNaN(b_y_data[k - 1])) {
          nx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (nx == 0) {
      num = b_y_data[0];
    } else {
      num = b_y_data[nx - 1];
      nx++;
      for (k = nx; k <= y_size_idx_0; k++) {
        y = b_y_data[k - 1];
        if (num < y) {
          num = y;
        }
      }
    }
  }

  /*  Apply model */
  /*  Assign quality */
  for (nx = 0; nx < y_size_idx_0; nx++) {
    x_data[nx] = y_data[nx] * y_data[nx];
  }

  if (xf_size[0] == 0) {
    y = 0.0;
  } else {
    y = x_data[0];
    for (k = 2; k <= y_size_idx_0; k++) {
      y += x_data[k - 1];
    }
  }

  nx = xf_size[0];
  if (xf_size[0] == 0) {
    b_y = 0.0;
  } else {
    b_y = xf_data[0];
    for (k = 2; k <= nx; k++) {
      b_y += xf_data[k - 1];
    }
  }

  b_dom[0] = dom;
  b_dom[1] = fper;
  b_dom[2] = kurtosis(xf_data, xf_size);
  b_dom[3] = num / sqrt(y / (double)xf_size[0]);
  b_dom[4] = fd;
  b_dom[5] = fc;
  b_dom[6] = fabs(b_y / (double)xf_size[0]);
  dom = 0.0;
  for (nx = 0; nx < 7; nx++) {
    dom += b_dom[nx] * b[nx];
  }

  if (1.0 / (exp(-(dom + 4.6384)) + 1.0) >= 0.5) {
    qual = 1.0;
  } else {
    qual = 0.0;
  }

  return qual;
}

/* End of code generation (get_data_quality.c) */
