/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * findpeaks.c
 *
 * Code generation for function 'findpeaks'
 *
 */

/* Include files */
#include "findpeaks.h"
#include "eml_setop.h"
#include "get_hr.h"
#include "get_hr_emxutil.h"
#include "rt_nonfinite.h"
#include "sort.h"
#include "sortIdx.h"
#include <string.h>

/* Function Declarations */
static void c_findPeaksSeparatedByMoreThanM(const double y_data[], const double
  x_data[], const int iPk_data[], const int iPk_size[1], double Pd, int
  idx_data[], int idx_size[1]);

/* Function Definitions */
static void c_findPeaksSeparatedByMoreThanM(const double y_data[], const double
  x_data[], const int iPk_data[], const int iPk_size[1], double Pd, int
  idx_data[], int idx_size[1])
{
  int locs_temp_size[1];
  int n;
  int i;
  double locs_temp_data[1256];
  int sortIdx_data[1256];
  int sortIdx_size[1];
  int yk;
  int idelete_size_idx_0;
  boolean_T idelete_data[1256];
  int b_i;
  double x;
  double b_x;
  boolean_T tmp_data[1256];
  short b_tmp_data[1256];
  if ((iPk_size[0] == 0) || (Pd == 0.0)) {
    if (iPk_size[0] < 1) {
      n = 0;
    } else {
      n = iPk_size[0];
    }

    if (n > 0) {
      sortIdx_data[0] = 1;
      yk = 1;
      for (idelete_size_idx_0 = 2; idelete_size_idx_0 <= n; idelete_size_idx_0++)
      {
        yk++;
        sortIdx_data[idelete_size_idx_0 - 1] = yk;
      }
    }

    idx_size[0] = n;
    if (0 <= n - 1) {
      memcpy(&idx_data[0], &sortIdx_data[0], n * sizeof(int));
    }
  } else {
    locs_temp_size[0] = iPk_size[0];
    n = iPk_size[0];
    for (i = 0; i < n; i++) {
      locs_temp_data[i] = y_data[iPk_data[i] - 1];
    }

    b_sortIdx(locs_temp_data, locs_temp_size, sortIdx_data, sortIdx_size);
    n = sortIdx_size[0];
    for (i = 0; i < n; i++) {
      locs_temp_data[i] = x_data[iPk_data[sortIdx_data[i] - 1] - 1];
    }

    idelete_size_idx_0 = (short)sortIdx_size[0];
    n = (short)sortIdx_size[0];
    if (0 <= n - 1) {
      memset(&idelete_data[0], 0, n * sizeof(boolean_T));
    }

    i = sortIdx_size[0];
    for (b_i = 0; b_i < i; b_i++) {
      if (!idelete_data[b_i]) {
        n = iPk_data[sortIdx_data[b_i] - 1] - 1;
        x = x_data[n] - Pd;
        b_x = x_data[n] + Pd;
        n = sortIdx_size[0];
        for (yk = 0; yk < n; yk++) {
          tmp_data[yk] = ((locs_temp_data[yk] >= x) && (locs_temp_data[yk] <=
            b_x));
        }

        for (yk = 0; yk < idelete_size_idx_0; yk++) {
          idelete_data[yk] = (idelete_data[yk] || tmp_data[yk]);
        }

        idelete_data[b_i] = false;
      }
    }

    n = idelete_size_idx_0 - 1;
    idelete_size_idx_0 = 0;
    for (b_i = 0; b_i <= n; b_i++) {
      if (!idelete_data[b_i]) {
        idelete_size_idx_0++;
      }
    }

    yk = 0;
    for (b_i = 0; b_i <= n; b_i++) {
      if (!idelete_data[b_i]) {
        b_tmp_data[yk] = (short)(b_i + 1);
        yk++;
      }
    }

    idx_size[0] = idelete_size_idx_0;
    for (i = 0; i < idelete_size_idx_0; i++) {
      idx_data[i] = sortIdx_data[b_tmp_data[i] - 1];
    }

    sort(idx_data, idx_size);
  }
}

