//
//  XLDataFetchHandler.m
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "XLDataFetchHandler.h"
#import "XLPersistenceHandler.h"
#import "XLThemeInfo.h"
#import "pthread.h"


@implementation XLDataFetchHandler

+(XLDataFetchHandler *)sharedInstance{
    static XLDataFetchHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


-(void)requestAllHomeThemeListWithCompletion:(void(^)(NSArray *themeList,BOOL httpDone))serverCompletion{
    dispatch_async(dispatch_queue_create("com.dispatch.themerequest", DISPATCH_QUEUE_CONCURRENT), ^{
        pthread_t threadId = pthread_self();
        __block pthread_cond_t cond_t = PTHREAD_COND_INITIALIZER;
        __block BOOL httpDone = NO;
        __block NSInteger httpCount = 0;
        
        NSMutableArray *allThemeList = [NSMutableArray array];
        [self requestHomeThemeListWithThemeIds:@"1,2" completion:^(NSArray *themeArr, NSString *errMsg, NSError *error) {
            httpCount ++;
            [allThemeList addObjectsFromArray:themeArr];
            
            if (serverCompletion) {
                serverCompletion(themeArr,httpCount==3);
            }
            
            //            [[XLThemePersistenceHandler sharedInstance] saveThemeListPersistence:themeArr completion:^{
            //
            //            }];
            
            
            if (httpCount == 3) {
                httpDone = YES;
                pthread_cond_signal(&cond_t);
            }
            
            NSLog(@"requestHomeThemeListWithThemeIds  :1,2   complete");
        }];
        
        [self requestHomeThemeListWithThemeIds:@"3,4,5" completion:^(NSArray *themeArr, NSString *errMsg, NSError *error) {
            httpCount ++;
            
            [allThemeList addObjectsFromArray:themeArr];
            
            if (serverCompletion) {
                serverCompletion(themeArr,httpCount==3);
            }
            
            //            [[XLThemePersistenceHandler sharedInstance] saveThemeListPersistence:themeArr completion:^{
            //
            //            }];
            
            
            if (httpCount == 3) {
                httpDone = YES;
                pthread_cond_signal(&cond_t);
            }
            
            NSLog(@"requestHomeThemeListWithThemeIds  :3,4,5   complete");
        }];
        
        [self requestHomeThemeListWithThemeIds:@"6,7,8" completion:^(NSArray *themeArr, NSString *errMsg, NSError *error) {
            httpCount ++;
            [allThemeList addObjectsFromArray:themeArr];
            
            if (serverCompletion) {
                serverCompletion(themeArr,httpCount==3);
            }
            
            
            if (httpCount == 3) {
                httpDone = YES;
                pthread_cond_signal(&cond_t);
            }
            
            NSLog(@"requestHomeThemeListWithThemeIds  :6,7,8   complete");
        }];
        
        
        pthread_mutex_t mutex_t = PTHREAD_MUTEX_INITIALIZER;
        while (!httpDone) {
            pthread_cond_wait(&cond_t, &mutex_t);
        }
        pthread_join(threadId, NULL);
        
        
        NSLog(@"requestHomeThemeListWithThemeIds  All   complete");
        
        [[XLPersistenceHandler sharedInstance] deleteAllThemeListPersistenceCompletion:^{
            [[XLPersistenceHandler sharedInstance] saveThemeListPersistence:allThemeList completion:^{
            }];
        }];
    });
}


-(void)requestHomeThemeListWithThemeIds:(NSString *)themeIds completion:(void(^)(NSArray *themeArr,NSString *errMsg,NSError *error))completion{
    if (!themeIds || [themeIds isEqualToString:@""]) {
        if (completion) {
            completion(nil,nil,nil);
        }
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random()%200/100.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *themeArr = [NSMutableArray array];
        NSInteger randomIndex = (random()%10)*100;
        for (int i=0; i<10; i++) {
            XLThemeInfo *info = [[XLThemeInfo alloc] init];
            info.themeId = randomIndex+i;
            info.themeName = [NSString stringWithFormat:@"themeName_%@",@(randomIndex)];
            info.themeDesc = [NSString stringWithFormat:@"themeDesc_%@",@(randomIndex)];
            [themeArr addObject:info];
        }
        
        if (completion) {
            completion(themeArr,nil,nil);
        }
    });
}


@end
