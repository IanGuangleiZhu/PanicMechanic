/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * sortIdx.h
 *
 * Code generation for function 'sortIdx'
 *
 */

#ifndef SORTIDX_H
#define SORTIDX_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "get_hr_types.h"

/* Function Declarations */
extern void b_sortIdx(const double x_data[], const int x_size[1], int idx_data[],
                      int idx_size[1]);
extern void c_sortIdx(int x_data[], const int x_size[1], int idx_data[], int
                      idx_size[1]);
extern void sortIdx(const double x_data[], const int x_size[1], int idx_data[],
                    int idx_size[1]);

#endif

/* End of code generation (sortIdx.h) */
