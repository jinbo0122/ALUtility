//
//  IDPStorageConst.h
//  IDP
//
//  Created by douj on 17-3-12.
//
//  常量定义

#ifndef IDP_IDPStorageConst_h
#define IDP_IDPStorageConst_h

//存储引擎
typedef enum  {
    IDPStorageDisk,                 //磁盘
    IDPStorageSql,                  //sqlite
}IDPStorageType;

//缓存策略
typedef enum  {
    IDPCacheStorageMemory,          //内存缓存
    IDPCacheStorageDisk,            //磁盘缓存
    IDPCacheStorageMemoryAndDisk    //内存和磁盘缓存
}IDPCacheStoragePolicy;

#endif
