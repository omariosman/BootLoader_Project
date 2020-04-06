        check_long_mode:
            pusha                           ; Save all general purpose registers on the stack
            call check_cpuid_support        ; Check if cpuid instruction is supported by the CPU
            call check_long_mode_with_cpuid ; check long mode using cpuid
            popa                            ; Restore all general purpose registers from the stack
            ret

        check_cpuid_support:
            pusha               ; Save all general purpose registers on the stack


                  ; This function need to be written by you.



            popa                ; Restore all general purpose registers from the stack
            ret

        check_long_mode_with_cpuid:
            pusha                                   ; Save all general purpose registers on the stack

                  ; This function need to be written by you.

            popa                                ; Restore all general purpose registers from the stack
            ret