#if defined(__arm__) && (defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7S__) || defined(__ARM_ARCH_7K__))
#include <arm/arch.h>

.macro STATIC_ENTRY /*name*/
    .text
    .thumb
    .align 5
    .private_extern $0
    .thumb_func
$0:
.endmacro

.macro END_ENTRY /* name */
LExit$0:
.endmacro



STATIC_ENTRY __mnc_msgForward
// Method cache version

b  __objc_msgForward

END_ENTRY __mnc_msgForward

#endif
