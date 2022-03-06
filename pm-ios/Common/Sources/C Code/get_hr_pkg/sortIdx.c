/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * sortIdx.c
 *
 * Code generation for function 'sortIdx'
 *
 */

/* Include files */
#include "sortIdx.h"
#include "get_hr.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Declarations */
static void merge(int idx_data[], int x_data[], int offset, int np, int nq, int
                  iwork_data[], int xwork_data[]);
static void merge_block(int idx_data[], int x_data[], int offset, int n, int
  preSortLevel, int iwork_data[], int xwork_data[]);
static void merge_pow2_block(int idx_data[], int x_data[], int offset);

/* Function Definitions */
static void merge(int idx_data[], int x_data[], int offset, int np, int nq, int
                  iwork_data[], int xwork_data[])
{
  int n_tmp;
  int iout;
  int p;
  int i;
  int q;
  int exitg1;
  if (nq != 0) {
    n_tmp = np + nq;
    for (iout = 0; iout < n_tmp; iout++) {
      i = offset + iout;
      iwork_data[iout] = idx_data[i];
      xwork_data[iout] = x_data[i];
    }

    p = 0;
    q = np;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork_data[p] <= xwork_data[q]) {
        idx_data[iout] = iwork_data[p];
        x_data[iout] = xwork_data[p];
        if (p + 1 < np) {
          p++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx_data[iout] = iwork_data[q];
        x_data[iout] = xwork_data[q];
        if (q + 1 < n_tmp) {
          q++;
        } else {
          q = iout - p;
          for (iout = p + 1; iout <= np; iout++) {
            i = q + iout;
            idx_data[i] = iwork_data[iout - 1];
            x_data[i] = xwork_data[iout - 1];
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

static void merge_block(int idx_data[], int x_data[], int offset, int n, int
  preSortLevel, int iwork_data[], int xwork_data[])
{
  int nPairs;
  int bLen;
  int tailOffset;
  int nTail;
  nPairs = n >> preSortLevel;
  bLen = 1 << preSortLevel;
  while (nPairs > 1) {
    if ((nPairs & 1) != 0) {
      nPairs--;
      tailOffset = bLen * nPairs;
      nTail = n - tailOffset;
      if (nTail > bLen) {
        merge(idx_data, x_data, offset + tailOffset, bLen, nTail - bLen,
              iwork_data, xwork_data);
      }
    }

    tailOffset = bLen << 1;
    nPairs >>= 1;
    for (nTail = 0; nTail < nPairs; nTail++) {
      merge(idx_data, x_data, offset + nTail * tailOffset, bLen, bLen,
            iwork_data, xwork_data);
    }

    bLen = tailOffset;
  }

  if (n > bLen) {
    merge(idx_data, x_data, offset, bLen, n - bLen, iwork_data, xwork_data);
  }
}

static void merge_pow2_block(int idx_data[], int x_data[], int offset)
{
  int b;
  int bLen;
  int bLen2;
  int nPairs;
  int k;
  int blockOffset;
  int j;
  int p;
  int iout;
  int q;
  int iwork[256];
  int xwork[256];
  int exitg1;
  for (b = 0; b < 6; b++) {
    bLen = 1 << (b + 2);
    bLen2 = bLen << 1;
    nPairs = 256 >> (b + 3);
    for (k = 0; k < nPairs; k++) {
      blockOffset = offset + k * bLen2;
      for (j = 0; j < bLen2; j++) {
        iout = blockOffset + j;
        iwork[j] = idx_data[iout];
        xwork[j] = x_data[iout];
      }

      p = 0;
      q = bLen;
      iout = blockOffset - 1;
      do {
        exitg1 = 0;
        iout++;
        if (xwork[p] <= xwork[q]) {
          idx_data[iout] = iwork[p];
          x_data[iout] = xwork[p];
          if (p + 1 < bLen) {
            p++;
          } else {
            exitg1 = 1;
          }
        } else {
          idx_data[iout] = iwork[q];
          x_data[iout] = xwork[q];
          if (q + 1 < bLen2) {
            q++;
          } else {
            iout -= p;
            for (j = p + 1; j <= bLen; j++) {
              q = iout + j;
              idx_data[q] = iwork[j - 1];
              x_data[q] = xwork[j - 1];
            }

            exitg1 = 1;
          }
        }
      } while (exitg1 == 0);
    }
  }
}

void b_sortIdx(const double x_data[], const int x_size[1], int idx_data[], int
               idx_size[1])
{
  int n;
  int loop_ub;
  int k;
  double d;
  int i;
  int i2;
  int j;
  int pEnd;
  int p;
  int q;
  int qEnd;
  int kEnd;
  int iwork_data[1256];
  n = x_size[0] + 1;
  idx_size[0] = (short)x_size[0];
  loop_ub = (short)x_size[0];
  if (0 <= loop_ub - 1) {
    memset(&idx_data[0], 0, loop_ub * sizeof(int));
  }

  loop_ub = x_size[0] - 1;
  for (k = 1; k <= loop_ub; k += 2) {
    d = x_data[k - 1];
    if ((d >= x_data[k]) || rtIsNaN(d)) {
      idx_data[k - 1] = k;
      idx_data[k] = k + 1;
    } else {
      idx_data[k - 1] = k + 1;
      idx_data[k] = k;
    }
  }

  if ((x_size[0] & 1) != 0) {
    idx_data[x_size[0] - 1] = x_size[0];
  }

  i = 2;
  while (i < n - 1) {
    i2 = i << 1;
    j = 1;
    for (pEnd = i + 1; pEnd < n; pEnd = qEnd + i) {
      p = j - 1;
      q = pEnd;
      qEnd = j + i2;
      if (qEnd > n) {
        qEnd = n;
      }

      k = 0;
      kEnd = qEnd - j;
      while (k + 1 <= kEnd) {
        d = x_data[idx_data[p] - 1];
        loop_ub = idx_data[q - 1];
        if ((d >= x_data[loop_ub - 1]) || rtIsNaN(d)) {
          iwork_data[k] = idx_data[p];
          p++;
          if (p + 1 == pEnd) {
            while (q < qEnd) {
              k++;
              iwork_data[k] = idx_data[q - 1];
              q++;
            }
          }
        } else {
          iwork_data[k] = loop_ub;
          q++;
          if (q == qEnd) {
            while (p + 1 < pEnd) {
              k++;
              iwork_data[k] = idx_data[p];
              p++;
            }
          }
        }

        k++;
      }

      for (k = 0; k < kEnd; k++) {
        idx_data[(j + k) - 1] = iwork_data[k];
      }

      j = qEnd;
    }

    i = i2;
  }
}

void c_sortIdx(int x_data[], const int x_size[1], int idx_data[], int idx_size[1])
{
  short unnamed_idx_0;
  int i3;
  int n;
  int x4[4];
  short idx4[4];
  int iwork_data[1256];
  int xwork_data[1256];
  int nQuartets;
  int j;
  int i4;
  int i;
  int nLeft;
  int k;
  signed char perm[4];
  int i1;
  int i2;
  unnamed_idx_0 = (short)x_size[0];
  idx_size[0] = unnamed_idx_0;
  i3 = unnamed_idx_0;
  if (0 <= i3 - 1) {
    memset(&idx_data[0], 0, i3 * sizeof(int));
  }

  if (x_size[0] != 0) {
    n = x_size[0];
    x4[0] = 0;
    idx4[0] = 0;
    x4[1] = 0;
    idx4[1] = 0;
    x4[2] = 0;
    idx4[2] = 0;
    x4[3] = 0;
    idx4[3] = 0;
    i3 = unnamed_idx_0;
    if (0 <= i3 - 1) {
      memset(&iwork_data[0], 0, i3 * sizeof(int));
    }

    i3 = x_size[0];
    if (0 <= i3 - 1) {
      memset(&xwork_data[0], 0, i3 * sizeof(int));
    }

    nQuartets = x_size[0] >> 2;
    for (j = 0; j < nQuartets; j++) {
      i = j << 2;
      idx4[0] = (short)(i + 1);
      idx4[1] = (short)(i + 2);
      idx4[2] = (short)(i + 3);
      idx4[3] = (short)(i + 4);
      x4[0] = x_data[i];
      i3 = x_data[i + 1];
      x4[1] = i3;
      i4 = x_data[i + 2];
      x4[2] = i4;
      nLeft = x_data[i + 3];
      x4[3] = nLeft;
      if (x_data[i] <= i3) {
        i1 = 1;
        i2 = 2;
      } else {
        i1 = 2;
        i2 = 1;
      }

      if (i4 <= nLeft) {
        i3 = 3;
        i4 = 4;
      } else {
        i3 = 4;
        i4 = 3;
      }

      nLeft = x4[i1 - 1];
      k = x4[i3 - 1];
      if (nLeft <= k) {
        nLeft = x4[i2 - 1];
        if (nLeft <= k) {
          perm[0] = (signed char)i1;
          perm[1] = (signed char)i2;
          perm[2] = (signed char)i3;
          perm[3] = (signed char)i4;
        } else if (nLeft <= x4[i4 - 1]) {
          perm[0] = (signed char)i1;
          perm[1] = (signed char)i3;
          perm[2] = (signed char)i2;
          perm[3] = (signed char)i4;
        } else {
          perm[0] = (signed char)i1;
          perm[1] = (signed char)i3;
          perm[2] = (signed char)i4;
          perm[3] = (signed char)i2;
        }
      } else {
        k = x4[i4 - 1];
        if (nLeft <= k) {
          if (x4[i2 - 1] <= k) {
            perm[0] = (signed char)i3;
            perm[1] = (signed char)i1;
            perm[2] = (signed char)i2;
            perm[3] = (signed char)i4;
          } else {
            perm[0] = (signed char)i3;
            perm[1] = (signed char)i1;
            perm[2] = (signed char)i4;
            perm[3] = (signed char)i2;
          }
        } else {
          perm[0] = (signed char)i3;
          perm[1] = (signed char)i4;
          perm[2] = (signed char)i1;
          perm[3] = (signed char)i2;
        }
      }

      i1 = perm[0] - 1;
      idx_data[i] = idx4[i1];
      i2 = perm[1] - 1;
      idx_data[i + 1] = idx4[i2];
      i3 = perm[2] - 1;
      idx_data[i + 2] = idx4[i3];
      i4 = perm[3] - 1;
      idx_data[i + 3] = idx4[i4];
      x_data[i] = x4[i1];
      x_data[i + 1] = x4[i2];
      x_data[i + 2] = x4[i3];
      x_data[i + 3] = x4[i4];
    }

    i4 = nQuartets << 2;
    nLeft = (x_size[0] - i4) - 1;
    if (nLeft + 1 > 0) {
      for (k = 0; k <= nLeft; k++) {
        i3 = i4 + k;
        idx4[k] = (short)(i3 + 1);
        x4[k] = x_data[i3];
      }

      perm[1] = 0;
      perm[2] = 0;
      perm[3] = 0;
      if (nLeft + 1 == 1) {
        perm[0] = 1;
      } else if (nLeft + 1 == 2) {
        if (x4[0] <= x4[1]) {
          perm[0] = 1;
          perm[1] = 2;
        } else {
          perm[0] = 2;
          perm[1] = 1;
        }
      } else if (x4[0] <= x4[1]) {
        if (x4[1] <= x4[2]) {
          perm[0] = 1;
          perm[1] = 2;
          perm[2] = 3;
        } else if (x4[0] <= x4[2]) {
          perm[0] = 1;
          perm[1] = 3;
          perm[2] = 2;
        } else {
          perm[0] = 3;
          perm[1] = 1;
          perm[2] = 2;
        }
      } else if (x4[0] <= x4[2]) {
        perm[0] = 2;
        perm[1] = 1;
        perm[2] = 3;
      } else if (x4[1] <= x4[2]) {
        perm[0] = 2;
        perm[1] = 3;
        perm[2] = 1;
      } else {
        perm[0] = 3;
        perm[1] = 2;
        perm[2] = 1;
      }

      for (k = 0; k <= nLeft; k++) {
        i1 = perm[k] - 1;
        i2 = i4 + k;
        idx_data[i2] = idx4[i1];
        x_data[i2] = x4[i1];
      }
    }

    i3 = 2;
    if (n > 1) {
      if (n >= 256) {
        i3 = n >> 8;
        for (i4 = 0; i4 < i3; i4++) {
          merge_pow2_block(idx_data, x_data, i4 << 8);
        }

        i3 <<= 8;
        i4 = n - i3;
        if (i4 > 0) {
          merge_block(idx_data, x_data, i3, i4, 2, iwork_data, xwork_data);
        }

        i3 = 8;
      }

      merge_block(idx_data, x_data, 0, n, i3, iwork_data, xwork_data);
    }
  }
}

void sortIdx(const double x_data[], const int x_size[1], int idx_data[], int
             idx_size[1])
{
  int n;
  int loop_ub;
  int k;
  int i;
  int i2;
  int j;
  int pEnd;
  int p;
  int q;
  int qEnd;
  int kEnd;
  double d;
  int iwork_data[628];
  n = x_size[0] + 1;
  idx_size[0] = (short)x_size[0];
  loop_ub = (short)x_size[0];
  if (0 <= loop_ub - 1) {
    memset(&idx_data[0], 0, loop_ub * sizeof(int));
  }

  loop_ub = x_size[0] - 1;
  for (k = 1; k <= loop_ub; k += 2) {
    if ((x_data[k - 1] <= x_data[k]) || rtIsNaN(x_data[k])) {
      idx_data[k - 1] = k;
      idx_data[k] = k + 1;
    } else {
      idx_data[k - 1] = k + 1;
      idx_data[k] = k;
    }
  }

  if ((x_size[0] & 1) != 0) {
    idx_data[x_size[0] - 1] = x_size[0];
  }

  i = 2;
  while (i < n - 1) {
    i2 = i << 1;
    j = 1;
    for (pEnd = i + 1; pEnd < n; pEnd = qEnd + i) {
      p = j;
      q = pEnd - 1;
      qEnd = j + i2;
      if (qEnd > n) {
        qEnd = n;
      }

      k = 0;
      kEnd = qEnd - j;
      while (k + 1 <= kEnd) {
        d = x_data[idx_data[q] - 1];
        loop_ub = idx_data[p - 1];
        if ((x_data[loop_ub - 1] <= d) || rtIsNaN(d)) {
          iwork_data[k] = loop_ub;
          p++;
          if (p == pEnd) {
            while (q + 1 < qEnd) {
              k++;
              iwork_data[k] = idx_data[q];
              q++;
            }
          }
        } else {
          iwork_data[k] = idx_data[q];
          q++;
          if (q + 1 == qEnd) {
            while (p < pEnd) {
              k++;
              iwork_data[k] = idx_data[p - 1];
              p++;
            }
          }
        }

        k++;
      }

      for (k = 0; k < kEnd; k++) {
        idx_data[(j + k) - 1] = iwork_data[k];
      }

      j = qEnd;
    }

    i = i2;
  }
}

/* End of code generation (sortIdx.c) */
