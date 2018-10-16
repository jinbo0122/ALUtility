//
//  IDPConfig.m
//  IDP
//
//  Created by douj on 17-3-13.
//
//

#import "IDPConfig.h"

@implementation IDPConfig

-(id)initWithNameSpace:(NSString*)nameSpace
{
  self = [super init];
  if (self) {
    _nameSpace = [nameSpace copy];
  }
  return self;
}
- (void)dealloc
{
  _nameSpace = nil;
}
- (id)objectForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:[self getRealDefaultName:defaultName ]];
}
- (void)setObject:(id)value forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setObject:value forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults]  synchronize];
}
- (void)removeObjectForKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:[self getRealDefaultName:defaultName ]];
}
- (NSString *)stringForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults]stringForKey:[self getRealDefaultName:defaultName ]];
}
- (NSArray *)arrayForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults]arrayForKey:[self getRealDefaultName:defaultName ]];
}
- (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] dictionaryForKey:[self getRealDefaultName:defaultName ]];
}
- (NSData *)dataForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] dataForKey:[self getRealDefaultName:defaultName ]];
}
- (NSArray *)stringArrayForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] stringArrayForKey:[self getRealDefaultName:defaultName ]];
}
- (NSInteger)integerForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:[self getRealDefaultName:defaultName ]];
}
- (float)floatForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] floatForKey:[self getRealDefaultName:defaultName ]];
}
- (double)doubleForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] doubleForKey:[self getRealDefaultName:defaultName ]];
}
- (BOOL)boolForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] boolForKey:[self getRealDefaultName:defaultName ]];
}
- (NSURL *)URLForKey:(NSString *)defaultName
{
  return [[NSUserDefaults standardUserDefaults] URLForKey:[self getRealDefaultName:defaultName ]];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setInteger:value forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults]  synchronize];
}
- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setFloat:value forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults]  synchronize];
}
- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setDouble:value forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults]  synchronize];
}
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setBool:value forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults]  synchronize];
}
- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName
{
  [[NSUserDefaults standardUserDefaults] setURL:url forKey:[self getRealDefaultName:defaultName ]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getRealDefaultName:(NSString*)name
{
  return [NSString stringWithFormat:@"%@>_<%@",_nameSpace,name];
}
@end
