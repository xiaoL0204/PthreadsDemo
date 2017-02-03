//
//  XLPersistenceHandler.m
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "XLPersistenceHandler.h"
#import "YapDatabase.h"
#import "XLThemeInfo.h"

#define kDBName @"PthreadsDemo.db"
//主题
#define kThemeCollectionName @"kThemeCollectionName"
#define kThemeInfoKey(themeId) \
[NSString stringWithFormat:@"themeId_%@",@(themeId)]

@interface XLPersistenceHandler()
@property (nonatomic,strong) YapDatabase *database;
@end

@implementation XLPersistenceHandler

+(instancetype)sharedInstance{
    static XLPersistenceHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.database = [[YapDatabase alloc] initWithPath:[self getFilePath]];
    }
    return self;
}

#pragma mark - 主题
-(void)fetchAllThemeListFromPersistenceWithCompletion:(void(^)(NSArray *themeList))completion{
    [self asyncFetchPersistenceDataFromCollection:kThemeCollectionName completion:^(NSArray *list) {
        if (completion) {
            completion(list);
        }
    }];
}
-(void)saveThemeListPersistence:(NSArray *)partList completion:(dispatch_block_t)completion{
    YapDatabaseConnection *connection = [self.database newConnection];
    [connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        for (XLThemeInfo *info in partList) {
            [transaction setObject:info forKey:kThemeInfoKey(info.themeId) inCollection:kThemeCollectionName];
        }
    } completionBlock:^{
        if (completion) {
            completion();
        }
    }];
}
-(void)deleteAllThemeListPersistenceCompletion:(dispatch_block_t)completion{
    [self asyncRemoveAllObjectsInCollection:kThemeCollectionName completion:^{
        if (completion) {
            completion();
        }
    }];
}
#pragma mark -





#pragma mark - 公共方法
//取
-(void)asyncFetchPersistenceDataFromCollection:(NSString *)collection completion:(void(^)(NSArray *list))completion{
    if (!collection || [collection isEqualToString:@""]) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    YapDatabaseConnection *connection = [self.database newConnection];
    [connection asyncReadWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        [transaction enumerateKeysAndObjectsInCollection:collection usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            [resultArray addObject:object];
        }];
        if (completion) {
            completion(resultArray);
        }
    } completionBlock:^{
    }];
}
//删
-(void)asyncRemoveAllObjectsInCollection:(NSString *)collection completion:(dispatch_block_t)completion{
    if (!collection || [collection isEqualToString:@""]) {
        if (completion) {
            completion();
        }
        return;
    }
    
    YapDatabaseConnection *connection = [self.database newConnection];
    [connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction removeAllObjectsInCollection:collection];
    }completionBlock:^{
        if (completion) {
            completion();
        }
    }];
}



#pragma mark - 获取数据库路径
- (NSString*)getFilePath{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:kDBName];
    return databaseFilePath;
}
@end
