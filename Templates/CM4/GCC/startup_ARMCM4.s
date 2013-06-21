/**************************************************************************//**
 * @file     startup_ARMCM4.s
 * @brief    CMSIS Cortex-M4 Core Device Startup File
 *           for CM4 Device Series
 * @version  V1.05
 * @date     25. July 2011
 *
 * @note     Version GNU Tools for ARM Embedded Processors
 * Copyright (C) 2010-2011 ARM Limited. All rights reserved.
 *
 * @par
 * ARM Limited (ARM) is supplying this software for use with Cortex-M 
 * processor based microcontrollers.  This file can be freely distributed 
 * within development tools that are supporting such ARM based processors. 
 *
 * @par
 * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
 * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 ******************************************************************************/
/*
//-------- <<< Use Configuration Wizard in Context Menu >>> ------------------
*/


/*
// <h> Stack Configuration
//   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
// </h>
*/
    .equ    stack_size, 0x00000400

    .section ".stack", "w"
    .align  3
    .globl  stack_memory
stack_memory:
    .if     stack_size
    .space  stack_size
    .endif
    .size   stack_memory, . - stack_memory



/*
// <h> Heap Configuration
//   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
// </h>
*/
    .equ    heap_size,  0x00000000
    
    .section ".heap", "w"
    .align  3
    .globl  heap_memory
heap_memory:
    .if     heap_size
    .space  heap_size
    .endif
    .size   heap_memory, . - heap_memory


/* Vector Table */

    .section ".isr_vector"
    .globl  interrupt_vector_cortex_m
    .type   interrupt_vector_cortex_m, %object

interrupt_vector_cortex_m:
    .word   __StackTop                  /* Top of Stack                 */
    .word   Reset_Handler               /* Reset Handler                */
    .word   NMI_Handler                 /* NMI Handler                  */
    .word   HardFault_Handler           /* Hard Fault Handler           */
    .word   MemManage_Handler           /* MPU Fault Handler            */
    .word   BusFault_Handler            /* Bus Fault Handler            */
    .word   UsageFault_Handler          /* Usage Fault Handler          */
    .word   0                           /* Reserved                     */
    .word   0                           /* Reserved                     */
    .word   0                           /* Reserved                     */
    .word   0                           /* Reserved                     */
    .word   SVC_Handler                 /* SVCall Handler               */
    .word   DebugMon_Handler            /* Debug Monitor Handler        */
    .word   0                           /* Reserved                     */
    .word   PendSV_Handler              /* PendSV Handler               */
    .word   SysTick_Handler             /* SysTick Handler              */

    /* External Interrupts */
    .word   DEF_IRQHandler              /*  0: Default                  */

    .size   interrupt_vector_cortex_m, . - interrupt_vector_cortex_m


    .syntax unified
    .thumb


/* Reset Handler */

    .section ".text"
    .thumb_func
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
    .fnstart
    
    /* Execute SystemInit */
    LDR     R0,=SystemInit
    BLX     R0

    /* Initialize .data section (copy from ROM to RAM) */
    LDR     R1,= __etext
    LDR     R0,= __data_start__
    LDR     R2,= __data_end__
    SUBS    R2,R2,R0
    BL      memcpy

    /* Zero init .bss section not required - done in pre-main */

    /* Start pre-main */
    LDR     R0,=_start
    BX      R0
    
    .cantunwind
    .pool
    .fnend
    .size   Reset_Handler,  .-Reset_Handler

    .section ".text"

/* Exception Handlers */

    .weak   NMI_Handler
    .type   NMI_Handler, %function
NMI_Handler:
    B       .
    .size   NMI_Handler, . - NMI_Handler

    .weak   HardFault_Handler
    .type   HardFault_Handler, %function
HardFault_Handler:
    B       .
    .size   HardFault_Handler, . - HardFault_Handler

    .weak   MemManage_Handler
    .type   MemManage_Handler, %function
MemManage_Handler:
    B       .
    .size   MemManage_Handler, . - MemManage_Handler

    .weak   BusFault_Handler
    .type   BusFault_Handler, %function
BusFault_Handler:
    B       .
    .size   BusFault_Handler, . - BusFault_Handler

    .weak   UsageFault_Handler
    .type   UsageFault_Handler, %function
UsageFault_Handler:
    B       .
    .size   UsageFault_Handler, . - UsageFault_Handler

    .weak   SVC_Handler
    .type   SVC_Handler, %function
SVC_Handler:
    B       .
    .size   SVC_Handler, . - SVC_Handler

    .weak   DebugMon_Handler
    .type   DebugMon_Handler, %function
DebugMon_Handler:
    B       .
    .size   DebugMon_Handler, . - DebugMon_Handler

    .weak   PendSV_Handler
    .type   PendSV_Handler, %function
PendSV_Handler:
    B       .
    .size   PendSV_Handler, . - PendSV_Handler

    .weak   SysTick_Handler
    .type   SysTick_Handler, %function
SysTick_Handler:
    B       .
    .size   SysTick_Handler, . - SysTick_Handler


/* IRQ Handlers */

    .globl  Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    B       .
    .size   Default_Handler, . - Default_Handler

    .macro  IRQ handler
    .weak   \handler
    .set    \handler, Default_Handler
    .endm

    IRQ     DEF_IRQHandler


    .end
