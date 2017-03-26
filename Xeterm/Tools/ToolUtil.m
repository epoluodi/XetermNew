//
//  MD5String.m
//  Xeterm
//
//  Created by Klwy on 16/10/26.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "ToolUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ToolUtil

+ (NSString *)MD5String:(NSString*)origString
{
    const char *original_str = [origString UTF8String];
    unsigned char result[32];

    CC_MD5(original_str, (unsigned int)strlen(original_str), result);//调用md5

    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }

    return hash;
}

+ (NSString *)hexStringFromString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    
    return hexStr; 
}





@end
