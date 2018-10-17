//
//  IDPStorageEngine.m
//  IDP
//
//  Created by douj on 17-3-12.
//
//

#import "IDPStorage.h"
#import "IDPStorageFileInner.h"
#import "IDPStorageSqliteInner.h"
#import "NSArray+ALExtension.h"
#import "NSDictionary+ALExtension.h"
#import "NSData+ALExtension.h"
#import "NSString+ALExtension.h"
#import <SDWebImage/UIImage+MultiFormat.h>
typedef enum {
    IDPCacheObjectTypeData = 1,
    IDPCacheObjectTypeArray,
    IDPCacheObjectTypeDictionary,
    IDPCacheObjectTypeString,
    IDPCacheObjectTypeImage,
    IDPCacheObjectTypeCoding
} IDPCacheObjectType;

@interface IDPStorage()
//物理存储引擎
@property (nonatomic,retain) id<IDPStorageProtocolInner> storageInnerEngine;

@end

@implementation IDPStorage

//全局唯一读写队列
static dispatch_queue_t get_idp_diskio_queue()
{
    static dispatch_queue_t idpDiskIOQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        idpDiskIOQueue = dispatch_queue_create("com.baobao.idp.diskio", DISPATCH_QUEUE_SERIAL);
    });
    return idpDiskIOQueue;
}

static dispatch_queue_t get_idp_asy_queue()
{
    static dispatch_queue_t idpMemeryQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        idpMemeryQueue = dispatch_queue_create("com.baobao.idp.asyio", DISPATCH_QUEUE_SERIAL);
    });
    return idpMemeryQueue;
}


-(id)initWithNameSpace:(NSString*)nameSpace type:(IDPStorageType)type
{
    self = [super init];
    if(self)
    {
        _nameSpace = [nameSpace copy];
        //根据策略选择引擎
        if (type == IDPStorageDisk) {
            self.storageInnerEngine = [[IDPStorageFileInner alloc] initWithNameSpace:nameSpace];
        }
        else {
            self.storageInnerEngine = [[IDPStorageSqliteInner alloc] initWithNameSpace:nameSpace];
        }
    }
    return self;
}
- (void)dealloc
{
    _nameSpace = nil;
    self.storageInnerEngine = nil;
}

-(NSError*)createError:(NSString*)description errorCode:(NSInteger)code
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"com.baobao.idp" code:code userInfo:userInfo];
}

-(BOOL)isObjectForKeyExist:(NSString*)key
{
    return  [self.storageInnerEngine existObjectForKey:key];
}

//同步方法
-(NSData*)dataForKey:(NSString*)key error:(NSError* __autoreleasing *)error
{
    //保证线程安全使用sync和async调用一个队列
    __block NSData* data = nil;
    dispatch_sync(get_idp_diskio_queue(), ^{
        data =[self.storageInnerEngine loadObjectForKey:key error:error];
    });
    return data;
}
//同步写
-(BOOL)setData:(NSData*)obj forKey:(NSString*)key error:(NSError* __autoreleasing *)error
{
    __block BOOL bRet = FALSE;
     dispatch_sync(get_idp_diskio_queue(), ^{
         bRet = [self.storageInnerEngine saveObject:obj forKey:key error:error];
     });
    return bRet;
}

-(BOOL)removeDataForKey:(NSString*)key error:(NSError * __autoreleasing *)error
{
    __block BOOL bRet = FALSE;
    dispatch_sync(get_idp_diskio_queue(), ^{
        bRet =   [self.storageInnerEngine removeObjectForKey:key error:error];
    });
    return bRet;
}

//异步方法
-(void)dataForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
        
        NSError* error = nil;
        NSData* data =[self dataForKey:key error:&error];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                BOOL bSuccess = NO;
                if (data) {
                    bSuccess = YES;
                }
                completionHandler(bSuccess,error,data);
            });
        }
        
    });
}

-(void)setData:(NSData*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
        NSError* error = nil;
        
        BOOL bSuccess  = [self setData:obj forKey:key error:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    });
}

-(void)removeObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
        NSError* error = nil;
        BOOL bSuccess  = [self removeDataForKey:key error:&error];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    });

}

