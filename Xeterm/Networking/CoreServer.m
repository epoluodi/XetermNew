//
//  CoreServer.m
//  Xeterm
//
//  Created by Stereo on 2017/3/27.
//  Copyright © 2017年 klwy. All rights reserved.
//

#import "CoreServer.h"
#import "SFHFKeychainUtils.h"
#import "Defines.h"

@implementation CoreServer


-(instancetype)init:(SocketClient *)client
{
    self =[super init];
    _client=client;
    return self;
}
- (void)requestNDS{
    
    NSString *uuid =  [SFHFKeychainUtils getPasswordForUsername:UUID_KEY_NAME
                                                 andServiceName:UUID_KEY_SERVICE_NAME
                                                          error:nil];
    if(!uuid)
    {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [SFHFKeychainUtils storeUsername:UUID_KEY_NAME
                             andPassword:uuid
                          forServiceName:UUID_KEY_SERVICE_NAME
                          updateExisting:1
                                   error:nil];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"dns" forKey:@"cmd"];
    [dic setObject:uuid forKey:@"mac"];
    [dic setObject:@"1" forKey:@"hname"];
    [dic setObject:@"1" forKey:@"hip"];
    [dic setObject:@"1" forKey:@"hport"];
    [dic setObject:@"1" forKey:@"ext"];
    
    [_client sendMessage:dic result:^(ServerResult *result) {
        
        if([result.cmdStr isEqualToString:@"dns"] && result.retCode) {
            
            if([[result.resultDic allKeys] containsObject:@"alipay"] &&
               [result.resultDic[@"alipay"] boolValue]) {
                dispatch_async(MAINQ, ^{
                    [_delegate PayResult:NO];
                });

            } else {
                dispatch_async(MAINQ, ^{
                    [_delegate PayResult:YES];
                });

            }
            
    
            [_client createSocketConnectionWithHost:result.dnsDic[@"hip"] port:result.dnsDic[@"hport"] success:^(BOOL state) {
                NSLog(@"准备登陆");
                [self requestLogin];
            } failure:^(BOOL state) {
                if(!state) {
                    dispatch_async(MAINQ, ^{
                        [_delegate WaitViewStop];
                    });
                }
            }];
            
        } else {
            dispatch_async(MAINQ, ^{
                [_delegate WaitViewStop];
            });
        }
    }];
}

- (void)requestLogin {
    
    NSString *uuid =  [SFHFKeychainUtils getPasswordForUsername:UUID_KEY_NAME
                                                 andServiceName:UUID_KEY_SERVICE_NAME
                                                          error:nil];
    if(!uuid)
    {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [SFHFKeychainUtils storeUsername:UUID_KEY_NAME
                             andPassword:uuid
                          forServiceName:UUID_KEY_SERVICE_NAME
                          updateExisting:1
                                   error:nil];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"login" forKey:@"cmd"];
    [dic setObject:uuid forKey:@"mac"];
    [dic setObject:_serverAddress forKey:@"host"];
    [dic setObject:_serverPort forKey:@"port"];
    [dic setObject:_userName forKey:@"account"];
    [dic setObject:_userPwd forKey:@"password"];
    [dic setObject:_appVer forKey:@"ver"];
    [dic setObject:@"1" forKey:@"term"];
    [dic setObject:@"0" forKey:@"updating"];
    [dic setObject:@"1" forKey:@"ext"];
    
    BOOL ssl = [[APPDELEGATE readUserObjForKey:SecureTransportKey] boolValue];
    if(ssl) {
        [dic setObject:@"1" forKey:@"ssl"];
    } else {
        [dic setObject:@"0" forKey:@"ssl"];
    }
    
    [_client sendMessage:dic result:^(ServerResult *result) {
        dispatch_async(MAINQ, ^{
            [_delegate WaitViewStop];
        });
        if([result.cmdStr isEqualToString:@"login"]) {

     
            if(result.retCode) {
                dispatch_async(MAINQ, ^{
                    [_delegate openMainViewController:result.loginDic];
                });

            } else {
  
                [_client closeSocketConnection];
            }
        } else {

            if([result.cmdStr isEqualToString:@"raw"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginWelcomeToLanguageKey object:nil userInfo:@{@"message":result.messageStr}];
            }
        }
    }];
}



- (void)requestCmdStr:(NSString *)cmdStr {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"raw" forKey:@"cmd"];
    [dic setObject:cmdStr forKey:@"data"];
    
   

    
    [_client sendMessage:dic result:^(ServerResult *result) {
//        self.topMiddleLabel.attributedText = _topMiddleAttrStr;
        dispatch_async(MAINQ, ^{
            [_delegate WaitViewStop];
        });
        if([result.cmdStr isEqualToString:@"raw"]) {
//            [self showContentText:result.messageStr];
        }
    }];
}




@end
