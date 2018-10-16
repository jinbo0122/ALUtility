//
//  IDPStorageMemoryInner.h
//  IDP
//
//  Created by douj on 17-3-12.
//
//  内存存储主要是供IDPCache使用

#import <Foundation/Foundation.h>

@interface IDPStorageMemoryInner : NSObject
//内存配额（数量）
@property (nonatomic,assign) NSUInteger  memoryCapacity;
//内存配额（容量）
@property (nonatomic,assign) NSUInteger  memoryTotalCost;

//清空整个内存
+(void)cleanAllMemory;

-(id)initWithNameSpace:(NSString*)nameSpace;

//从内存中读取
-(id)loadObjectForKey:(NSString*)key;

//内存中是否存在
-(BOOL)existObjectForKey:(NSString*)key;

//从内存中删除
-(void)removeObjectForKey:(NSString*)key;

//保存到内存中
-(void)saveObject:(id)obj forKey:(NSString*)key;

//保存到内存中 cost为消耗的代价（一般为大小）
//如果存入内存缓存的cost超过memoryTotalCost系统会清理之前的对象
-(void)saveObject:(id)obj forKey:(NSString *)key cost:(NSUInteger)g;

//清除所有
-(void)removeAll;
@end
