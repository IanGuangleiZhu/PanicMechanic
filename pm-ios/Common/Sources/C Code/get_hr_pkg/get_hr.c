/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * get_hr.c
 *
 * Code generation for function 'get_hr'
 *
 */

/* Include files */
#include "get_hr.h"
#include "diff.h"
#include "findpeaks.h"
#include "get_data_quality.h"
#include "get_hr_data.h"
#include "get_hr_initialize.h"
#include "isoutlier.h"
#include "prctile.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void get_hr(const double sig_data[], const int sig_size[1], double Fs, double
            *hr, double *qual)
{
  int naxpy;
  int loop_ub;
  int j;
  int nx;
  double x_data[628];
  int xf_size[1];
  double xf_data[628];
  int k;
  double pks_data[1256];
  int pks_size[1];
  double locs_data[1256];
  int locs_size[1];
  boolean_T ind_pkout_data[1256];
  int ind_pkout_size[1];
  int xf_tmp;
  static const double dv[5] = { 0.76004918649268927, -3.0401967459707571,
    4.5602951189561356, -3.0401967459707571, 0.76004918649268927 };

  double as;
  static const double dv1[5] = { 1.0, -3.452912199249865, 4.5034622282619434,
    -2.6267377818453905, 0.57767477452582949 };

  double hrs_data[1255];
  boolean_T tmp_data[1255];
  boolean_T b_tmp_data[1255];
  if (isInitialized_get_hr == false) {
    get_hr_initialize();
  }

  /*  HPF signal  */
  naxpy = sig_size[0];
  loop_ub = sig_size[0];
  for (j = 0; j < loop_ub; j++) {
    x_data[j] = sig_data[j] - sig_data[0];
  }

  nx = sig_size[0] - 1;
  xf_size[0] = sig_size[0];
  if (0 <= naxpy - 1) {
    memset(&xf_data[0], 0, naxpy * sizeof(double));
  }

  for (k = 0; k <= nx; k++) {
    loop_ub = nx - k;
    naxpy = loop_ub + 1;
    if (naxpy >= 5) {
      naxpy = 5;
    }

    for (j = 0; j < naxpy; j++) {
      xf_tmp = k + j;
      xf_data[xf_tmp] += x_data[k] * dv[j];
    }

    if (loop_ub < 4) {
      naxpy = loop_ub;
    } else {
      naxpy = 4;
    }

    as = -xf_data[k];
    for (j = 0; j < naxpy; j++) {
      xf_tmp = (k + j) + 1;
      xf_data[xf_tmp] += as * dv1[j + 1];
    }
  }

  /*  Estimate signal quality  */
  *qual = get_data_quality(sig_data, sig_size, xf_data, xf_size, Fs);

  /*  Detect peaks with physiologically relevant inter-peak distance */
  findpeaks(xf_data, xf_size, 0.27 * Fs, prctile(xf_data, xf_size), pks_data,
            pks_size, locs_data, locs_size);

  /* find peaks that are seperated by at least 1/(220 bpm / 60 s/m) */
  /*  remove pk outliers */
  isoutlier(pks_data, pks_size, ind_pkout_data, ind_pkout_size);
  loop_ub = ind_pkout_size[0] - 1;
  xf_tmp = 0;
  j = 0;
  for (naxpy = 0; naxpy <= loop_ub; naxpy++) {
    if (!ind_pkout_data[naxpy]) {
      xf_tmp++;
      locs_data[j] = locs_data[naxpy];
      j++;
    }
  }

  locs_size[0] = xf_tmp;

  /*  Compute instantaneous hr from R-R intervals */
  diff(locs_data, locs_size, hrs_data, xf_size);
  loop_ub = xf_size[0];
  for (j = 0; j < loop_ub; j++) {
    hrs_data[j] = 60.0 / (hrs_data[j] / Fs);
  }

  /*  bpm */
  /*  Remove non-physiological intervals */
  loop_ub = xf_size[0];
  for (j = 0; j < loop_ub; j++) {
    tmp_data[j] = (hrs_data[j] >= 40.0);
  }

  loop_ub = xf_size[0];
  for (j = 0; j < loop_ub; j++) {
    b_tmp_data[j] = (hrs_data[j] <= 220.0);
  }

  loop_ub = xf_size[0] - 1;
  xf_tmp = 0;
  j = 0;
  for (naxpy = 0; naxpy <= loop_ub; naxpy++) {
    if (tmp_data[naxpy] && b_tmp_data[naxpy]) {
      xf_tmp++;
    }

    if (tmp_data[naxpy] && b_tmp_data[naxpy]) {
      hrs_data[j] = hrs_data[naxpy];
      j++;
    }
  }

  xf_size[0] = xf_tmp;

  /*  remove outliers */
  isoutlier(hrs_data, xf_size, ind_pkout_data, ind_pkout_size);
  loop_ub = ind_pkout_size[0];
  for (j = 0; j < loop_ub; j++) {
    tmp_data[j] = !ind_pkout_data[j];
  }

  loop_ub = ind_pkout_size[0] - 1;
  xf_tmp = 0;
  j = 0;
  for (naxpy = 0; naxpy <= loop_ub; naxpy++) {
    if (tmp_data[naxpy]) {
      xf_tmp++;
      hrs_data[j] = hrs_data[naxpy];
      j++;
    }
  }

  /*  Compute average HR */
  if (xf_tmp == 0) {
    as = 0.0;
  } else {
    as = hrs_data[0];
    for (k = 2; k <= xf_tmp; k++) {
      as += hrs_data[k - 1];
    }
  }

  *hr = as / (double)xf_tmp;
}

/* End of code generation (get_hr.c) */
