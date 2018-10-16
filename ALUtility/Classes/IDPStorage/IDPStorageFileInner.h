//
//  IDPStorageFileInner.h
//  IDP
//
//  Created by douj on 17-3-12.
//
//  文件存储引擎

#import <Foundation/Foundation.h>
#import "IDPStorageProtocolInner.h"

@interface IDPStorageFileInner : NSObject <IDPStorageProtocolInner>

//文件存储引擎采用的是一个namespace一个文件夹的方式
-(id)initWithNameSpace:(NSString*)nameSpace;
+(void)cleanExpiredFiles:(NSString *)nameSpace expire:(NSNumber *)expireNumber;

@end
