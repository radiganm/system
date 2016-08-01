// Hdf5Tree.cpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#include "modules/hdf5/Hdf5Tree.hpp"

#include <iostream>
#include <fstream>
#include <stdexcept>
#include <boost/algorithm/string.hpp>
#include "hdf5_hl.h"
#include "TMatrixD.h"

USING_RADIGAN
using namespace std;
using namespace boost;

  const int Tree::stringBufferSize = 50;
  
  Tree::Tree() {
  }
  
  Tree::~Tree() { 
  }
  
  void Tree::initialize() { }
  void Tree::scanGroup(hid_t gid, std::string path) { 
    hid_t grpid;
    hid_t dsid;
    hsize_t nobj;
    int otype;
    char groupName[stringBufferSize];
    char memberName[stringBufferSize];
    H5Iget_name(gid, groupName, stringBufferSize);
    string dotName = string(groupName+1);
    replace_all(dotName,"/",".");
    cout << "Dot Name: " << dotName << endl;
    //scanAttributes(gid);
    H5Gget_num_objs(gid, &nobj);
    for(int idx=0; idx<static_cast<ssize_t>(nobj); idx++) {
      H5Gget_objname_by_idx(gid, (hsize_t)idx, memberName, (size_t)stringBufferSize);
      otype = H5Gget_objtype_by_idx(gid, (size_t)idx);
      switch(otype) {
        case H5G_LINK:
          //cout << "H5 link" << endl;
          break;
        case H5G_GROUP:
          //cout << "H5 group" << endl;
          grpid = H5Gopen(gid, memberName, H5P_DEFAULT);
          scanGroup(grpid, path);
          H5Gclose(grpid);
          break;
        case H5G_DATASET:
          //cout << "H5 dataset" << endl;
          dsid = H5Dopen(gid, memberName, H5P_DEFAULT);
          extractDataset(dsid, path);
          H5Dclose(dsid);
          break;
        case H5G_TYPE:
          //cout << "H5 type" << endl;
          break;
        default:
          //cout << "H5 unknown type" << endl;
          break;
      }
    }
  }
  
  void Tree::extractDataset(hid_t did, std::string path) { 
    hid_t sid;
    hid_t tid;
    hsize_t dims[2];
    H5T_class_t tclass;
    tid = H5Dget_type(did);
    tclass = H5Tget_class(tid);
    char datasetName[stringBufferSize];
    H5Iget_name(did, datasetName, stringBufferSize);
    if(tclass>0) {
      switch(tclass) {
        case H5T_INTEGER:
          //cout << "H5T_INTEGER" << endl;
          return;
          break;
        case H5T_FLOAT:
          //cout << "H5T_FLOAT" << endl;
          break;
        case H5T_STRING:
          //cout << "H5T_STRING" << endl;
          return;
          break;
        case H5T_BITFIELD:
          //cout << "H5T_BITFIELD" << endl;
          return;
          break;
        case H5T_OPAQUE:
          //cout << "H5T_OPAQUE" << endl;
          return;
          break;
        case H5T_ARRAY:
          //cout << "H5T_ARRAY" << endl;
          return;
          break;
        case H5T_ENUM:
          //cout << "H5T_ENUM" << endl;
          return;
          break;
        default:
          //cout << "H5T_OTHER" << endl;
          return;
          break;
      }
    } else {
      //cout << "Unknown data type" << endl;
      return;
    }
    H5Tclose(tid);
    sid = H5Dget_space(did);
    H5Sget_simple_extent_dims(sid, dims, NULL);
    double *dvalue = (double*)calloc(dims[0]*dims[1], sizeof(double));
    H5Dread(did, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, dvalue);
    TMatrixD *mat = new TMatrixD(dims[0], dims[1]);
    mat->Use(dims[0], dims[1], dvalue);
    string dotName = string(datasetName+1);
    replace_all(dotName, "/", ".");
    tree.put(dotName, mat);
    mat->Print();
  }
  
  bool Tree::load(std::string filename) {
    //H5T_class_t typeClass;
    //size_t typeSize;
    //hsize_t dims[3];
    hid_t fid;
    hid_t gid;
    string root = "/";
    fid = H5Fopen(filename.c_str(), H5F_ACC_RDWR, H5P_DEFAULT);
    gid = H5Gopen(fid, root.c_str(), H5P_DEFAULT);
    scanGroup(gid, root);
    herr_t status = H5Fclose(fid);
    return status ? false : true;
  }
  
// *EOF*
