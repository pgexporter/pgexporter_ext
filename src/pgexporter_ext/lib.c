/*
 * Copyright (C) 2021 Red Hat
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 * list of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 * 
 * 3. Neither the name of the copyright holder nor the names of its contributors may
 * be used to endorse or promote products derived from this software without specific
 * prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/* pgexporter */
#include <pgexporter_ext.h>
#include <utils.h>

/* system */
#include <stdlib.h>

/* PostgreSQL */
#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(pgexporter_used_space);
PG_FUNCTION_INFO_V1(pgexporter_free_space);
PG_FUNCTION_INFO_V1(pgexporter_total_space);

Datum
pgexporter_used_space(PG_FUNCTION_ARGS)
{
   unsigned long size;
   char* directory = text_to_cstring(PG_GETARG_TEXT_PP(0));

   size = pgexporter_ext_directory_size(directory);

   PG_RETURN_INT64(size);
}

Datum
pgexporter_free_space(PG_FUNCTION_ARGS)
{
   unsigned long size;
   char* directory = text_to_cstring(PG_GETARG_TEXT_PP(0));

   size = pgexporter_ext_free_space(directory);

   PG_RETURN_INT64(size);
}

Datum
pgexporter_total_space(PG_FUNCTION_ARGS)
{
   unsigned long size;
   char* directory = text_to_cstring(PG_GETARG_TEXT_PP(0));

   size = pgexporter_ext_total_space(directory);

   PG_RETURN_INT64(size);
}
