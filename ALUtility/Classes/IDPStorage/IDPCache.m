//
//  IDPCache.m
//  IDP
//
//  Created by douj on 13-3-13.
//
//

#import <UIKit/UIKit.h>

#import "IDPCache.h"
#import "IDPStorage.h"
#import "IDPStorageMemoryInner.h"
#import "IDPConfig.h"
#import "../Categories/NSDictionary+ALExtension.h"

//存储现有缓存namespace的key
#define kIdpAllCacheNameSpace                                   @"idp_all_cache_namespace"

//存储单个缓存config的key
#define kIdpCacheConfigKey                                      @"idp_cache_config"

//存储缓存策略
#define kIdpCacheConfigPolicy                                   @"idp_cache_policy"

//存储缓存的建立时间
//#define kIdpCacheConfigCreateTime                               @"idp_cache_config_createtime"

//存储缓存的内存缓存容量
#define kIdpCacheConfigMemoryCapacity                           @"idp_cache_config_memorycapacity"

//存储缓存内存缓存超时时间
//#define kIdpCacheConfigMemoryDefaultTimeoutInterval             @"idp_cache_config_memorytimeoutInterval"

//存储缓存磁盘缓存大小
//#define kIdpCacheConfigDiskCacheSize                            @"idp_cache_config_diskcaachesize"

//存储缓存磁盘缓存过期时间
#define kIdpCacheConfigDiskExpiredTime                          @"idp_cache_config_diskExpiredTime"


@interface IDPCache()

//文件存储引擎
@property (nonatomic,retain) IDPStorage* fileStorageEngine;
//内存缓存引擎
@property (nonatomic,retain) IDPStorageMemoryInner* memoryCache;
//配置模块
@property (nonatomic,retain) IDPConfig* config;
//配置项dict
@property (nonatomic,retain) NSMutableDictionary*  configDict;

@end

@implementation IDPCache

static IDPCache* g_sharedCache = nil;

+(IDPCache*) sharedCache
{
    @synchronized(self)
    {
        if (g_sharedCache == nil) {
            g_sharedCache = [[self alloc] initWithNameSpace:@"default_cache" storagePolicy:IDPCacheStorageMemoryAndDisk];
        }
    }
    return g_sharedCache;
}

+(void)initialize
{
//    NSLog(@"initialize");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification
                                            object:nil];
//     NSLog(@"initialize end");
}

+(void)clearMemory
{
//    NSLog(@"DidReceiveMemoryWarning begin");
    [IDPStorageMemoryInner cleanAllMemory];
//    NSLog(@"DidReceiveMemoryWarning end");
}
+(void)cleanBackground
{
//    NSLog(@"DidEnterBackground begin");
    [IDPCache clearMemory];
    //[IDPCache cleanFileCache];
//    NSLog(@"DidEnterBackground end");
}
+(void)cleanFileCache
{
//    NSLog(@"cleanFileCache");
    //先获取现有的所有缓存的namespace
    IDPConfig* config = [[IDPConfig alloc] initWithNameSpace:kIdpAllCacheNameSpace];
    NSArray* array = [config arrayForKey:kIdpAllCacheNameSpace];
    //finnalArr用来存储更新后的所有缓存的namesapce
    NSMutableArray* finnalArr = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSString* nameSpace in array) {
        @autoreleasepool {
            IDPConfig* configInner = [[IDPConfig alloc] initWithNameSpace:nameSpace];
            NSDictionary* configDict = [configInner dictionaryForKey:kIdpCacheConfigKey];
            if (!configDict) {
                continue;
            }
            NSNumber* expiredNumber = [configDict numberAtPath:kIdpCacheConfigDiskExpiredTime];
            [IDPStorage cleanExpiredFiles:nameSpace type:IDPStorageDisk expire:expiredNumber];
            {
                [finnalArr addObject:nameSpace];
            }

        }
    }
    //更新配置
    [config setObject:finnalArr forKey:kIdpAllCacheNameSpace];
//    NSLog(@"cleanFileCache end");
}
//清除整个缓存
+(void)removeAll
{
//    NSLog(@"removeAll");
    //防止进入后台清理磁盘
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    IDPConfig* config = [[IDPConfig alloc] initWithNameSpace:kIdpAllCacheNameSpace];
    NSArray* array = [config arrayForKey:kIdpAllCacheNameSpace];
    //finnalArr用来存储更新后的所有缓存的namesapce
    NSMutableArray* finnalArr = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSString* nameSpace in array)
    {
         NSError* error = nil;
        [IDPStorage cleanNameSpace:nameSpace type:IDPStorageDisk error:&error];
    }
    [config setObject:finnalArr forKey:kIdpAllCacheNameSpace];
    //将通知加回来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//     NSLog(@"removeAll end");
}

