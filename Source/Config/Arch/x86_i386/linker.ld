/*******************************************************************************
 * UTK linker file for x86 i386 target
 *
 * Created: 29/03/2023
 *
 * Author: Alexy Torres Aurora Dugo
 *
 ******************************************************************************/

/* Entry point */
ENTRY(__kinit)

/* Kernel starts at 1M in physical addresse space
 * Add the offset, to fit with values in config.h and config.inc
 * WARNING: Must be aligned on 4MB
 */
KERNEL_MEM_OFFSET = 0xE0000000;

/* Memory map */
MEMORY
{
    KERNEL_BIOS_CALL_MEM    (rwx)   :   ORIGIN = 0x00001000,    LENGTH = 4K
    LOW_STARTUP_CODE        (rx)    :   ORIGIN = 0x00100000,    LENGTH = 16K
    HIGH_STARTUP_CODE       (rx)    :   ORIGIN = 0xE0104000,    LENGTH = 16K
    KERNEL_CODE             (rx)    :   ORIGIN = 0xE0108000,    LENGTH = 256K
    KERNEL_RO_DATA          (r)     :   ORIGIN = 0xE0148000,    LENGTH = 64K
    KERNEL_RW_DATA          (rw)    :   ORIGIN = 0xE0158000,    LENGTH = 64K

    KERNEL_SYM_TAB          (rw)    :   ORIGIN = 0xE0168000,    LENGTH = 64K
    KERNEL_TRACE_BUFFER     (rw)    :   ORIGIN = 0xE0178000,    LENGTH = 64K
    KERNEL_MULTIBOOT_MEM    (rw)    :   ORIGIN = 0xE0198000,    LENGTH = 64K

    KERNEL_STACKS           (rw)    :   ORIGIN = 0xE01A8000,    LENGTH = 64K
    KERNEL_HEAP             (rw)    :   ORIGIN = 0xE01B8000,    LENGTH = 10M
}

/* Memory layout */
SECTIONS
{
    /* Contains the startup code used by grub to bootstrap the kernel */
    . = ORIGIN(LOW_STARTUP_CODE);
    .low_startup ALIGN(4K) :
    {
        _START_LOW_STARTUP_ADDR = .;
        *(.multiboot)
        . = ALIGN(16);
        *(.low_startup_code)
        _END_LOW_STARTUP_ADDR = .;
    } > LOW_STARTUP_CODE

    . = ORIGIN(HIGH_STARTUP_CODE);
    .high_startup ALIGN(4K) : AT(ADDR(.high_startup) - KERNEL_MEM_OFFSET)
    {
        . = ALIGN(16);
        _START_HIGH_STARTUP_ADDR = .;
        *(.high_startup_code)
        _END_HIGH_STARTUP_ADDR = .;
    } > HIGH_STARTUP_CODE

    /* Contains the kernel code */
    . = ORIGIN(KERNEL_CODE);
    .text ALIGN(4K) : AT(ADDR(.text) - KERNEL_MEM_OFFSET)
    {
        _START_TEXT_ADDR = .;

        *(.text)
        *(.text*)

        _END_TEXT_ADDR = .;
    } > KERNEL_CODE

    /* Contains the kernel read only data */
    . = ORIGIN(KERNEL_RO_DATA);
    .rodata ALIGN(4K) : AT(ADDR(.rodata) - KERNEL_MEM_OFFSET)
    {
        _START_RO_DATA_ADDR = .;

        *(.rodata)
        *(.rodata*)

    } > KERNEL_RO_DATA
    .eh_frame ALIGN(4K) : AT(ADDR(.eh_frame) - KERNEL_MEM_OFFSET)
    {
        *(.eh_frame)

        _END_RO_DATA_ADDR = .;
    } > KERNEL_RO_DATA

    /* Contains the kernel data */
    . = ORIGIN(KERNEL_RW_DATA);
    .data ALIGN(4K) : AT(ADDR(.data) - KERNEL_MEM_OFFSET)
    {
        _START_DATA_ADDR = .;

        *(.data)
        *(.data*)

        _END_DATA_ADDR = .;
    } > KERNEL_RW_DATA

    /* Contains the kernel BSS */
    .bss ALIGN(4K) : AT(ADDR(.bss) - KERNEL_MEM_OFFSET)
    {
        _START_BSS_ADDR = .;

        *(COMMON)
        *(.bss)

        _END_BSS_ADDR = .;
    } > KERNEL_RW_DATA
}

/* Symbols */
_KERNEL_STACKS_BASE = ORIGIN(KERNEL_STACKS);
_KERNEL_STACKS_SIZE = LENGTH(KERNEL_STACKS);

_KERNEL_HEAP_BASE  = ORIGIN(KERNEL_HEAP);
_KERNEL_HEAP_SIZE  = LENGTH(KERNEL_HEAP);

_KERNEL_BIOS_MEMORY_BASE = ORIGIN(KERNEL_BIOS_CALL_MEM);
_KERNEL_BIOS_MEMORY_SIZE = LENGTH(KERNEL_BIOS_CALL_MEM);

_KERNEL_MULTIBOOT_MEM_BASE = ORIGIN(KERNEL_MULTIBOOT_MEM);
_KERNEL_MULTIBOOT_MEM_SIZE = LENGTH(KERNEL_MULTIBOOT_MEM);

_KERNEL_SYMTAB_REG_BASE   = ORIGIN(KERNEL_SYM_TAB);
_KERNEL_SYMTAB_REG_SIZE   = LENGTH(KERNEL_SYM_TAB);
_KERNEL_SYMTAB_ADDR       = _KERNEL_SYMTAB_REG_BASE;
_KERNEL_SYMTAB_SIZE       = _KERNEL_SYMTAB_ADDR + 4;
_KERNEL_STRTAB_ADDR       = _KERNEL_SYMTAB_SIZE + 4;
_KERNEL_STRTAB_SIZE       = _KERNEL_STRTAB_ADDR + 4;
_KERNEL_SYMTAB_FREE_START = _KERNEL_STRTAB_SIZE + 4;

_KERNEL_TRACE_BUFFER_BASE = ORIGIN(KERNEL_TRACE_BUFFER);
_KERNEL_TRACE_BUFFER_SIZE = LENGTH(KERNEL_TRACE_BUFFER);
