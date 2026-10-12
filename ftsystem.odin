/****************************************************************************
 *
 * ftsystem.h
 *
 *   FreeType low-level system interface definition (specification).
 *
 * Copyright (C) 1996-2026 by
 * David Turner, Robert Wilhelm, and Werner Lemberg.
 *
 * This file is part of the FreeType project, and may only be used,
 * modified, and distributed under the terms of the FreeType project
 * license, LICENSE.TXT.  By continuing to use, modify, or distribute
 * this file you indicate that you have read the license and
 * understand and accept it fully.
 *
 */
package freetype

import "core:c"

when ODIN_OS == .Windows && ODIN_ARCH == .amd64 {
	foreign import lib "windows_amd64/freetype.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "system:freetype"
} else {
	#panic("Your OS/arch configuration is not supported")
}

_ :: lib

/**************************************************************************
*
* @type:
*   FT_Memory
*
* @description:
*   A handle to a given memory manager object, defined with an
*   @FT_MemoryRec structure.
*
*/
Memory :: ^MemoryRec_

/**************************************************************************
*
* @functype:
*   FT_Alloc_Func
*
* @description:
*   A function used to allocate `size` bytes from `memory`.
*
* @input:
*   memory ::
*     A handle to the source memory manager.
*
*   size ::
*     The size in bytes to allocate.
*
* @return:
*   Address of new memory block.  0~in case of failure.
*
*/
Alloc_Func :: proc "c" (memory: Memory, size: c.long) -> rawptr

/**************************************************************************
*
* @functype:
*   FT_Free_Func
*
* @description:
*   A function used to release a given block of memory.
*
* @input:
*   memory ::
*     A handle to the source memory manager.
*
*   block ::
*     The address of the target memory block.
*
*/
Free_Func :: proc "c" (memory: Memory, block: rawptr)

/**************************************************************************
*
* @functype:
*   FT_Realloc_Func
*
* @description:
*   A function used to re-allocate a given block of memory.
*
* @input:
*   memory ::
*     A handle to the source memory manager.
*
*   cur_size ::
*     The block's current size in bytes.
*
*   new_size ::
*     The block's requested new size.
*
*   block ::
*     The block's current address.
*
* @return:
*   New block address.  0~in case of memory shortage.
*
* @note:
*   In case of error, the old block must still be available.
*
*/
Realloc_Func :: proc "c" (memory: Memory, cur_size: c.long, new_size: c.long, block: rawptr) -> rawptr

/**************************************************************************
*
* @struct:
*   FT_MemoryRec
*
* @description:
*   A structure used to describe a given memory manager to FreeType~2.
*
* @fields:
*   user ::
*     A generic typeless pointer for user data.
*
*   alloc ::
*     A pointer type to an allocation function.
*
*   free ::
*     A pointer type to an memory freeing function.
*
*   realloc ::
*     A pointer type to a reallocation function.
*
*/
MemoryRec_ :: struct {
	user:    rawptr,
	alloc:   Alloc_Func,
	free:    Free_Func,
	realloc: Realloc_Func,
}

/**************************************************************************
*
* @type:
*   FT_Stream
*
* @description:
*   A handle to an input stream.
*
* @also:
*   See @FT_StreamRec for the publicly accessible fields of a given stream
*   object.
*
*/
Stream :: ^StreamRec_

/**************************************************************************
*
* @struct:
*   FT_StreamDesc
*
* @description:
*   A union type used to store either a long or a pointer.  This is used
*   to store a file descriptor or a `FILE*` in an input stream.
*
*/
StreamDesc_ :: struct #raw_union {
	value:   c.long,
	pointer: rawptr,
}

/**************************************************************************
*
* @struct:
*   FT_StreamDesc
*
* @description:
*   A union type used to store either a long or a pointer.  This is used
*   to store a file descriptor or a `FILE*` in an input stream.
*
*/
StreamDesc :: StreamDesc_