//清除某个namespace的缓存
+(void)removeNameSpace:(NSString*)nameSpace
{
//    NSLog(@"removeNameSpace");
  
    IDPConfig* config = [[IDPConfig alloc] initWithNameSpace:kIdpAllCacheNameSpace];
    NSArray* array = [config arrayForKey:kIdpAllCacheNameSpace];
    //finnalArr用来存储更新后的所有缓存的namesapce
    NSMutableArray* finnalArr = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSString* nameSpaceInner in array)
    {
        if ([nameSpaceInner isEqualToString:nameSpace]) {
            NSError* error = nil;
            [IDPStorage cleanNameSpace:nameSpaceInner type:IDPStorageDisk error:&error];
        }
        else
        {
            [finnalArr addObject:nameSpace];
        }
    }
    [config setObject:finnalArr forKey:kIdpAllCacheNameSpace];
//    NSLog(@"removeNameSpace end");
}
//将namesapece加入总namespace
+(void)addNameSpaceToAllCache:(NSString*)nameSpace
{
//    NSLog(@"addNameSpaceToAllCache");
  
    IDPConfig* config = [[IDPConfig alloc] initWithNameSpace:kIdpAllCacheNameSpace];

    NSArray* array = [config arrayForKey:kIdpAllCacheNameSpace];
    if (!array) {
        array = [[NSArray alloc] init];
    }
    //是否存在 不存在就加入
    BOOL bHasThisNameSpace = NO;
    for (NSString* item in array) {
        if ([item isEqualToString:nameSpace]) {
            bHasThisNameSpace = YES;
            break;
        }
    }
    if (!bHasThisNameSpace) {
        NSMutableArray* setArray = [[NSMutableArray alloc] initWithArray:array];
        [setArray addObject:nameSpace];
        [config setObject:setArray forKey:kIdpAllCacheNameSpace];
        
    }
//    NSLog(@"addNameSpaceToAllCache");

}
-(id)initWithNameSpace:(NSString*)nameSpace storagePolicy:(IDPCacheStoragePolicy)policy;
{
//    NSLog(@"initWithNameSpace");
    self = [super init];
    if (self) {
        self.fileStorageEngine = [[IDPStorage alloc] initWithNameSpace:nameSpace type:IDPStorageDisk];
        self.memoryCache = [[IDPStorageMemoryInner alloc] initWithNameSpace:nameSpace];
        self.config = [[IDPConfig alloc] initWithNameSpace:nameSpace];
        _cacheStoragePolicy = policy;
        self.configDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        _nameSpace = [nameSpace copy];
        [IDPCache addNameSpaceToAllCache:nameSpace];
        NSDictionary* configDictory = [self.config dictionaryForKey:kIdpCacheConfigKey];
        //只是内存缓存存储配置
        if (configDictory && policy != IDPCacheStorageMemory) {
            NSNumber* memoryCapacity = [configDictory numberAtPath:kIdpCacheConfigMemoryCapacity otherwise:[NSNumber numberWithUnsignedInteger:1000]];
            self.memoryCapacity = memoryCapacity.unsignedIntegerValue;
            
            NSNumber* diskExpiredTime = [configDictory numberAtPath:kIdpCacheConfigDiskExpiredTime otherwise:[NSNumber numberWithUnsignedInteger:3*24*60*60]];
            self.diskExpiredTime = diskExpiredTime.unsignedIntegerValue;

        }
        else
        {
            //10分钟
//            self.memoryDefaultTimeoutInterval =2 * 60;
            //20MB
//            self.diskCacheSize = 20 * 1024 * 1024;
            //一周
            self.diskExpiredTime = 3*24*60*60;
//            [self innerSaveCreateTime];
            [self innerSavePolicy:policy];
            [self.config setObject:self.configDict forKey:kIdpCacheConfigKey];
        }
     
    }
//    NSLog(@"initWithNameSpace end");
    return self;
   

}

- (void)dealloc
{
//    NSLog(@"dealloc");
    _nameSpace = nil;
    
    self.fileStorageEngine = nil;
    self.memoryCache = nil;
    self.config = nil;
    self.configDict = nil;
//    NSLog(@"dealloc end");
}

//只是内存缓存不存储策略
//-(void)innerSaveCreateTime
//{
//   
//
//    if (self.cacheStoragePolicy == IDPCacheStorageMemory) {
//        return;
//    }
//     [self.configDict setObject:[NSNumber numberWithDouble:[NSDate timeIntervalSince1970]] forKey:kIdpCacheConfigCreateTime];
//}
-(void)innerSavePolicy:(int)policy
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemory) {
        return;
    }
     [self.configDict setObject:[NSNumber  numberWithInt:policy] forKey:kIdpCacheConfigPolicy];
}

