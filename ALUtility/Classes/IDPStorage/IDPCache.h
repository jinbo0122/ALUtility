//
//  IDPCache.h
//  IDP
//
//  Created by douj on 13-3-13.
//
//

#import <Foundation/Foundation.h>
#import "IDPStorageConst.h"
@interface IDPCache : NSObject
{
    NSUInteger _queryCount;
    NSUInteger _memeryHitCount;
    NSUInteger _diskHitCount;
}

//当前cache所在命名空间
@property (nonatomic,readonly) NSString* nameSpace;

//缓存持久化策略
@property (nonatomic,readonly) IDPCacheStoragePolicy cacheStoragePolicy;

//内存缓存容量
@property (nonatomic,assign) NSUInteger  memoryCapacity;


@property (nonatomic,assign) NSUInteger  memoryTotalCost;

//内存缓存默认过期时间 单位秒
//@property (nonatomic,assign) NSTimeInterval  memoryDefaultTimeoutInterval;

//磁盘缓存大小
//@property (nonatomic,assign) NSUInteger  diskCacheSize;

//磁盘缓存过期时间 单位分钟
@property (nonatomic,assign) NSUInteger  diskExpiredTime;


+(IDPCache*) sharedCache;
//初始化方法
-(id)initWithNameSpace:(NSString*)nameSpace storagePolicy:(IDPCacheStoragePolicy)policy;

//是否存在缓存 会判断磁盘和内存
-(BOOL)existCacheForKey:(NSString*)key;

+(void)clearMemory;

//内存中是否有缓存
-(BOOL)existCacheForKeyInMemory:(NSString *)key;

//磁盘中是否有缓存
-(BOOL)existCacheForKeyOnDisk:(NSString *)key;

//缓存一个obj
-(void)setObj:(id)data forKey:(NSString *)aKey;

////缓存一个obj
//-(void)setObj:(id)data forKey:(NSString *)aKey cost:(NSInteger)cost;

//缓存一个obj with block
-(void)setObj:(id)data forKey:(NSString *)aKey completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

 //从缓存获取一个obj
-(id)objectForKey:(NSString*)key;

//只从内存缓存获取一个obj
-(id)objectForKeyOnlyInMemory:(NSString*)key;


//异步获取一个obj
-(void)objectForKey:(NSString *)key  completionHandle:(void(^)(BOOL success,id obj))completionHandler;

//移一个obj
-(void)removeObjcetForKey:(NSString*)key;

//内存缓存移去
-(void)removeObjcetForKeyOnlyInMemory:(NSString*)key;

//清除所有（内存和磁盘）
-(void)removeAll;

//清除所有（内存）
-(void)removeAllInMemory;

//清除所有（内存和磁盘）
-(void)removeAllInDisk;

//清除整个缓存（文件）
+(void)removeAll;

//清除某个namespace的缓存（文件）
+(void)removeNameSpace:(NSString*)nameSpace;

-(CGFloat)hitRate;

@end
