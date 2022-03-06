/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * sort.c
 *
 * Code generation for function 'sort'
 *
 */

/* Include files */
#include "sort.h"
#include "get_hr.h"
#include "rt_nonfinite.h"
#include "sortIdx.h"

/* Type Definitions */
#ifndef struct_emxArray_int32_T_1256
#define struct_emxArray_int32_T_1256

struct emxArray_int32_T_1256
{
  int data[1256];
  int size[1];
};

#endif                                 /*struct_emxArray_int32_T_1256*/

#ifndef typedef_emxArray_int32_T_1256
#define typedef_emxArray_int32_T_1256

typedef struct emxArray_int32_T_1256 emxArray_int32_T_1256;

#endif                                 /*typedef_emxArray_int32_T_1256*/

/* Function Definitions */
void sort(int x_data[], const int x_size[1])
{
  int dim;
  int j;
  int vlen;
  int vwork_size[1];
  int vstride;
  int k;
  int vwork_data[1256];
  emxArray_int32_T_1256 b_vwork_data;
  dim = 0;
  if (x_size[0] != 1) {
    dim = -1;
  }

  if (dim + 2 <= 1) {
    j = x_size[0];
  } else {
    j = 1;
  }

  vlen = j - 1;
  vwork_size[0] = j;
  vstride = 1;
  for (k = 0; k <= dim; k++) {
    vstride *= x_size[0];
  }

  for (j = 0; j < vstride; j++) {
    for (k = 0; k <= vlen; k++) {
      vwork_data[k] = x_data[j + k * vstride];
    }

    c_sortIdx(vwork_data, vwork_size, b_vwork_data.data, b_vwork_data.size);
    for (k = 0; k <= vlen; k++) {
      x_data[j + k * vstride] = vwork_data[k];
    }
  }
}

/* End of code generation (sort.c) */