-(void)setMemoryCapacity:(NSUInteger)value
{
    self.memoryCache.memoryCapacity = value;
    [self.configDict setObject:[NSNumber numberWithUnsignedInteger:value] forKey:kIdpCacheConfigMemoryCapacity];
    [self.config setObject:self.configDict forKey:kIdpCacheConfigKey];
}

- (void)setMemoryTotalCost:(NSUInteger)memoryTotalCost
{
    self.memoryCache.memoryTotalCost = memoryTotalCost;
}

-(NSUInteger)getMemoryCapacity
{
    NSNumber* number = [self.configDict objectForKey:kIdpCacheConfigMemoryCapacity];
    return number.unsignedIntegerValue;
}

//-(void)setMemoryDefaultTimeoutInterval:(double)value
//{
//    if (self.cacheStoragePolicy == IDPCacheStorageMemory) {
//        return;
//    }
//    self.memoryCache.timeoutInterval = self.memoryDefaultTimeoutInterval;
//    [self.configDict setObject:[NSNumber numberWithDouble:value] forKey:kIdpCacheConfigMemoryDefaultTimeoutInterval];
//     [self.config setObject:self.configDict forKey:kIdpCacheConfigKey];
//}
//-(double)getMemoryDefaultTimeoutInterval
//{
//    NSNumber* number = [self.configDict objectForKey:kIdpCacheConfigMemoryDefaultTimeoutInterval];
//    return number.doubleValue;
//}

//-(void)setDiskCacheSize:(NSUInteger)value
//{
//    if (self.cacheStoragePolicy == IDPCacheStorageMemory) {
//        return;
//    }
//    [self.configDict setObject:[NSNumber numberWithUnsignedInteger:value] forKey:kIdpCacheConfigDiskCacheSize];
//     [self.config setObject:self.configDict forKey:kIdpCacheConfigKey];
//}
//-(NSUInteger)getDiskCacheSize
//{
//    NSNumber* number = [self.configDict objectForKey:kIdpCacheConfigDiskCacheSize];
//    return number.unsignedIntegerValue;
//}

-(void)setDiskExpiredTime:(NSUInteger)value
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemory) {
        return;
    }
    [self.configDict setObject:[NSNumber numberWithUnsignedInteger:value] forKey:kIdpCacheConfigDiskExpiredTime];
     [self.config setObject:self.configDict forKey:kIdpCacheConfigKey];
}

-(NSUInteger)getDiskExpiredTime
{
    NSNumber* number = [self.configDict objectForKey:kIdpCacheConfigDiskExpiredTime];
    return number.unsignedIntegerValue;
}

-(BOOL)existCacheForKey:(NSString*)key
{
    if ([self existCacheForKeyInMemory:key]) {
        return YES;
    }
    return [self existCacheForKeyOnDisk:key];
}
-(BOOL)existCacheForKeyInMemory:(NSString *)key
{
//    NSLog(@"existCacheForKeyInMemory");
    if (self.cacheStoragePolicy  == IDPCacheStorageDisk) {
        return NO;
    }
    return [self.memoryCache existObjectForKey:key];
}
-(BOOL)existCacheForKeyOnDisk:(NSString *)key
{
//    NSLog(@"existCacheForKeyOnDisk");
    if (self.cacheStoragePolicy  == IDPCacheStorageMemory) {
        return NO;
    }
    return [self.fileStorageEngine isObjectForKeyExist:key];
}

-(void)setObj:(id)data forKey:(NSString *)aKey completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    if (data == nil || aKey == nil) {
        return;
    }
    if (self.cacheStoragePolicy == IDPCacheStorageMemory || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//         NSLog(@"save mem");
        [self.memoryCache saveObject:data forKey:aKey];
    }
     if (self.cacheStoragePolicy == IDPCacheStorageDisk || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//        NSLog(@"save disk");
        [self saveInner:data forKey:aKey completionHandle:completionHandler];
    }

}

-(void)setObj:(id)data forKey:(NSString *)aKey
{
    if (data == nil || aKey == nil) {
        return;
    }
    if (self.cacheStoragePolicy == IDPCacheStorageMemory || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//        NSLog(@"save mem");
        [self.memoryCache saveObject:data forKey:aKey];
    }
    if (self.cacheStoragePolicy == IDPCacheStorageDisk || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//        NSLog(@"save disk");
        [self saveInner:data forKey:aKey completionHandle:nil];
    }
    
}

