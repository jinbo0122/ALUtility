//
//  IDPStorageMemoryInner.m
//  IDP
//
//  Created by douj on 17-3-12.
//
//

#import "IDPStorageMemoryInner.h"
@interface IDPStorageMemoryItem : NSObject

@property (nonatomic,retain) id cacheObj;

@end
@implementation IDPStorageMemoryItem

- (void)dealloc
{
  self.cacheObj = nil;
}

@end

@interface IDPStorageMemoryInner()

@property (nonatomic,copy) NSString* nameSpace;
@property (nonatomic,retain)NSCache* memoryCache;
@property (nonatomic,assign) NSUInteger time_count;

@end
@implementation IDPStorageMemoryInner

+(void)cleanAllMemory
{
  for (IDPStorageMemoryInner* memory in [get_memory_namespace_dict() allValues])
  {
    [memory.memoryCache removeAllObjects];
  }
}
static NSMutableDictionary* get_memory_namespace_dict()
{
  static NSMutableDictionary *idpShareMemDict;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    idpShareMemDict = [NSMutableDictionary new];
  });
  return idpShareMemDict;
}


-(id)initWithNameSpace:(NSString*)nameSpace
{
  self = [super init];
  if (self)
  {
    self.nameSpace = nameSpace;
    self.memoryCache = [NSCache new];
    [get_memory_namespace_dict() setObject:self forKey:nameSpace];
  }
  return self;
}

-(void)setMemoryCapacity:(NSUInteger)memoryCapacity
{
  [self.memoryCache setCountLimit:memoryCapacity];
}

- (void)setMemoryTotalCost:(NSUInteger)memoryTotalCost
{
  [self.memoryCache setTotalCostLimit:memoryTotalCost];
}

-(NSUInteger)getMemoryCapacity
{
  return self.memoryCache.countLimit;
}

-(BOOL)existObjectForKey:(NSString*)key
{
  id obj = [self.memoryCache objectForKey:key];
  if (obj) {
    return YES;
  }
  return NO;
}

-(id)loadObjectForKey:(NSString*)key
{
  IDPStorageMemoryItem* item = [self.memoryCache objectForKey:key];
  return item.cacheObj;
}
-(void)saveObject:(id)obj forKey:(NSString*)key
{
  IDPStorageMemoryItem* item = [[IDPStorageMemoryItem alloc] init];
  item.cacheObj = obj;
  [self.memoryCache setObject:item forKey:key];
}

-(void)saveObject:(id)obj forKey:(NSString *)key cost:(NSUInteger)g
{
  IDPStorageMemoryItem* item = [[IDPStorageMemoryItem alloc] init];
  item.cacheObj = obj;
  [self.memoryCache setObject:item forKey:key cost:g];
}

-(void)removeObjectForKey:(NSString*)key
{
  [self.memoryCache removeObjectForKey:key];
}

-(void)removeAll
{
  [self.memoryCache removeAllObjects];
}

@end
