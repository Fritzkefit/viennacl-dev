#ifndef VIENNACL_DEVICE_SPECIFIC_LAZY_PROGRAM_COMPILER_HPP
#define VIENNACL_DEVICE_SPECIFIC_LAZY_PROGRAM_COMPILER_HPP

/* =========================================================================
   Copyright (c) 2010-2013, Institute for Microelectronics,
                            Institute for Analysis and Scientific Computing,
                            TU Wien.
   Portions of this software are copyright by UChicago Argonne, LLC.

                            -----------------
                  ViennaCL - The Vienna Computing Library
                            -----------------

   Project Head:    Karl Rupp                   rupp@iue.tuwien.ac.at

   (A list of authors and contributors can be found in the PDF manual)

   License:         MIT (X11), see file LICENSE in the base directory
============================================================================= */


/** @file viennacl/generator/lazy_program_compiler.hpp
    @brief Helper for compiling a program lazily
*/

#include <map>

#include "viennacl/ocl/context.hpp"

namespace viennacl
{

  namespace device_specific
  {

    class lazy_program_compiler
    {
    public:

      lazy_program_compiler(viennacl::ocl::context * ctx, std::string const & name, std::string const & src) : ctx_(ctx), name_(name), src_(src), program_(NULL){ }
      lazy_program_compiler(viennacl::ocl::context * ctx, std::string const & name) : ctx_(ctx), name_(name), program_(NULL){ }

      void add(std::string const & src)
      {
        src_+=src;
      }

      std::string const & src() const { return src_; }

      viennacl::ocl::program & program()
      {
        if(program_==NULL)
        {
//          std::cout << src_ << std::endl;
          #ifdef VIENNACL_BUILD_INFO
          std::cerr << "Creating program " << program_name << std::endl;
          #endif
          program_ = &ctx_->add_program(src_, name_);
          #ifdef VIENNACL_BUILD_INFO
          std::cerr << "Done creating program " << program_name << std::endl;
          #endif
        }
        return ctx_->get_program(name_);
      }

    private:
      viennacl::ocl::context * ctx_;
      viennacl::ocl::program * program_;
      std::string name_;
      std::string src_;
    };

  }
}
#endif