
function(set_defaults)

  # TODO: _POSIX_PTHREAD_SEMANTICS etc.
  # Optimization options

  if(NOT CMAKE_CXX_FLAGS)
    add_flags(CXX -xdebuginfo=no%decl -xbuiltin=%all -xlibmil)

    if(NOT SPARC)
      add_flags(CXX -nofstore)
    endif()

  endif()

  # Build in thread-safe mode (this is not the default for SunPro)

  add_flags(CXX -mt)
  add_flags(C -mt)

  add_definitions(-D_POSIX_PTHREAD_SEMANTICS)
endfunction()


# -----------------------------------------------------------------


function(enable_cxx11)

  # Note: calling _enable_cxx11() did not work on Solaris
  #
  # With SunPro use GNU libstdc++ implementation of c++ std library. This
  # is the default for -std=c++11, but we set it explicitly to be on the safe
  # side.
  #
  add_flags(CXX -std=c++11 -library=stdcpp)

endfunction()


function(enable_pic)
  add_compile_options(CXX -KPIC)
endfunction()


function(set_visibility)
  add_compile_options(-xldscope=symbolic)
endfunction()

# -----------------------------------------------------------------

function(set_arch_m64)

  add_flags(CXX -m64)
  add_flags(C -m64)

  # Note: This is important for find_library() to find 64-bit variants

  set(CMAKE_LIBRARY_ARCHITECTURE 64 PARENT_SCOPE)

endfunction()

# -----------------------------------------------------------------

set_defaults()

return()

####################################################################

if(SUNPRO)

  set(options
    -m64
    -xatomic=studio
    -xtarget=generic     # more portable code
    -xdebuginfo=no%decl  # faster build times
    # optimization options
    -xbuiltin=%all
    -xlibmil
  )

  if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "sparc")
    list(APPEND options -nofstore)
  endif()

  string(REPLACE ";" " " options "${options}")

  set(CMAKE_CXX_FLAGS "${options} ${CMAKE_CXX_FLAGS}")

  #foreach(type EXE STATIC SHARED MODULE)
  #  set(CMAKE_${type}_LINKER_FLAGS "${options}")
  #endforeach()

  set(CMAKE_CXX_FLAGS_DEBUG "-g ${CMAKE_CXX_FLAGS_DEBUG}")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
    "-g -xO2 ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}"
  )
  set(CMAKE_CXX_FLAGS_RELEASE "-g0 -xO3 ${CMAKE_CXX_FLAGS_RELEASE}")
  set(CMAKE_CXX_FLAGS_MINSIZEREL
    "-g0 -xO3 -xsize ${CMAKE_CXX_FLAGS_MINSIZEREL}"
  )

  add_definitions(
    -D_POSIX_PTHREAD_SEMANTICS
    -D_REENTRANT
  )

endif()


if(0) #cdk_stand_alone)

  if(CMAKE_CXX_COMPILER_ID MATCHES "SunPro")

    set(options
      -m64
      -std=c++11
      -library=stdcpp
      -xatomic=studio
      -xtarget=generic     # more portable code
      -xdebuginfo=no%decl  # faster build times
      # optimization options
      -xbuiltin=%all
      -xlibmil
    )

    if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "sparc")
      list(APPEND options -nofstore)
    endif()

    string(REPLACE ";" " " options "${options}")

    set(CMAKE_CXX_FLAGS "${options} ${CMAKE_CXX_FLAGS}")

    #foreach(type EXE STATIC SHARED MODULE)
    #  set(CMAKE_${type}_LINKER_FLAGS
    #    "${options} ${CMAKE_${type}_LINKER_FLAGS}"
    #  )
    #endforeach()

    set(CMAKE_CXX_FLAGS_DEBUG "-g ${CMAKE_CXX_FLAGS_DEBUG}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
      "-g -xO2 ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}"
    )
    set(CMAKE_CXX_FLAGS_RELEASE "-g0 -xO3 ${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_CXX_FLAGS_MINSIZEREL
      "-g0 -xO3 -xsize ${CMAKE_CXX_FLAGS_MINSIZEREL}"
    )

    add_definitions(
      -D_POSIX_PTHREAD_SEMANTICS
      -D_REENTRANT
    )

  endif()

endif() #cdk_stand_alone)
