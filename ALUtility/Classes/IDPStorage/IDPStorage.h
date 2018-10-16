//
//  IDPStorageEngine.h
//  IDP
//
//  Created by douj on 13-3-12.
//
//  IDP存储对外接口

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IDPStorageConst.h"


@interface IDPStorage : NSObject

@property (nonatomic,readonly) NSString* nameSpace;

//初始化存储引擎 namespace是存储路径 type是类型
-(id)initWithNameSpace:(NSString*)nameSpace type:(IDPStorageType)type;

//是否有对应的key
-(BOOL)isObjectForKeyExist:(NSString*)key;

//同步获取一个data
-(NSData*)dataForKey:(NSString*)key error:(NSError**)error;

//存储一个data
-(BOOL)setData:(NSData*)obj forKey:(NSString*)key error:(NSError**)error;

//移除一个key
-(BOOL)removeDataForKey:(NSString*)key error:(NSError **)error;

//异步获取一个data
-(void)dataForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler;

//异步存储一个data
-(void)setData:(NSData*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

//异步移除一个data
-(void)removeObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

//同步获取一个object（IDPStorage Extension中的类型）
-(id)objectForKey:(NSString *)key error:(NSError **)error;

//异步
-(void)objectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler;

//清空整个命名空间
+(BOOL)cleanNameSpace:(NSString*)nameSpace type:(IDPStorageType)type error:(NSError **)error;

//异步清除一个命名空间
+(void)cleanNameSpace:(NSString*)nameSpace type:(IDPStorageType)type completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

//删除过期文件
+(void)cleanExpiredFiles:(NSString*)nameSpace type:(IDPStorageType)type expire:(NSNumber *)expireNumber;


@end


//data类型的扩展
@interface IDPStorage (NSDataExtension)

-(NSData*)loadDataForKey:(NSString*)key error:(NSError**)error;
-(void)loadDataForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSData* obj))completionHandler;
-(BOOL)saveData:(NSData*)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveData:(NSData*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end

//array类型的扩展
@interface IDPStorage (NSArrayExtension)

-(NSArray*)parseArrayObject:(NSData*)data;
-(NSArray*)loadArrayForKey:(NSString*)key error:(NSError**)error;
-(void)loadArrayForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSArray* obj))completionHandler;
-(BOOL)saveArray:(NSArray*)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveArray:(NSArray*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end

//dict类型的扩展
@interface IDPStorage (NSDictionaryExtension)

-(NSDictionary*)parseDictionaryObject:(NSData*)data;
-(NSDictionary*)loadDictionaryForKey:(NSString*)key error:(NSError**)error;
-(void)loadDictionaryForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSDictionary* obj))completionHandler;
-(BOOL)saveDictionary:(NSDictionary*)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveDictionary:(NSDictionary*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end


//string类型的扩展
@interface IDPStorage (NSStringExtension)

-(NSString*)parseStringObject:(NSData*)data;
-(NSString*)loadStringForKey:(NSString*)key error:(NSError**)error;
-(void)loadStringForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSString* obj))completionHandler;
-(BOOL)saveString:(NSString*)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveString:(NSString*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end

//image类型的扩展
@interface IDPStorage (UIImageExtension)

-(UIImage*)parseImageObject:(NSData*)data;
-(UIImage*)loadImageForKey:(NSString*)key error:(NSError**)error;
-(void)loadImageForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,UIImage* obj))completionHandler;
-(BOOL)saveImage:(UIImage*)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveImage:(UIImage*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end

//支持coding协议类型的扩展
@interface IDPStorage (NSCodingExtension)

-(id)parseCodingObject:(NSData*)data;
-(id)loadCodingObject:(NSString*)key error:(NSError**)error;
-(void)loadCodingForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler;
-(BOOL)saveCodingObject:(id)obj forKey:(NSString*)key error:(NSError**)error;
-(void)saveCodingObject:(id)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

@end
