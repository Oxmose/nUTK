/*******************************************************************************
 * @file kickstart.c
 *
 * @author Alexy Torres Aurora Dugo
 *
 * @date 30/03/2023
 *
 * @version 1.0
 *
 * @brief Kernel's main boot sequence.
 *
 * @warning At this point interrupts should be disabled.
 *
 * @details Kernel's booting sequence. Initializes the rest of the kernel and
 * performs GDT, IDT and TSS initialization. Initializes the hardware and
 * software core of the kernel before calling the scheduler.
 *
 * @copyright Alexy Torres Aurora Dugo
 ******************************************************************************/

/*******************************************************************************
 * INCLUDES
 ******************************************************************************/

/* Included headers */
#include <console.h>        /* Kernel console */
#include <vga_console.h>    /* VGA console driver */
#include <kernel_output.h>  /* Kernel logger */
#include <cpu.h>            /* CPU manager */
#include <panic.h>          /* Kernel Panic */

/* Configuration files */
#include <config.h>

/* Header file */
/* None */

/*******************************************************************************
 * CONSTANTS
 ******************************************************************************/

/** @brief Current module name */
#define MODULE_NAME "KICKSTART"

/*******************************************************************************
 * STRUCTURES AND TYPES
 ******************************************************************************/

/* None */

/*******************************************************************************
 * MACROS
 ******************************************************************************/

/* None */

/*******************************************************************************
 * GLOBAL VARIABLES
 ******************************************************************************/

/************************* Imported global variables **************************/
/* None */

/************************* Exported global variables **************************/
/* None */

/************************** Static global variables ***************************/
/* None */

/*******************************************************************************
 * STATIC FUNCTIONS DECLARATIONS
 ******************************************************************************/

/**
 * @brief Main boot sequence, C kernel entry point.
 *
 * @details Main boot sequence, C kernel entry point. Initializes each basic
 * drivers for the kernel, then init the scheduler and start the system.
 *
 * @warning This function should never return. In case of return, the kernel
 * should be able to catch the return as an error.
 */
void kickstart(void);

/*******************************************************************************
 * FUNCTIONS
 ******************************************************************************/

/* TODO: remove */
extern void scheduler_dummy_init(void);

void kickstart(void)
{
    OS_RETURN_E retVal;

    KERNEL_TRACE_EVENT(EVENT_KERNEL_KICKSTART_START, 0);

    /* TODO: remove */
    scheduler_dummy_init();

    /* Register the VGA console driver for kernel console */
    vga_console_init();
    retVal = console_set_selected_driver(vga_console_get_driver());
    console_clear_screen();

    /* TODO: Assert retVal */
    (void)retVal;

    KERNEL_INFO("UTK Kickstart\n");

    /* Initialize the CPU */
    cpu_init();

    KERNEL_TRACE_EVENT(EVENT_KERNEL_KICKSTART_END, 0);

    /* Once the scheduler is started, we should never come back here. */
    PANIC(OS_ERR_UNAUTHORIZED_ACTION, MODULE_NAME, "Kickstart returned", TRUE);
}

#undef MODULE_NAME

/************************************ EOF *************************************/