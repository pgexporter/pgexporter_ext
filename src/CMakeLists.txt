#
# Add files for pgexporter_ext
#
FILE(GLOB SOURCE_FILES "pgexporter_ext/*.c")
FILE(GLOB HEADER_FILES "include/*.h")

set(SOURCES ${SOURCE_FILES} ${HEADER_FILES})

#
# OS
#
if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")

  add_compile_options(-DHAVE_LINUX)
  add_compile_options(-D_POSIX_C_SOURCE=200809L)

  #
  # Include directories
  #
  include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${PostgreSQL_INCLUDE_DIRS}
  )

  #
  # Library directories
  #
  link_libraries(
    ${PostgreSQL_LIBRARIES}
  )

else()

  add_compile_options(-D_XOPEN_SOURCE=700)
  add_compile_options(-D_BSD_SOURCE)
  add_compile_options(-D_DEFAULT_SOURCE)
  add_compile_options(-D__BSD_VISIBLE)

  #
  # Include directories
  #
  include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${PostgreSQL_INCLUDE_DIRS}
  )

  #
  # Library directories
  #
  link_libraries(
    ${PostgreSQL_LIBRARIES}
  )
endif()

#
# Compile options
#
add_compile_options(-g)
add_compile_options(-Wall)
add_compile_options(-std=c17)
add_compile_options(-D__USE_ISOC11)
add_compile_options(-D_GNU_SOURCE)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-Wstrict-prototypes)
endif()

if (CMAKE_BUILD_TYPE MATCHES Debug)
  add_compile_options(-O0)
  add_compile_options(-DDEBUG)

  check_c_compiler_flag(-Wformat HAS_FORMAT)
  if (HAS_FORMAT)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wformat")
  endif()

  check_c_compiler_flag(-Wformat-security HAS_FORMAT_SECURITY)
  if (HAS_FORMAT_SECURITY)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wformat-security")
  endif()

  check_c_compiler_flag(-fno-omit-frame-pointer HAS_NO_OMIT_FRAME_POINTER)
  if (HAS_NO_OMIT_FRAME_POINTER)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer")
  endif()

  check_c_compiler_flag(-fstack-protector-strong HAS_STACK_PROTECTOR_STRONG)
  if (HAS_STACK_PROTECTOR_STRONG)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fstack-protector-strong")
  endif()

  check_c_compiler_flag(-rdynamic HAS_DYNAMIC)
  if (HAS_DYNAMIC)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -rdynamic")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -rdynamic")
  endif()
endif()

if (CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
  add_compile_options(-O2)
  add_compile_options(-DNDEBUG)

  check_c_compiler_flag(-Wformat HAS_FORMAT)
  if (HAS_FORMAT)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wformat")
  endif()

  check_c_compiler_flag(-Wformat-security HAS_FORMAT_SECURITY)
  if (HAS_FORMAT_SECURITY)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wformat-security")
  endif()

  check_c_compiler_flag(-fstack-protector-strong HAS_STACKPROTECTOR_STRONG)
  if (HAS_STACKPROTECTOR_STRONG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector-strong")
  else()
    check_c_compiler_flag(-fstack-protector HAS_STACKPROTECTOR)
    if (HAS_STACKPROTECTOR)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector")
    endif()
  endif()

  check_c_compiler_flag(-fPIC HAS_PIC)
  if (HAS_PIC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
  endif()

  check_c_compiler_flag(-fPIE HAS_PIE)
  if (HAS_PIE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIE")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pie")
  endif()

  check_c_compiler_flag(-Wl,-z,relro HAS_RELRO)
  if (HAS_RELRO)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,relro")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,relro")
  endif()

  check_c_compiler_flag(-Wl,-z,now HAS_NOW)
  if (HAS_RELRO)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,now")
    set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,now")
  endif()
endif (CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)

execute_process(COMMAND pg_config --libdir
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE LIB_DIR)

if (LIB_DIR)
  message(STATUS "Library directory: ${LIB_DIR}")
else (LIB_DIR)
  message(FATAL_ERROR "pg_config --libdir failed")
endif (LIB_DIR)

#
# Build pgexporter_ext
#
add_library(pgexporter_ext SHARED ${SOURCES})
set_target_properties(pgexporter_ext PROPERTIES LINKER_LANGUAGE C VERSION ${VERSION_STRING}
                                     SOVERSION ${VERSION_MAJOR} PREFIX "")
target_link_libraries(pgexporter_ext PUBLIC)

install(TARGETS pgexporter_ext DESTINATION ${LIB_DIR}/)
