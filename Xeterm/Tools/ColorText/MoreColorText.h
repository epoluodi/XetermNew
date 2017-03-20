//
//  MoreColorText.h
//  Xeterm
//
//  Created by Klwy on 16/10/24.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreColorText : NSObject

+ (id)shareMoreColorInstance;

- (NSAttributedString *)colorTextWithString:(NSString *)str;

@end
