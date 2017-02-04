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
        NSArray *themeIdArray = @[@"1,2",@"3,4,5",@"6,7,8"];
        
        //分3次请求数据
        for (int i=0; i < themeIdArray.count; i++) {
            NSString *themeIds = themeIdArray[i];
            
            [self requestHomeThemeListWithThemeIds:themeIds completion:^(NSArray *themeArr, NSString *errMsg, NSError *error) {
                //回到主线程
                httpCount ++;
                [allThemeList addObjectsFromArray:themeArr];
                
                if (serverCompletion) {
                    serverCompletion(themeArr,httpCount==themeIdArray.count);
                }
                
                //            [[XLThemePersistenceHandler sharedInstance] saveThemeListPersistence:themeArr completion:^{
                //
                //            }];
                
                
                if (httpCount == themeIdArray.count) {
                    httpDone = YES;
                    pthread_cond_signal(&cond_t);
                }
                
                NSLog(@"requestHomeThemeListWithThemeIds  :%@   complete",themeIds);
            }];
        }
        
        
        
        
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
    
    //fake data
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
