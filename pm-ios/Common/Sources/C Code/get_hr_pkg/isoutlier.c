/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * isoutlier.c
 *
 * Code generation for function 'isoutlier'
 *
 */

/* Include files */
#include "isoutlier.h"
#include "get_hr.h"
#include "median.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
void isoutlier(const double a_data[], const int a_size[1], boolean_T tf_data[],
               int tf_size[1])
{
  double center;
  int x_size_idx_0;
  int loop_ub;
  int i;
  int y_size[1];
  double x_data[1256];
  double amad;
  double y_data[1256];
  double lb;
  center = median(a_data, a_size);
  x_size_idx_0 = a_size[0];
  loop_ub = a_size[0];
  for (i = 0; i < loop_ub; i++) {
    x_data[i] = a_data[i] - center;
  }

  y_size[0] = a_size[0];
  for (loop_ub = 0; loop_ub < x_size_idx_0; loop_ub++) {
    y_data[loop_ub] = fabs(x_data[loop_ub]);
  }

  amad = 1.4826022185056018 * median(y_data, y_size);
  lb = center - 3.0 * amad;
  center += 3.0 * amad;
  tf_size[0] = a_size[0];
  loop_ub = a_size[0];
  for (i = 0; i < loop_ub; i++) {
    tf_data[i] = ((a_data[i] < lb) || (a_data[i] > center));
  }
}

/* End of code generation (isoutlier.c) */
