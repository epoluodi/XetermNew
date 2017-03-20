//
//  MoreColorText.m
//  Xeterm
//
//  Created by Klwy on 16/10/24.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "MoreColorText.h"

static MoreColorText *moreColorTextManager = nil;

@interface MoreColorText ()
{
    UIColor *_defaultColor;
    NSString *_startWord;
    NSString *_replateWorkd;
    UIFont *_font;
}

@end 

@implementation MoreColorText

+ (id)shareMoreColorInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(moreColorTextManager == nil) {
            moreColorTextManager = [[MoreColorText alloc] init];
        }
    });
    
    return moreColorTextManager;
}

- (id)init {
    if(self = [super init]) {
        
        _font = DEFAULT_FONT_NAME_SIZE;
        _replateWorkd = REPLATED_START_FLAG;
        _startWord = START_WORD;
//        _defaultColor = [UIColor colorWithHexString:@"00FF00"];
        _defaultColor = DefaultGreenHexColor;
    }
    return self;
}


- (NSAttributedString *)colorTextWithString:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:_replateWorkd withString:_startWord];

//    string = [string stringByReplacingOccurrencesOfString:_replateWorkd withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@" \n"];
    NSString *bStr = @"</";
    
//    NSMutableString *htmlMuStr = [NSMutableString string];
//    
//    NSMutableString *mStr = [NSMutableString string];
    
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] init];
    
    while (string.length != 0) {
        
        NSRange bRange = [string rangeOfString:bStr];
        if(bRange.location == NSNotFound) {
//            string = [string stringByAppendingString:_startWord];
            return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: _defaultColor, NSFontAttributeName:_font}];
        }
        
        NSString *str = [string substringToIndex:bRange.location+bRange.length+7];
        
        NSString *color = [str substringWithRange:NSMakeRange(1, 6)];
        NSString *value = [str substringWithRange:NSMakeRange(8, str.length-17)];
        
        NSAttributedString *temp = [[NSAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:color], NSFontAttributeName:_font}];
        [muAttStr appendAttributedString:temp];
    
        
//        [mStr appendString:value];
//        [htmlMuStr appendFormat:@"<pre style=\"color:#%@;display: inline-block;\">%@</pre>", color, value];
//        
        string = [string substringFromIndex:bRange.location+bRange.length+7];
    }
    
    return muAttStr;
    
//    NSData *data = [htmlMuStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
////    return html;
//    
//    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:html];
//    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:START_WORD attributes:@{NSForegroundColorAttributeName: _defaultColor}];
//    [muAttStr appendAttributedString:attStr];
//    
//    return muAttStr;
}

@end
