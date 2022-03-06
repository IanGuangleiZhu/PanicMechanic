/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * vmedian.c
 *
 * Code generation for function 'vmedian'
 *
 */

/* Include files */
#include "vmedian.h"
#include "get_hr.h"
#include "quickselect.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
double vmedian(double v_data[], const int v_size[1], int n)
{
  double m;
  int vlen;
  int k;
  int midm1;
  int unusedU5;
  double unusedU3_data[1256];
  double b;
  vlen = 0;
  for (k = 0; k < n; k++) {
    if (!rtIsNaN(v_data[k])) {
      vlen++;
      if (vlen < k + 1) {
        v_data[vlen - 1] = v_data[k];
      }
    }
  }

  if (vlen <= 4) {
    if (vlen == 0) {
      m = rtNaN;
    } else if (vlen == 1) {
      m = v_data[0];
    } else if (vlen == 2) {
      if (rtIsInf(v_data[0]) || rtIsInf(v_data[1])) {
        m = (v_data[0] + v_data[1]) / 2.0;
      } else {
        m = v_data[0] + (v_data[1] - v_data[0]) / 2.0;
      }
    } else if (vlen == 3) {
      if (v_data[0] < v_data[1]) {
        if (v_data[1] < v_data[2]) {
          unusedU5 = 1;
        } else if (v_data[0] < v_data[2]) {
          unusedU5 = 2;
        } else {
          unusedU5 = 0;
        }
      } else if (v_data[0] < v_data[2]) {
        unusedU5 = 0;
      } else if (v_data[1] < v_data[2]) {
        unusedU5 = 2;
      } else {
        unusedU5 = 1;
      }

      m = v_data[unusedU5];
    } else {
      if (v_data[0] < v_data[1]) {
        if (v_data[1] < v_data[2]) {
          k = 0;
          unusedU5 = 1;
          vlen = 2;
        } else if (v_data[0] < v_data[2]) {
          k = 0;
          unusedU5 = 2;
          vlen = 1;
        } else {
          k = 2;
          unusedU5 = 0;
          vlen = 1;
        }
      } else if (v_data[0] < v_data[2]) {
        k = 1;
        unusedU5 = 0;
        vlen = 2;
      } else if (v_data[1] < v_data[2]) {
        k = 1;
        unusedU5 = 2;
        vlen = 0;
      } else {
        k = 2;
        unusedU5 = 1;
        vlen = 0;
      }

      if (v_data[k] < v_data[3]) {
        if (v_data[3] < v_data[vlen]) {
          if (rtIsInf(v_data[unusedU5]) || rtIsInf(v_data[3])) {
            m = (v_data[unusedU5] + v_data[3]) / 2.0;
          } else {
            m = v_data[unusedU5] + (v_data[3] - v_data[unusedU5]) / 2.0;
          }
        } else if (rtIsInf(v_data[unusedU5]) || rtIsInf(v_data[vlen])) {
          m = (v_data[unusedU5] + v_data[vlen]) / 2.0;
        } else {
          m = v_data[unusedU5] + (v_data[vlen] - v_data[unusedU5]) / 2.0;
        }
      } else if (rtIsInf(v_data[k]) || rtIsInf(v_data[unusedU5])) {
        m = (v_data[k] + v_data[unusedU5]) / 2.0;
      } else {
        m = v_data[k] + (v_data[unusedU5] - v_data[k]) / 2.0;
      }
    }
  } else {
    midm1 = vlen >> 1;
    if ((vlen & 1) == 0) {
      quickselect(v_data, midm1 + 1, vlen, &m, &k, &unusedU5);
      if (midm1 < k) {
        k = v_size[0];
        if (0 <= k - 1) {
          memcpy(&unusedU3_data[0], &v_data[0], k * sizeof(double));
        }

        quickselect(unusedU3_data, midm1, unusedU5 - 1, &b, &k, &vlen);
        if (rtIsInf(m) || rtIsInf(b)) {
          m = (m + b) / 2.0;
        } else {
          m += (b - m) / 2.0;
        }
      }
    } else {
      k = v_size[0];
      if (0 <= k - 1) {
        memcpy(&unusedU3_data[0], &v_data[0], k * sizeof(double));
      }

      quickselect(unusedU3_data, midm1 + 1, vlen, &m, &k, &unusedU5);
    }
  }

  return m;
}

/* End of code generation (vmedian.c) */
