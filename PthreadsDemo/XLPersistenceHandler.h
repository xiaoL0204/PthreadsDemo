//
//  XLPersistenceHandler.h
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPersistenceHandler : NSObject
+(instancetype)sharedInstance;

#pragma mark - 主题
-(void)fetchAllThemeListFromPersistenceWithCompletion:(void(^)(NSArray *themeList))completion;
-(void)saveThemeListPersistence:(NSArray *)partList completion:(dispatch_block_t)completion;
-(void)deleteAllThemeListPersistenceCompletion:(dispatch_block_t)completion;
#pragma mark -

@end
