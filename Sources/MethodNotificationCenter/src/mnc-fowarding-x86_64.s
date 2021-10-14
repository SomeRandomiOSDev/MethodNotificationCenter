// Copied from https://opensource.apple.com/source/objc4/objc4-779.1/

#include <TargetConditionals.h>
#if __x86_64__  &&  !(TARGET_OS_SIMULATOR && !(defined(TARGET_OS_IOSMAC) && TARGET_OS_IOSMAC))

.macro STATIC_ENTRY
    .text
    .private_extern    $0
    .align    2, 0x90
$0:
.endmacro

.macro END_ENTRY
LExit$0:
.endmacro



STATIC_ENTRY __mnc_msgForward
// Method cache version

// THIS IS NOT A CALLABLE C FUNCTION
// Out-of-band condition register is NE for stret, EQ otherwise.

je    __objc_msgForward_stret
jmp   __objc_msgForward

END_ENTRY __mnc_msgForward

#endif
