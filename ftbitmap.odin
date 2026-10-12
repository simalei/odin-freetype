/****************************************************************************
 *
 * ftbitmap.h
 *
 *   FreeType utility functions for bitmaps (specification).
 *
 * Copyright (C) 2004-2026 by
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

when ODIN_OS == .Windows && ODIN_ARCH == .amd64 {
	foreign import lib "windows_amd64/freetype.lib"
} else when ODIN_OS == .Linux {
	foreign import lib "system:freetype"
} else {
	#panic("Your OS/arch configuration is not supported")
}

_ :: lib

@(default_calling_convention="c", link_prefix="FT_")
foreign lib {
	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Init
	*
	* @description:
	*   Initialize a pointer to an @FT_Bitmap structure.
	*
	* @inout:
	*   abitmap ::
	*     A pointer to the bitmap structure.
	*
	* @note:
	*   A deprecated name for the same function is `FT_Bitmap_New`.
	*/
	Bitmap_Init :: proc(abitmap: ^Bitmap) ---

	/* deprecated */
	Bitmap_New :: proc(abitmap: ^Bitmap) ---

	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Copy
	*
	* @description:
	*   Copy a bitmap into another one.
	*
	* @input:
	*   library ::
	*     A handle to a library object.
	*
	*   source ::
	*     A handle to the source bitmap.
	*
	* @output:
	*   target ::
	*     A handle to the target bitmap.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   `source->buffer` and `target->buffer` must neither be equal nor
	*   overlap.
	*/
	Bitmap_Copy :: proc(library: Library, source: ^Bitmap, target: ^Bitmap) -> Error ---

	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Embolden
	*
	* @description:
	*   Embolden a bitmap.  The new bitmap will be about `xStrength` pixels
	*   wider and `yStrength` pixels higher.  The left and bottom borders are
	*   kept unchanged.
	*
	* @input:
	*   library ::
	*     A handle to a library object.
	*
	*   xStrength ::
	*     How strong the glyph is emboldened horizontally.  Expressed in 26.6
	*     pixel format.
	*
	*   yStrength ::
	*     How strong the glyph is emboldened vertically.  Expressed in 26.6
	*     pixel format.
	*
	* @inout:
	*   bitmap ::
	*     A handle to the target bitmap.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   The current implementation restricts `xStrength` to be less than or
	*   equal to~8 if bitmap is of pixel_mode @FT_PIXEL_MODE_MONO.
	*
	*   If you want to embolden the bitmap owned by a @FT_GlyphSlotRec, you
	*   should call @FT_GlyphSlot_Own_Bitmap on the slot first.
	*
	*   Bitmaps in @FT_PIXEL_MODE_GRAY2 and @FT_PIXEL_MODE_GRAY@ format are
	*   converted to @FT_PIXEL_MODE_GRAY format (i.e., 8bpp).
	*/
	Bitmap_Embolden :: proc(library: Library, bitmap: ^Bitmap, xStrength: Pos, yStrength: Pos) -> Error ---

	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Convert
	*
	* @description:
	*   Convert a bitmap object with depth 1bpp, 2bpp, 4bpp, 8bpp or 32bpp to
	*   a bitmap object with depth 8bpp, making the number of used bytes per
	*   line (a.k.a. the 'pitch') a multiple of `alignment`.
	*
	* @input:
	*   library ::
	*     A handle to a library object.
	*
	*   source ::
	*     The source bitmap.
	*
	*   alignment ::
	*     The pitch of the bitmap is a multiple of this argument.  Common
	*     values are 1, 2, or 4.
	*
	* @output:
	*   target ::
	*     The target bitmap.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   It is possible to call @FT_Bitmap_Convert multiple times without
	*   calling @FT_Bitmap_Done (the memory is simply reallocated).
	*
	*   Use @FT_Bitmap_Done to finally remove the bitmap object.
	*
	*   The `library` argument is taken to have access to FreeType's memory
	*   handling functions.
	*
	*   `source->buffer` and `target->buffer` must neither be equal nor
	*   overlap.
	*/
	Bitmap_Convert :: proc(library: Library, source: ^Bitmap, target: ^Bitmap, alignment: Int) -> Error ---

	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Blend
	*
	* @description:
	*   Blend a bitmap onto another bitmap, using a given color.
	*
	* @input:
	*   library ::
	*     A handle to a library object.
	*
	*   source ::
	*     The source bitmap, which can have any @FT_Pixel_Mode format.
	*
	*   source_offset ::
	*     The offset vector to the upper left corner of the source bitmap in
	*     26.6 pixel format.  It should represent an integer offset; the
	*     function will set the lowest six bits to zero to enforce that.
	*
	*   color ::
	*     The color used to draw `source` onto `target`.
	*
	* @inout:
	*   target ::
	*     A handle to an `FT_Bitmap` object.  It should be either initialized
	*     as empty with a call to @FT_Bitmap_Init, or it should be of type
	*     @FT_PIXEL_MODE_BGRA.
	*
	*   atarget_offset ::
	*     The offset vector to the upper left corner of the target bitmap in
	*     26.6 pixel format.  It should represent an integer offset; the
	*     function will set the lowest six bits to zero to enforce that.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   This function doesn't perform clipping.
	*
	*   The bitmap in `target` gets allocated or reallocated as needed; the
	*   vector `atarget_offset` is updated accordingly.
	*
	*   In case of allocation or reallocation, the bitmap's pitch is set to
	*   `4 * width`.  Both `source` and `target` must have the same bitmap
	*   flow (as indicated by the sign of the `pitch` field).
	*
	*   `source->buffer` and `target->buffer` must neither be equal nor
	*   overlap.
	*
	* @since:
	*   2.10
	*/
	Bitmap_Blend :: proc(library: Library, source: ^Bitmap, source_offset: Vector, target: ^Bitmap, atarget_offset: ^Vector, color: Color) -> Error ---

	/**************************************************************************
	*
	* @function:
	*   FT_GlyphSlot_Own_Bitmap
	*
	* @description:
	*   Make sure that a glyph slot owns `slot->bitmap`.
	*
	* @input:
	*   slot ::
	*     The glyph slot.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   This function is to be used in combination with @FT_Bitmap_Embolden.
	*/
	GlyphSlot_Own_Bitmap :: proc(slot: GlyphSlot) -> Error ---

	/**************************************************************************
	*
	* @function:
	*   FT_Bitmap_Done
	*
	* @description:
	*   Destroy a bitmap object initialized with @FT_Bitmap_Init.
	*
	* @input:
	*   library ::
	*     A handle to a library object.
	*
	*   bitmap ::
	*     The bitmap object to be freed.
	*
	* @return:
	*   FreeType error code.  0~means success.
	*
	* @note:
	*   The `library` argument is taken to have access to FreeType's memory
	*   handling functions.
	*/
	Bitmap_Done :: proc(library: Library, bitmap: ^Bitmap) -> Error ---
}

