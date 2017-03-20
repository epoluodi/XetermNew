//
//  MD5String.h
//  Xeterm
//
//  Created by Klwy on 16/10/26.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolUtil : NSObject

+ (NSString *)MD5String:(NSString*)origString;
+ (NSString *)hexStringFromString:(NSString *)string;

@end
