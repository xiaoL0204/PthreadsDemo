//
//  XLDataFetchHandler.h
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLDataFetchHandler : NSObject

+(XLDataFetchHandler *)sharedInstance;

-(void)requestAllHomeThemeListWithCompletion:(void(^)(NSArray *themeList,BOOL httpDone))serverCompletion;

@end
