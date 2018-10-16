//
//  IDPStorageSqliteInner.h
//  IDP
//
//  Created by ZhangHe on 13-3-21.
//
//  sqlite存储引擎

#import <Foundation/Foundation.h>
#import "IDPStorageProtocolInner.h"
#import "../Subs/ALSingleton.h"
#import "../ALDatabase/ALDatabase.h"
@interface IDPStorageSqliteInner : NSObject <IDPStorageProtocolInner>

-(id)initWithNameSpace:(NSString*)nameSpace;

@end


@interface IDPStorageSqliteConnection : NSObject

DEC_SINGLETON(IDPStorageSqliteConnection)

@property (nonatomic, retain) ALDataBase *database;

@end
