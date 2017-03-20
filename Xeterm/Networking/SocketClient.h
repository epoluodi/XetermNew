//
//  SocketClient.h
//  GCD_Socket_Demo
//
//  Created by Klwy on 16/10/19.
//  Copyright © 2016年 Klwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "ServerResult.h"
#import <UIKit/UIKit.h>

typedef void(^LinkState) (BOOL state);
typedef void(^Result) (ServerResult *reslut);

@interface SocketClient : NSObject

@property (nonatomic, assign) BOOL isShowAlert;
//@property (nonatomic, strong) NSString *account;
//@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *port;

+ (instancetype)shareSocketShareInstance;

- (void)createSocketConnectionWithHost:(NSString *)host port:(NSString *)port success:(LinkState)success failure:(LinkState)failure;
- (void)createSocketConnectionSuccess:(LinkState)success failure:(LinkState)failure;
- (void)sendMessage:(NSDictionary *)dic result:(Result)result;
- (void)sendMessage:(NSDictionary *)dic sendState:(LinkState)state;
- (void)closeSocketConnection;


- (NSString *)paramStringWithDic:(NSDictionary *)dic;
- (NSData *)dataWithParamString:(NSString *)str;

//- (void)requestNDS:(Result)result;
//- (void)requestLogin:(Result)result;
//- (void)requestLogout:(Result)result;

@end
