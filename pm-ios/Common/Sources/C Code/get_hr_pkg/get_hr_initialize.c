/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * get_hr_initialize.c
 *
 * Code generation for function 'get_hr_initialize'
 *
 */

/* Include files */
#include "get_hr_initialize.h"
#include "get_hr.h"
#include "get_hr_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void get_hr_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_get_hr = true;
}

/* End of code generation (get_hr_initialize.c) */
