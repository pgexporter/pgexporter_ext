/*
 * Copyright (C) 2025 The pgexporter community
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

/* postgresql */
#include "postgres.h"
#include "utils/guc.h"

/* system */
#include <dirent.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/types.h>
#include <zlib.h>
#include <bzlib.h>
#include <lz4frame.h>
#include <zstd.h>

static char* pgexporter_ext_append(char* orig, char* s);
static int pgexporter_ext_process_log_file(const char* file_path, const char* level);
static int pgexporter_ext_process_gz_log_file(const char* file_path, const char* level);
static int pgexporter_ext_process_bz2_log_file(const char* file_path, const char* level);
static int pgexporter_ext_process_lz4_log_file(const char* file_path, const char* level);
static int pgexporter_ext_process_zstd_log_file(const char* file_path, const char* level);

unsigned long
pgexporter_get_directory_size(char* directory)
{
   unsigned long total_size = 0;
   DIR* dir;
   struct dirent* entry;
   char* p;
   struct stat st;
   unsigned long l;

   if (!(dir = opendir(directory)))
   {
      return total_size;
   }

   while ((entry = readdir(dir)) != NULL)
   {
      if (entry->d_type == DT_DIR)
      {
         char path[1024];

         if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
         {
            continue;
         }

         snprintf(path, sizeof(path), "%s/%s", directory, entry->d_name);

         total_size += pgexporter_get_directory_size(path);
      }
      else if (entry->d_type == DT_REG)
      {
         p = NULL;

         p = pgexporter_ext_append(p, directory);
         p = pgexporter_ext_append(p, "/");
         p = pgexporter_ext_append(p, entry->d_name);

         memset(&st, 0, sizeof(struct stat));

         stat(p, &st);

         l = st.st_size / st.st_blksize;

         if (st.st_size % st.st_blksize != 0)
         {
            l += 1;
         }

         total_size += (l * st.st_blksize);

         free(p);
      }
      else if (entry->d_type == DT_LNK)
      {
         p = NULL;

         p = pgexporter_ext_append(p, directory);
         p = pgexporter_ext_append(p, "/");
         p = pgexporter_ext_append(p, entry->d_name);

         memset(&st, 0, sizeof(struct stat));

         stat(p, &st);

         total_size += st.st_blksize;

         free(p);
      }
   }

   closedir(dir);

   return total_size;
}

unsigned long
pgexporter_get_free_space(char* path)
{
   struct statvfs buf;

   if (statvfs(path, &buf))
   {
      errno = 0;
      return 0;
   }

   return buf.f_bsize * buf.f_bavail;
}

unsigned long
pgexporter_get_total_space(char* path)
{
   struct statvfs buf;

   if (statvfs(path, &buf))
   {
      errno = 0;
      return 0;
   }

   return buf.f_frsize * buf.f_blocks;
}

char*
pgexporter_ext_clean_string(char* orig)
{
   size_t length;
   size_t from = 0;
   size_t to = 0;
   char c = 0;
   char* result = NULL;

   if (orig == NULL || strlen(orig) == 0)
   {
      return orig;
   }

   length = strlen(orig);

   for (int i = 0; i < length; i++)
   {
      c = *(orig + i);
      if (c == ' ' || c == '\'' || c == '\"' || c == '\t' || c == '\r' || c == '\n')
      {
         from++;
      }
      else
      {
         break;
      }
   }

   to = length;
   for (int i = length; i > 0; i--)
   {
      c = *(orig + i);
      if (c == ' ' || c == '\'' || c == '\"' || c == '\t' || c == '\r' || c == '\n')
      {
         /* Skip */
      }
      else
      {
         to = i;
         break;
      }
   }

   result = (char*)malloc(to - from + 1);
   memset(result, 0, to - from + 1);
   memcpy(result, orig + from, to - from);

   return result;
}