/**************************************************************************
*
* @functype:
*   FT_Stream_IoFunc
*
* @description:
*   A function used to seek and read data from a given input stream.
*
* @input:
*   stream ::
*     A handle to the source stream.
*
*   offset ::
*     The offset from the start of the stream to seek to.
*
*   buffer ::
*     The address of the read buffer.
*
*   count ::
*     The number of bytes to read from the stream.
*
* @return:
*   If count >~0, return the number of bytes effectively read by the
*   stream (after seeking to `offset`).  If count ==~0, return the status
*   of the seek operation (non-zero indicates an error).
*
*/
Stream_IoFunc :: proc "c" (stream: Stream, offset: c.ulong, buffer: ^u8, count: c.ulong) -> c.ulong

/**************************************************************************
*
* @functype:
*   FT_Stream_CloseFunc
*
* @description:
*   A function used to close a given input stream.
*
* @input:
*  stream ::
*    A handle to the target stream.
*
*/
Stream_CloseFunc :: proc "c" (stream: Stream)

/**************************************************************************
*
* @struct:
*   FT_StreamRec
*
* @description:
*   A structure used to describe an input stream.
*
* @input:
*   base ::
*     For memory-based streams, this is the address of the first stream
*     byte in memory.  This field should always be set to `NULL` for
*     disk-based streams.
*
*   size ::
*     The stream size in bytes.
*
*     In case of compressed streams where the size is unknown before
*     actually doing the decompression, the value is set to 0x7FFFFFFF.
*     (Note that this size value can occur for normal streams also; it is
*     thus just a hint.)
*
*   pos ::
*     The current position within the stream.
*
*   descriptor ::
*     This field is a union that can hold an integer or a pointer.  It is
*     used by stream implementations to store file descriptors or `FILE*`
*     pointers.
*
*   pathname ::
*     This field is completely ignored by FreeType.  However, it is often
*     useful during debugging to use it to store the stream's filename
*     (where available).
*
*   read ::
*     The stream's input function.
*
*   close ::
*     The stream's close function.
*
*   memory ::
*     The memory manager to use to preload frames.  This is set internally
*     by FreeType and shouldn't be touched by stream implementations.
*
*   cursor ::
*     This field is set and used internally by FreeType when parsing
*     frames.  In particular, the `FT_GET_XXX` macros use this instead of
*     the `pos` field.
*
*   limit ::
*     This field is set and used internally by FreeType when parsing
*     frames.
*
*/
StreamRec_ :: struct {
	base:       ^u8,
	size:       c.ulong,
	pos:        c.ulong,
	descriptor: StreamDesc,
	pathname:   StreamDesc,
	read:       Stream_IoFunc,
	close:      Stream_CloseFunc,
	memory:     Memory,
	cursor:     ^u8,
	limit:      ^u8,
}

/**************************************************************************
*
* @struct:
*   FT_StreamRec
*
* @description:
*   A structure used to describe an input stream.
*
* @input:
*   base ::
*     For memory-based streams, this is the address of the first stream
*     byte in memory.  This field should always be set to `NULL` for
*     disk-based streams.
*
*   size ::
*     The stream size in bytes.
*
*     In case of compressed streams where the size is unknown before
*     actually doing the decompression, the value is set to 0x7FFFFFFF.
*     (Note that this size value can occur for normal streams also; it is
*     thus just a hint.)
*
*   pos ::
*     The current position within the stream.
*
*   descriptor ::
*     This field is a union that can hold an integer or a pointer.  It is
*     used by stream implementations to store file descriptors or `FILE*`
*     pointers.
*
*   pathname ::
*     This field is completely ignored by FreeType.  However, it is often
*     useful during debugging to use it to store the stream's filename
*     (where available).
*
*   read ::
*     The stream's input function.
*
*   close ::
*     The stream's close function.
*
*   memory ::
*     The memory manager to use to preload frames.  This is set internally
*     by FreeType and shouldn't be touched by stream implementations.
*
*   cursor ::
*     This field is set and used internally by FreeType when parsing
*     frames.  In particular, the `FT_GET_XXX` macros use this instead of
*     the `pos` field.
*
*   limit ::
*     This field is set and used internally by FreeType when parsing
*     frames.
*
*/
StreamRec :: StreamRec_

