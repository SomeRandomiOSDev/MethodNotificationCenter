// Copied from https://opensource.apple.com/source/objc4/objc4-779.1/

#ifdef __arm64__

.macro STATIC_ENTRY /*name*/
    .text
    .align 5
    .private_extern $0
$0:
.endmacro

.macro END_ENTRY /* name */
LExit$0:
.endmacro



STATIC_ENTRY __mnc_msgForward

// No stret specialization.
b    __objc_msgForward

END_ENTRY __mnc_msgForward

#endif