static char*
pgexporter_ext_append(char* orig, char* s)
{
   size_t orig_length;
   size_t s_length;
   char* n = NULL;

   if (s == NULL)
   {
      return orig;
   }

   if (orig != NULL)
   {
      orig_length = strlen(orig);
   }
   else
   {
      orig_length = 0;
   }

   s_length = strlen(s);

   n = (char*)realloc(orig, orig_length + s_length + 1);

   memcpy(n + orig_length, s, s_length);

   n[orig_length + s_length] = '\0';

   return n;
}

bool
pgexporter_ext_ends_with(char* str, char* suffix)
{
   int str_len = strlen(str);
   int suffix_len = strlen(suffix);

   return (str_len >= suffix_len) && (strcmp(str + (str_len - suffix_len), suffix) == 0);
}

int
pgexporter_ext_parse_log_files(const char* level)
{
   struct dirent* entry;
   int total_count = 0;
   char file_path[MAXPGPATH];
   struct stat path_stat;

   const char* log_directory = GetConfigOptionByName("log_directory", NULL, false);
   if (!log_directory)
   {
      elog(ERROR, "Failed to retrieve log directory from configuration");
      return 0;
   }
   DIR* dp = opendir(log_directory);
   if (!dp)
   {
      elog(ERROR, "Failed to open log directory: %s", log_directory);
      return 0;
   }
   
   while ((entry = readdir(dp)) != NULL)
   {
      if (entry->d_name[0] == '.')
      {
         continue;
      }

      snprintf(file_path, sizeof(file_path), "%s/%s", log_directory, entry->d_name);

      stat(file_path, &path_stat);
      if (S_ISREG(path_stat.st_mode))
      {
         if (pgexporter_ext_ends_with(entry->d_name, ".gz"))
         {
            total_count += pgexporter_ext_process_gz_log_file(file_path, level);
         }
         else if (pgexporter_ext_ends_with(entry->d_name, ".bz2"))
         {
            total_count += pgexporter_ext_process_bz2_log_file(file_path, level);
         }
         else if (pgexporter_ext_ends_with(entry->d_name, ".lz4"))
         {
            total_count += pgexporter_ext_process_lz4_log_file(file_path, level);
         }
         else if (pgexporter_ext_ends_with(entry->d_name, ".zst"))
         {
            total_count += pgexporter_ext_process_zstd_log_file(file_path, level);
         }
         else
         {
            total_count += pgexporter_ext_process_log_file(file_path, level);
         }
      }
   }

   closedir(dp);
   return total_count;
}

static int
pgexporter_ext_process_log_file(const char* file_path, const char* level)
{
   FILE* log_file;
   char line[MAXPGPATH];
   char lower_line[MAXPGPATH];
   int count = 0;

   log_file = fopen(file_path, "r");
   if (!log_file)
   {
      elog(ERROR, "Failed to open log file: %s", file_path);
      return 0;
   }

   while (fgets(line, sizeof(line), log_file))
   {
      strncpy(lower_line, line, sizeof(lower_line) - 1);
      lower_line[sizeof(lower_line) - 1] = '\0';

      if (strstr(lower_line, level) != NULL)
      {
         count++;
      }
   }

   fclose(log_file);
   return count;
}

static int
pgexporter_ext_process_gz_log_file(const char* file_path, const char* level)
{
   gzFile gz_log_file;
   char line[MAXPGPATH];
   char lower_line[MAXPGPATH];
   int count = 0;

   gz_log_file = gzopen(file_path, "r");
   if (!gz_log_file)
   {
      elog(ERROR, "Failed to open compressed log file: %s", file_path);
      return 0;
   }

   while (gzgets(gz_log_file, line, sizeof(line)))
   {
      strncpy(lower_line, line, sizeof(lower_line) - 1);
      lower_line[sizeof(lower_line) - 1] = '\0';

      if (strstr(lower_line, level) != NULL)
      {
         count++;
      }
   }

   gzclose(gz_log_file);
   return count;
}

