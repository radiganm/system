// namespace.hpp
// Copyright 2016 Mac Radigan
// All Rights Reserved

#ifndef namespace_hpp
#define namespace_hpp

// control whether or not we use a library namespace
#define RADIGAN_CREATE_NAMESPACE
#ifdef RADIGAN_CREATE_NAMESPACE
#define NS_RADIGAN_BEGIN namespace radigan {
#define NS_RADIGAN_END   }
#define NS_RADIGAN radigan;
#define USING_RADIGAN using namespace radigan;
#else
#define NS_RADIGAN_BEGIN ;
#define NS_RADIGAN_END ;
#define NS_RADIGAN ;
#define USING_RADIGAN ;
#endif

#endif

// *EOF*