void findpeaks(const double Yin_data[], const int Yin_size[1], double varargin_2,
               double varargin_4, double Ypk_data[], int Ypk_size[1], double
               Xpk_data[], int Xpk_size[1])
{
  emxArray_real_T *y;
  emxArray_real_T *b_y;
  int i;
  int kfirst;
  emxArray_real_T *c_y;
  emxArray_real_T *d_y;
  double x_data[628];
  int ny;
  int nPk;
  int nInf;
  char dir;
  double ykfirst;
  boolean_T isinfykfirst;
  int k;
  double yk;
  boolean_T isinfyk;
  int iInfinite_size[1];
  int iInfinite_data[628];
  char previousdir;
  int iFinite_data[628];
  int iPk_size[1];
  int iPk_data[628];
  int c_data[1256];
  int c_size[1];
  int iInflect_data[628];
  int iInflect_size[1];
  int iFinite_size[1];
  int idx_data[1256];
  int b_idx_data[1256];
  int b_iPk_data[1256];
  emxInit_real_T(&y, 2);
  emxInit_real_T(&b_y, 2);
  if (Yin_size[0] < 1) {
    y->size[0] = 1;
    y->size[1] = 0;
    b_y->size[0] = 1;
    b_y->size[1] = 0;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = Yin_size[0];
    emxEnsureCapacity_real_T(y, i);
    kfirst = Yin_size[0] - 1;
    for (i = 0; i <= kfirst; i++) {
      y->data[i] = (double)i + 1.0;
    }

    i = b_y->size[0] * b_y->size[1];
    b_y->size[0] = 1;
    b_y->size[1] = Yin_size[0];
    emxEnsureCapacity_real_T(b_y, i);
    kfirst = Yin_size[0] - 1;
    for (i = 0; i <= kfirst; i++) {
      b_y->data[i] = (double)i + 1.0;
    }
  }

  emxInit_real_T(&c_y, 1);
  i = c_y->size[0];
  c_y->size[0] = y->size[1];
  emxEnsureCapacity_real_T(c_y, i);
  kfirst = y->size[1];
  for (i = 0; i < kfirst; i++) {
    c_y->data[i] = y->data[i];
  }

  emxFree_real_T(&y);
  emxInit_real_T(&d_y, 1);
  i = d_y->size[0];
  d_y->size[0] = b_y->size[1];
  emxEnsureCapacity_real_T(d_y, i);
  kfirst = b_y->size[1];
  for (i = 0; i < kfirst; i++) {
    d_y->data[i] = b_y->data[i];
  }

  emxFree_real_T(&b_y);
  kfirst = c_y->size[0];
  emxFree_real_T(&c_y);
  for (i = 0; i < kfirst; i++) {
    x_data[i] = d_y->data[i];
  }

  emxFree_real_T(&d_y);
  ny = Yin_size[0];
  nPk = 0;
  nInf = 0;
  dir = 'n';
  kfirst = 0;
  ykfirst = rtInf;
  isinfykfirst = true;
  for (k = 1; k <= ny; k++) {
    yk = Yin_data[k - 1];
    if (rtIsNaN(yk)) {
      yk = rtInf;
      isinfyk = true;
    } else if (rtIsInf(yk) && (yk > 0.0)) {
      isinfyk = true;
      nInf++;
      iInfinite_data[nInf - 1] = k;
    } else {
      isinfyk = false;
    }

    if (yk != ykfirst) {
      previousdir = dir;
      if (isinfyk || isinfykfirst) {
        dir = 'n';
      } else if (yk < ykfirst) {
        dir = 'd';
        if (('d' != previousdir) && (previousdir == 'i')) {
          nPk++;
          iFinite_data[nPk - 1] = kfirst;
        }
      } else {
        dir = 'i';
      }

      ykfirst = yk;
      kfirst = k;
      isinfykfirst = isinfyk;
    }
  }

  if (1 > nPk) {
    i = 0;
  } else {
    i = nPk;
  }

  if (1 > nInf) {
    iInfinite_size[0] = 0;
  } else {
    iInfinite_size[0] = nInf;
  }

  nPk = 0;
  for (k = 0; k < i; k++) {
    ykfirst = Yin_data[iFinite_data[k] - 1];
    if (ykfirst > varargin_4) {
      yk = Yin_data[iFinite_data[k] - 2];
      if ((!(yk > Yin_data[iFinite_data[k]])) && (!rtIsNaN
           (Yin_data[iFinite_data[k]]))) {
        yk = Yin_data[iFinite_data[k]];
      }

      if (ykfirst - yk >= 0.0) {
        nPk++;
        iPk_data[nPk - 1] = iFinite_data[k];
      }
    }
  }

  if (1 > nPk) {
    iPk_size[0] = 0;
  } else {
    iPk_size[0] = nPk;
  }

  do_vectors(iPk_data, iPk_size, iInfinite_data, iInfinite_size, c_data, c_size,
             iInflect_data, iInflect_size, iFinite_data, iFinite_size);
  c_findPeaksSeparatedByMoreThanM(Yin_data, x_data, c_data, c_size, varargin_2,
    idx_data, iInfinite_size);
  if (iInfinite_size[0] > Yin_size[0]) {
    kfirst = Yin_size[0];
    ny = Yin_size[0];
    if (0 <= kfirst - 1) {
      memcpy(&b_idx_data[0], &idx_data[0], kfirst * sizeof(int));
    }

    iInfinite_size[0] = Yin_size[0];
    if (0 <= ny - 1) {
      memcpy(&idx_data[0], &b_idx_data[0], ny * sizeof(int));
    }
  }

  ny = iInfinite_size[0];
  kfirst = iInfinite_size[0];
  for (i = 0; i < kfirst; i++) {
    b_iPk_data[i] = c_data[idx_data[i] - 1];
  }

  Ypk_size[0] = iInfinite_size[0];
  for (i = 0; i < ny; i++) {
    Ypk_data[i] = Yin_data[b_iPk_data[i] - 1];
  }

  Xpk_size[0] = iInfinite_size[0];
  for (i = 0; i < ny; i++) {
    Xpk_data[i] = x_data[b_iPk_data[i] - 1];
  }
}

/* End of code generation (findpeaks.c) */