static int
pgexporter_ext_process_bz2_log_file(const char* file_path, const char* level)
{
   FILE* file;
   BZFILE* bz_log_file;
   char line[MAXPGPATH];
   char lower_line[MAXPGPATH];
   int count = 0;
   int bzerror;

      file = fopen(file_path, "rb");
   if (!file)
   {
      elog(ERROR, "Failed to open compressed log file: %s", file_path);
      return 0;
   }

   bz_log_file = BZ2_bzReadOpen(NULL, file, 0, 0, NULL, 0);
   if (!bz_log_file)
   {
      elog(ERROR, "Failed to open bz2 compressed file: %s", file_path);
      fclose(file);
      return 0;
   }

   while (BZ2_bzRead(&bzerror, bz_log_file, line, sizeof(line) - 1) > 0)
   {
      line[sizeof(line) - 1] = '\0';
      strncpy(lower_line, line, sizeof(lower_line) - 1);
      lower_line[sizeof(lower_line) - 1] = '\0';

      if (strstr(lower_line, level) != NULL)
      {
         count++;
      }
   }

   BZ2_bzReadClose(&bzerror, bz_log_file);
   fclose(file);
   return count;
}

static int
pgexporter_ext_process_lz4_log_file(const char* file_path, const char* level)
{
   FILE* file;
   LZ4F_dctx* dctx;
   char in_buffer[MAXPGPATH];
   char out_buffer[MAXPGPATH];
   char lower_line[MAXPGPATH];
   size_t in_size, out_size;
   int count = 0;

   file = fopen(file_path, "rb");
   if (!file)
   {
      elog(ERROR, "Failed to open compressed log file: %s", file_path);
      return 0;
   }

   if (LZ4F_createDecompressionContext(&dctx, LZ4F_VERSION) != 0)
   {
      elog(ERROR, "Failed to create LZ4 decompression context");
      fclose(file);
      return 0;
   }

   while ((in_size = fread(in_buffer, 1, sizeof(in_buffer), file)) > 0)
   {
      out_size = sizeof(out_buffer);
      LZ4F_decompress(dctx, out_buffer, &out_size, in_buffer, &in_size, NULL);

      out_buffer[out_size] = '\0';
      strncpy(lower_line, out_buffer, sizeof(lower_line) - 1);
      lower_line[sizeof(lower_line) - 1] = '\0';

      if (strstr(lower_line, level) != NULL)
      {
         count++;
      }
   }

   LZ4F_freeDecompressionContext(dctx);
   fclose(file);
   return count;
}

static int
pgexporter_ext_process_zstd_log_file(const char* file_path, const char* level)
{
   FILE* file;
   ZSTD_DCtx* dctx;
   char in_buffer[MAXPGPATH];
   char out_buffer[MAXPGPATH];
   char lower_line[MAXPGPATH];
   size_t in_size, out_size;
   int count = 0;

   file = fopen(file_path, "rb");
   if (!file)
   {
      elog(ERROR, "Failed to open compressed log file: %s", file_path);
      return 0;
   }

   dctx = ZSTD_createDCtx();
   if (!dctx)
   {
      elog(ERROR, "Failed to create ZSTD decompression context");
      fclose(file);
      return 0;
   }

   while ((in_size = fread(in_buffer, 1, sizeof(in_buffer), file)) > 0)
   {
      out_size = ZSTD_decompressDCtx(dctx, out_buffer, sizeof(out_buffer), in_buffer, in_size);

      if (ZSTD_isError(out_size))
      {
         elog(ERROR, "ZSTD decompression error: %s", ZSTD_getErrorName(out_size));
         break;
      }

      out_buffer[out_size] = '\0';
      strncpy(lower_line, out_buffer, sizeof(lower_line) - 1);
      lower_line[sizeof(lower_line) - 1] = '\0';

      if (strstr(lower_line, level) != NULL)
      {
         count++;
      }
   }

   ZSTD_freeDCtx(dctx);
   fclose(file);
   return count;
}
