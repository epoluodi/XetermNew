//
//  ServerResult.m
//  Xeterm
//
//  Created by Klwy on 16/10/22.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "ServerResult.h"

@interface ServerResult ()
{
    NSArray *_dnsKeyArray;
    NSArray *_loginKeyArray;
    NSArray *_xmlKeyArray;
    NSDictionary *_muDic;
}
@end

@implementation ServerResult

- (id)initWithResult:(NSString *)result {
    
    if(self = [super init]) {
        
        _dnsKeyArray = @[@"ret", @"hip", @"hname", @"hport"];
        _loginKeyArray = @[@"adc", @"adt", @"cl", @"ep", @"phost", @"pop", @"ret"];
        
        _xmlKeyArray = @[@"cmd", @"data", @"adc", @"adt", @"cl", @"ep", @"force", @"hip", @"hname", @"hport", @"phost", @"pop", @"ret", @"url", @"alipay"];
        
        _muDic = [self objFromXmlString:[self contentWithResult:result]];
//        NSLog(@"_muDic = %@", _muDic);
        
    }
    return self ;
}

- (NSString *)contentWithResult:(NSString *)result {
    
    
    
    NSString *aStr = [NSString stringWithFormat:@"<x>"];
    
    if([result hasPrefix:aStr]) {
        _xmlHeadStr = @"";
        _contentStr = result;
        return _contentStr;
    }
    
    
    NSRange aRange = [result rangeOfString:aStr];
    if(aRange.location == NSNotFound) {
        return result;
    }
    
    
    _xmlHeadStr = [result substringToIndex:aRange.location];
    
    _contentStr = [result substringFromIndex:aRange.location];
    
    return _contentStr;
}


- (NSDictionary *)objFromXmlString:(NSString *)xmlString {
    
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    for(NSString *key in _xmlKeyArray) {
        NSString *aStr = [NSString stringWithFormat:@"<%@>", key];
        NSString *bStr = [NSString stringWithFormat:@"</%@>", key];
        
        NSRange aRange = [xmlString rangeOfString:aStr];
        if(aRange.location == NSNotFound) {
            continue;
        }
        
        NSRange bRange = [xmlString rangeOfString:bStr];
        if(bRange.location == NSNotFound) {
            continue;
        }
        
        NSString *str = [xmlString substringWithRange:NSMakeRange(aRange.location+aRange.length, bRange.location-aRange.location-aRange.length)];
        [muDic setObject:str forKey:key];
        
    }
    
    return muDic;
}

- (NSString *)cmdStr {
    return _muDic[@"cmd"];
}

- (BOOL)retCode {
    
    NSString *cmd = _muDic[@"cmd"];
    if([cmd isEqualToString:@"login"] ||
       [cmd isEqualToString:@"dns"]) {
        
        if([[_muDic allKeys] containsObject:@"ret"]) {
            return [_muDic[@"ret"] isEqualToString:@"ok"];
        } else {
            return NO;
        }
        
    } else {
        return NO;
    }
    
}

- (NSDictionary *)resultDic {
    return _muDic;
}


- (NSDictionary *)dnsDic {
    
    NSString *cmd = _muDic[@"cmd"];
    if([cmd isEqualToString:@"dns"]) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for(NSString *key in _dnsKeyArray) {
            [dic setObject:_muDic[key] forKey:key];
        }
        return dic;
        
    } else {
        return @{};
    }
}

- (NSDictionary *)loginDic {
    
    NSString *cmd = _muDic[@"cmd"];
    if([cmd isEqualToString:@"login"]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for(NSString *key in _loginKeyArray) {
            [dic setObject:_muDic[key] forKey:key];
        }
        return dic;
        
    } else {
        return @{};
    }
}

- (NSString *)messageStr {
    NSString *cmd = _muDic[@"cmd"];
    if([cmd isEqualToString:@"raw"] || [cmd isEqualToString:@"pop"]) {
        return _muDic[@"data"];
    } else {
        return @"";
    }
}

@end