-(void)setObj:(id)data forKey:(NSString *)aKey cost:(NSInteger)cost completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    if (data == nil) {
        return;
    }
    if (self.cacheStoragePolicy == IDPCacheStorageMemory || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//         NSLog(@"save mem");
        [self.memoryCache saveObject:data forKey:aKey cost:cost];
    }
    if (self.cacheStoragePolicy == IDPCacheStorageDisk || self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
//         NSLog(@"save disk");
        [self saveInner:data forKey:aKey completionHandle:completionHandler];
    }

}

-(void)saveInner:(id)data forKey:(NSString*)aKey completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    if([data isKindOfClass:[NSData class]] )
    {
        [self.fileStorageEngine saveData:data forKey:aKey completionHandle:completionHandler];
    }
    else if ([data isKindOfClass:[NSString class]])
    {
        [self.fileStorageEngine saveString:data forKey:aKey completionHandle:completionHandler];
    }
    else if([data isKindOfClass:[NSArray class]])
    {
        [self.fileStorageEngine saveArray:data forKey:aKey completionHandle:completionHandler];
    }
    else if([data isKindOfClass:[NSDictionary class]])
    {
        [self.fileStorageEngine saveDictionary:data forKey:aKey completionHandle:completionHandler];
    }
    else if([data isKindOfClass:[UIImage class]])
    {
        [self.fileStorageEngine saveImage:data forKey:aKey completionHandle:completionHandler];
    }
    else if ([data conformsToProtocol:@protocol(NSCoding)])
    {
        [self.fileStorageEngine saveCodingObject:data forKey:aKey completionHandle:completionHandler];
    }
    else
    {
        NSException* exception = [NSException
                                  exceptionWithName:@"IDP_WF"
                                  reason:@"can't save this type of obj"
                                  userInfo:nil];
        [exception raise];
        
    }
}

-(id)objectForKey:(NSString*)key
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
        id objRet = [self.memoryCache loadObjectForKey:key];
        if (!objRet) {
            NSError* error = nil;
            objRet = [self.fileStorageEngine objectForKey:key error:&error];
            if (objRet) {
                [self.memoryCache saveObject:objRet forKey:key];
            }
        }
        return objRet;
    }
    else if(self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        NSError* error = nil;
        id objRet = [self.fileStorageEngine objectForKey:key error:&error];
        return objRet;
    }
    else
    {
        return [self.memoryCache loadObjectForKey:key];
    }
}

-(id)objectForKeyOnlyInMemory:(NSString*)key
{
//    NSLog(@"objectForKeyOnlyInMemory");
    if(self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        return nil;
    }
    id obj = [self.memoryCache loadObjectForKey:key];
    return obj;
}

-(void)objectForKey:(NSString *)key  completionHandle:(void(^)(BOOL success,id obj))completionHandler
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk)
    {
        id objRet = [self.memoryCache loadObjectForKey:key];
        
        if (!objRet) {
            [self.fileStorageEngine objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
                if(obj)
                {
                    [self.memoryCache saveObject:obj forKey:key];
                }
                completionHandler(success,obj);
            }];
        }
        else
        {
            completionHandler(YES,objRet);
        }
    }
    
    else if(self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        [self.fileStorageEngine objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
            completionHandler(success,obj);
        }];
    }
    else
    {
        //只是内存缓存就同步完成
        id objRet = [self.memoryCache loadObjectForKey:key];
        if (objRet) {
            completionHandler(YES,objRet);
        }
        else
        {
            completionHandler(NO,nil);
        }
    }
}

-(void)removeObjcetForKey:(NSString*)key
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageMemory)
    {
        [self.memoryCache removeObjectForKey:key];
    }
    if(self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        [self.fileStorageEngine removeObjectForKey:key completionHandle:nil];
    }
}

//内存缓存移去
-(void)removeObjcetForKeyOnlyInMemory:(NSString*)key
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageMemory)
    {
        [self.memoryCache removeObjectForKey:key];
    }
}
-(void)removeAll
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageMemory)
    {
        [self.memoryCache removeAll];
    }
    if(self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        [IDPStorage cleanNameSpace:_nameSpace type:IDPStorageDisk completionHandle:nil];
    }

}

//清除所有（内存）
-(void)removeAllInMemory
{
    if (self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageMemory)
    {
        [self.memoryCache removeAll];
    }
}

//清除所有（内存和磁盘）
-(void)removeAllInDisk
{
    if(self.cacheStoragePolicy == IDPCacheStorageMemoryAndDisk || self.cacheStoragePolicy == IDPCacheStorageDisk)
    {
        [IDPStorage cleanNameSpace:_nameSpace type:IDPStorageDisk completionHandle:nil];
    }
}

//命中率查询
- (CGFloat)hitRate
{
    if(_queryCount == 0) return 0;
    return (CGFloat)(_memeryHitCount + _diskHitCount) / _queryCount;
}

@end
