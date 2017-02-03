//
//  XLThemeInfo.m
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "XLThemeInfo.h"

#define kThemeIdKey @"kThemeId"
#define kThemeNameKey @"kThemeName"
#define kThemeDescKey @"kThemeDesc"

@implementation XLThemeInfo

- (id)initWithCoder:(NSCoder *)decoder{
    if ((self = [super init])) {
        _themeId = [decoder decodeIntegerForKey:kThemeIdKey];
        _themeName = [decoder decodeObjectForKey:kThemeNameKey];
        _themeDesc = [decoder decodeObjectForKey:kThemeDescKey];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{ // NSCoding serialization
    [encoder encodeInteger:_themeId forKey:kThemeIdKey];
    [encoder encodeObject:_themeName?_themeName:@"" forKey:kThemeNameKey];
    [encoder encodeObject:_themeDesc?_themeDesc:@"" forKey:kThemeDescKey];
}

@end
