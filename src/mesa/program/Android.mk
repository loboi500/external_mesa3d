# Copyright 2012 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

LOCAL_PATH := $(call my-dir)

# ----------------------------------------------------------------------
# libmesa_program.a
# ----------------------------------------------------------------------

# Import the following variables:
#     PROGRAM_FILES
include $(MESA_TOP)/src/mesa/Makefile.sources

include $(CLEAR_VARS)

LOCAL_MODULE := libmesa_program
LOCAL_LICENSE_KINDS := SPDX-license-identifier-MIT
LOCAL_LICENSE_CONDITIONS := notice
LOCAL_NOTICE_FILE := $(LOCAL_PATH)/../../../LICENSE
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_STATIC_LIBRARIES := libmesa_nir \
	libmesa_glsl

intermediates := $(call local-generated-sources-dir)

# TODO(chadv): In Makefile.sources, move these vars to a different list so we can
# remove this kludge.
generated_sources_basenames := \
	lex.yy.c \
	program_parse.tab.c \
	program_parse.tab.h

LOCAL_SRC_FILES := \
	$(filter-out $(generated_sources_basenames),$(subst program/,,$(PROGRAM_FILES))) \
	$(subst program/,,$(PROGRAM_NIR_FILES)) \
	program_lexer.l

LOCAL_GENERATED_SOURCES := \
	$(intermediates)/program/program_parse.tab.c \
	$(intermediates)/program/program_parse.tab.h

$(intermediates)/program/program_parse.tab.c: .KATI_IMPLICIT_OUTPUTS := $(intermediates)/program/program_parse.tab.h
$(intermediates)/program/program_parse.tab.c: PRIVATE_YACCFLAGS := -p "_mesa_program_"
$(intermediates)/program/program_parse.tab.c: $(LOCAL_PATH)/program_parse.y $(BISON) $(BISON_DATA) $(M4)
	$(transform-y-to-c-or-cpp)

LOCAL_C_INCLUDES := \
	$(MESA_TOP)/src/mapi \
	$(MESA_TOP)/src/mesa \
	$(MESA_TOP)/src/compiler/nir \
	$(MESA_TOP)/src/gallium/auxiliary \
	$(MESA_TOP)/src/gallium/include

LOCAL_EXPORT_C_INCLUDE_DIRS := $(intermediates)

LOCAL_GENERATED_SOURCES += $(MESA_GEN_NIR_H) \
	$(MESA_GEN_GLSL_H)

include $(MESA_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)