//清空整个命名空间
+(BOOL)cleanNameSpace:(NSString*)nameSpace type:(IDPStorageType)type error:(NSError **)error
{
    if(type == IDPStorageDisk)
    {
        return [IDPStorageFileInner cleanNameSpace:nameSpace error:error];
    }
    else if(type == IDPStorageSql)
    {
        return [IDPStorageSqliteInner cleanNameSpace:nameSpace error:error];
    }
    return NO;
}

+(void)cleanNameSpace:(NSString*)nameSpace type:(IDPStorageType)type completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
        NSError* error = nil;
        BOOL bSuccess = [IDPStorage cleanNameSpace:nameSpace type:type error:&error];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    });
}

+(void)cleanExpiredFiles:(NSString*)nameSpace type:(IDPStorageType)type expire:(NSNumber *)expireNumber
{
    if(type == IDPStorageDisk)
    {
        [IDPStorageFileInner cleanExpiredFiles:nameSpace expire:expireNumber];
    }
}


- (id)objectForKey:(NSString *)key error:(NSError **)error
{
    //保证线程安全使用sync和async调用一个队列
    NSData* data = nil;
    id obj = nil;

    data = [self dataForKey:key error:error];
    if(data.length > 2)
    {
        int type = 0;
        NSData *typeHeader = [data subdataWithRange:NSMakeRange(0, sizeof(type))];
        [typeHeader getBytes:&type length:4];
        NSData *dataContent = [data subdataWithRange:NSMakeRange(sizeof(type), data.length - sizeof(type))];
        switch (type) {
            case IDPCacheObjectTypeData:
                obj = dataContent;
                break;
            case IDPCacheObjectTypeArray:
                obj = [self parseArrayObject:dataContent];
                break;
            case IDPCacheObjectTypeDictionary:
                obj = [self parseDictionaryObject:dataContent];
                break;
            case IDPCacheObjectTypeString:
                obj = [self parseStringObject:dataContent];
                break;
            case IDPCacheObjectTypeImage:
                obj = [self parseImageObject:dataContent];
                break;
            case IDPCacheObjectTypeCoding:
                obj = [self parseCodingObject:dataContent];
                break;
            default:
                break;
        }
    }
 
    return obj;
}

- (void)objectForKey:(NSString *)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
        NSError* error = nil;
        id data = [self objectForKey:key error:&error];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                BOOL bSuccess = NO;
                if (data) {
                    bSuccess = YES;
                }
                completionHandler(bSuccess,error,data);
            });
        }
    });
}

- (BOOL)setObject:(NSData *)data forKey:(NSString *)key type:(IDPCacheObjectType)type error:(NSError **)error
{
     BOOL success = NO;
    NSMutableData *saveData = [[NSMutableData alloc] initWithBytes:&type length:sizeof(type)];
    [saveData appendData:data];
    success = [self setData:saveData forKey:key error:error];
    return success;
}

- (void)setObject:(NSData*)data forKey:(NSString*)key type:(IDPCacheObjectType)type completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_idp_asy_queue(), ^{
         NSError* error = nil;
        BOOL bSuccess =  [self setObject:data forKey:key type:type error:&error];
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    });
}

@end


@implementation IDPStorage (NSDataExtension)

-(NSData*)loadDataForKey:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadDataForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSData* obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveData:(NSData*)obj forKey:(NSString*)key error:(NSError**)error
{
    return [self setObject:obj forKey:key type:IDPCacheObjectTypeData error:error];
}

-(void)saveData:(NSData*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    [self setObject:obj forKey:key type:IDPCacheObjectTypeData completionHandle:completionHandler];
}

@end

@implementation IDPStorage (NSArrayExtension)

-(NSArray*)parseArrayObject:(NSData *)data
{
    return [data array];
}

-(NSArray*)loadArrayForKey:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadArrayForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSArray* obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveArray:(NSArray*)obj forKey:(NSString*)key error:(NSError**)error
{
    return [self setObject:[obj data] forKey:key type:IDPCacheObjectTypeArray error:error];
}

-(void)saveArray:(NSArray*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    [self setObject:[obj data] forKey:key type:IDPCacheObjectTypeArray completionHandle:completionHandler];
}

