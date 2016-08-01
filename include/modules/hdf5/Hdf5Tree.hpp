// Hdf5Tree.hpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#include "../common/namespace.hpp"
#include <stdlib.h>

#include <string>
#include <string.h>
#include "hdf5.h"
#include <boost/property_tree/ptree.hpp>

#ifndef TREE_HPP
#define TREE_HPP

using namespace std;
using namespace boost::property_tree;

NS_RADIGAN_BEGIN

  class Tree {
    private:
    protected:
      static const int stringBufferSize;
      ptree tree;
      void initialize();
      void scanGroup(hid_t gid, std::string path);
      void extractDataset(hid_t did, std::string path);
    public:
      Tree(); 
      ~Tree(); 
      bool load(std::string filename);
      template<class T> inline T get(std::string path) { return static_cast<T>(tree.get<void*>(path)); };
  };
  
NS_RADIGAN_END

#endif
