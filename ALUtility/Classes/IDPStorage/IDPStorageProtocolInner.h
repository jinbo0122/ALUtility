//
//  IDPStorageProtocol.h
//  IDP
//
//  Created by douj on 17-3-12.
//
//  底层数据存储引擎协议

#import <Foundation/Foundation.h>

@protocol IDPStorageProtocolInner <NSObject>

//是否存在key
-(BOOL)existObjectForKey:(NSString*)key;

//同步读取key
-(NSData*)loadObjectForKey:(NSString*)key error:(NSError**)error;

//同步保存key
-(BOOL)saveObject:(NSData*)obj forKey:(NSString*)key error:(NSError**)error;

//同步移除key
-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error;

//清空整个命名空间
+(BOOL)cleanNameSpace:(NSString*)nameSpace error:(NSError **)error;

@end