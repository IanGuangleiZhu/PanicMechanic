/*
 * Trial License - for use to evaluate programs for possible purchase as
 * an end-user only.
 *
 * rt_nonfinite.h
 *
 * Code generation for function 'get_hr'
 *
 */

#ifndef RT_NONFINITE_H
#define RT_NONFINITE_H
#if defined(_MSC_VER) && (_MSC_VER <= 1200)
#include <float.h>
#endif

#include "rtwtypes.h"
#ifdef __cplusplus

extern "C" {

#endif

  typedef struct {
    struct {
      uint32_T wordH;
      uint32_T wordL;
    } words;
  } BigEndianIEEEDouble;

  typedef struct {
    struct {
      uint32_T wordL;
      uint32_T wordH;
    } words;
  } LittleEndianIEEEDouble;

  typedef struct {
    union {
      real32_T wordLreal;
      uint32_T wordLuint;
    } wordL;
  } IEEESingle;

  extern real_T rtInf;
  extern real_T rtMinusInf;
  extern real_T rtNaN;
  extern real32_T rtInfF;
  extern real32_T rtMinusInfF;
  extern real32_T rtNaNF;
  extern void rt_InitInfAndNaN(void);
  extern boolean_T rtIsInf(real_T value);
  extern boolean_T rtIsInfF(real32_T value);
  extern boolean_T rtIsNaN(real_T value);
  extern boolean_T rtIsNaNF(real32_T value);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (rt_nonfinite.h) */
