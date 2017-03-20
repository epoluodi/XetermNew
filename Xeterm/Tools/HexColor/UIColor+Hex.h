//
//  UIColor+Hex.h
//  ColorTest
//
//  Created by Klwy on 15/4/22.
//  Copyright (c) 2015年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

@end