@end

@implementation IDPStorage (NSDictionaryExtension)

-(NSDictionary*)parseDictionaryObject:(NSData *)data
{
    return [data dictionary];
}

-(NSDictionary*)loadDictionaryForKey:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadDictionaryForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSDictionary* obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveDictionary:(NSDictionary*)obj forKey:(NSString*)key error:(NSError**)error
{
    return [self setObject:[obj data] forKey:key type:IDPCacheObjectTypeDictionary error:error];
}

-(void)saveDictionary:(NSDictionary*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    [self setObject:[obj data] forKey:key type:IDPCacheObjectTypeDictionary completionHandle:completionHandler];
}

@end

@implementation IDPStorage (NSStringExtension)

-(NSString*)parseStringObject:(NSData *)data
{
    return [data UTF8String];
}

-(NSString*)loadStringForKey:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadStringForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,NSString* obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveString:(NSString*)obj forKey:(NSString*)key error:(NSError**)error
{
    return [self setObject:[obj UTF8Data] forKey:key type:IDPCacheObjectTypeString error:error];
}

-(void)saveString:(NSString*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    [self setObject:[obj UTF8Data] forKey:key type:IDPCacheObjectTypeString completionHandle:completionHandler];
}

@end

@implementation IDPStorage (UIImageExtension)

-(UIImage*)parseImageObject:(NSData *)data
{
  return [UIImage sd_imageWithData:data];
}

-(UIImage*)loadImageForKey:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadImageForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,UIImage* obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveImage:(UIImage*)obj forKey:(NSString*)key error:(NSError**)error
{
    NSData* data = UIImageJPEGRepresentation(obj, (CGFloat)1.0);
    return [self setObject:data forKey:key type:IDPCacheObjectTypeImage error:error];
}

-(void)saveImage:(UIImage*)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    NSError* error = nil;
    //异步编码
    NSData* data;
    if ([key rangeOfString:@".png"].location!=NSNotFound) {
      data = UIImagePNGRepresentation(obj);
    }else{
      data = UIImageJPEGRepresentation(obj, (CGFloat)1.0);
    }
    BOOL bSuccess = [self setObject:data forKey:key type:IDPCacheObjectTypeImage error:&error];
    if (completionHandler)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            completionHandler(bSuccess,error);
        });
    }
    
    /*NSArray *array = [key componentsSeparatedByString:@","];
    if (array && [array count] > 1 && [[array safeObjectAtIndex:1] isEqualToString:@"png"]) {
        NSData* data = UIImagePNGRepresentation(obj);
        NSString* imageKey = [array safeObjectAtIndex:0] ;
        BOOL bSuccess = [self setObject:data forKey:imageKey type:IDPCacheObjectTypeImage error:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    }else {
        NSData* data = UIImageJPEGRepresentation(obj, (CGFloat)1.0);
        BOOL bSuccess = [self setObject:data forKey:key type:IDPCacheObjectTypeImage error:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(bSuccess,error);
            });
        }
    }*/
}


@end


@implementation IDPStorage (NSCodingExtension)

- (id)parseCodingObject:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(id)loadCodingObject:(NSString*)key error:(NSError**)error
{
    return [self objectForKey:key error:error];
}

-(void)loadCodingForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandler
{
    [self objectForKey:key completionHandle:^(BOOL success, NSError *error, id obj) {
        completionHandler(success, error, obj);
    }];
}

-(BOOL)saveCodingObject:(id)obj forKey:(NSString*)key error:(NSError**)error
{
    if (![obj conformsToProtocol:@protocol(NSCoding)])
    {
        if (error) {
            *error = [self createError:@"obj not support NSCoding protocol" errorCode:-1];
        }
        return NO;
    }
   
    return [self setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:key type:IDPCacheObjectTypeCoding error:error];
}

-(void)saveCodingObject:(id)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    if (![obj conformsToProtocol:@protocol(NSCoding)])
    {
        if (completionHandler) {
            completionHandler(NO,[self createError:@"obj not support NSCoding protocol" errorCode:-1]);
        }
        return;
    }

    [self setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:key type:IDPCacheObjectTypeCoding completionHandle:nil];
}

@end
