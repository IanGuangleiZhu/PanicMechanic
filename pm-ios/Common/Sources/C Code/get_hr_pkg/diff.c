/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * diff.c
 *
 * Code generation for function 'diff'
 *
 */

/* Include files */
#include "diff.h"
#include "get_hr.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void diff(const double x_data[], const int x_size[1], double y_data[], int
          y_size[1])
{
  int dimSize;
  int ixLead;
  int iyLead;
  double work_data_idx_0;
  int m;
  double tmp1;
  dimSize = x_size[0];
  if (x_size[0] == 0) {
    y_size[0] = 0;
  } else {
    ixLead = x_size[0] - 1;
    if (ixLead >= 1) {
      ixLead = 1;
    }

    if (ixLead < 1) {
      y_size[0] = 0;
    } else {
      y_size[0] = (short)(x_size[0] - 1);
      if ((short)(x_size[0] - 1) != 0) {
        ixLead = 1;
        iyLead = 0;
        work_data_idx_0 = x_data[0];
        for (m = 2; m <= dimSize; m++) {
          tmp1 = x_data[ixLead] - work_data_idx_0;
          work_data_idx_0 = x_data[ixLead];
          ixLead++;
          y_data[iyLead] = tmp1;
          iyLead++;
        }
      }
    }
  }
}

/* End of code generation (diff.c) */
