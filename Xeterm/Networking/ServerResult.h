//
//  ServerResult.h
//  Xeterm
//
//  Created by Klwy on 16/10/22.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResult : NSObject

@property (nonatomic, strong, readonly) NSString *xmlHeadStr;
@property (nonatomic, strong, readonly) NSString *cmdStr;
@property (nonatomic, assign, readonly) BOOL retCode;
@property (nonatomic, strong, readonly) NSDictionary *dnsDic;
@property (nonatomic, strong, readonly) NSDictionary *loginDic;
@property (nonatomic, strong, readonly) NSString *messageStr;
@property (nonatomic, strong, readonly) NSString *contentStr;
@property (nonatomic, strong, readonly) NSDictionary *resultDic;

- (id)initWithResult:(NSString *)result;


@end
