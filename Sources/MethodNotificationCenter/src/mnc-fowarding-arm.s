// Copied from https://opensource.apple.com/source/objc4/objc4-779.1/

#ifdef __arm__
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

// THIS IS NOT A CALLABLE C FUNCTION
// Out-of-band Z is 0 (EQ) for normal, 1 (NE) for stret

beq  __objc_msgForward
b    __objc_msgForward_stret

END_ENTRY __mnc_msgForward

#endif
