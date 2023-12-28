#
# Add files for pgexporter_ext
#
FILE(GLOB SOURCE_FILES "pgexporter_ext/*.c")
FILE(GLOB HEADER_FILES "include/*.h")

set(SOURCES ${SOURCE_FILES} ${HEADER_FILES})

execute_process(COMMAND pg_config --includedir
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE EXT_INCLUDE_DIR)

if (EXT_INCLUDE_DIR)
  message(STATUS "Include directory: ${EXT_INCLUDE_DIR}")
else (EXT_INCLUDE_DIR)
  message(FATAL_ERROR "pg_config --includedir failed")
endif (EXT_INCLUDE_DIR)

execute_process(COMMAND pg_config --includedir-server
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE EXT_INCLUDE_SERVER_DIR)

if (EXT_INCLUDE_SERVER_DIR)
  message(STATUS "Include directory: ${EXT_INCLUDE_SERVER_DIR}")
else (EXT_INCLUDE_SERVER_DIR)
  message(FATAL_ERROR "pg_config --includedir-server failed")
endif (EXT_INCLUDE_SERVER_DIR)

execute_process(COMMAND pg_config --pkglibdir
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE EXT_INSTALL_DIR)

if (EXT_INSTALL_DIR)
  message(STATUS "Library directory: ${EXT_INSTALL_DIR}")
else (EXT_INSTALL_DIR)
  message(FATAL_ERROR "pg_config --pkglibdir failed")
endif (EXT_INSTALL_DIR)

execute_process(COMMAND pg_config --libdir
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE EXT_LIB_DIR)

if (EXT_LIB_DIR)
  message(STATUS "Library directory: ${EXT_LIB_DIR}")
else (EXT_LIB_DIR)
  message(FATAL_ERROR "pg_config --libdir failed")
endif (EXT_LIB_DIR)

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
    ${EXT_INCLUDE_DIR}
    ${EXT_INCLUDE_SERVER_DIR}
  )

  #
  # Library directories
  #
  link_libraries(
    ${EXT_LIB_DIR}/libpq.so
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
    ${EXT_INCLUDE_DIR}
    ${EXT_INCLUDE_SERVER_DIR}
  )

  #
  # Library directories
  #
  link_libraries(
    ${EXT_LIB_DIR}/libpq.so
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

  check_c_compiler_flag(-fno-omit-frame-pointer HAS_NO_OMIT_FRAME_POINTER)
  if (HAS_NO_OMIT_FRAME_POINTER)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer")
  endif()
endif()

if (CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
  add_compile_options(-O2)
  add_compile_options(-DNDEBUG)
endif (CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)

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

check_c_compiler_flag(-rdynamic HAS_DYNAMIC)
if (HAS_DYNAMIC)
  set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -rdynamic")
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -rdynamic")
endif()

check_c_compiler_flag(-fPIC HAS_PIC)
if (HAS_PIC)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
endif()

check_c_compiler_flag(-Wl,-z,relro HAS_RELRO)
if (HAS_RELRO)
  set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,relro")
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,relro")
endif()

check_c_compiler_flag(-Wl,-z,now HAS_NOW)
if (HAS_NOW)
  set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,now")
  set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-z,now")
endif()

#
# Build pgexporter_ext
#
add_library(pgexporter_ext SHARED ${SOURCES})
set_target_properties(pgexporter_ext PROPERTIES LINKER_LANGUAGE C VERSION ${VERSION_STRING}
                                     SOVERSION ${VERSION_MAJOR} PREFIX "")
target_link_libraries(pgexporter_ext PUBLIC)

install(TARGETS pgexporter_ext DESTINATION ${EXT_INSTALL_DIR}/)
