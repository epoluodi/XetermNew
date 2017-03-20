//
//  SocketClient.m
//  GCD_Socket_Demo
//
//  Created by Klwy on 16/10/19.
//  Copyright © 2016年 Klwy. All rights reserved.
//

#import "SocketClient.h"

static SocketClient *socketClientManager = nil;

@interface SocketClient () <GCDAsyncSocketDelegate>
{
    NSMutableData *_muData;
    NSMutableString *_muStr;
    NSInteger _muDataCount;
}

@property (nonatomic, strong, readonly) GCDAsyncSocket *socket;
@property (nonatomic, copy) Result result;
@property (nonatomic, copy) LinkState linkSuccess;     // 连接成功
@property (nonatomic, copy) LinkState linkFailure;     // 连接失败，分为正常断开和连接失败
@property (nonatomic, copy) LinkState sendState;        // 发送状态
@end

@implementation SocketClient

- (instancetype)init {
    if(self = [super init]) {
        
        _muData = [NSMutableData data];
        _muDataCount = 0;
        _isShowAlert = NO;
        _host = @"dns.51eterm.cn";
        _port = @"350";
        _muStr = [NSMutableString string];
        
        //        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        //连接
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return self;
}

+ (instancetype)shareSocketShareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(socketClientManager == nil) {
            socketClientManager = [[self alloc] init];
        }
    });
    
    return socketClientManager;
}

- (void)createSocketConnectionWithHost:(NSString *)host port:(NSString *)port success:(LinkState)success failure:(LinkState)failure {

    _linkSuccess = nil;
    _linkSuccess = success;

    _linkFailure = nil;
    _linkFailure = failure;

    
    if(_socket.isConnected) {
        [_socket disconnect];
    }

    [_socket connectToHost:host onPort:[port integerValue] error:nil];
    [_socket readDataWithTimeout:-1 tag:0];
    
}

- (void)createSocketConnectionSuccess:(LinkState)success failure:(LinkState)failure {
    
    [self createSocketConnectionWithHost:_host port:_port success:success failure:failure];
}


- (NSString *)paramStringWithDic:(NSDictionary *)dic {
    
    NSMutableString *muStr = [NSMutableString stringWithString:@"<x>"];
    for(NSString *key in dic.allKeys) {
        [muStr appendFormat:@"<%@>%@</%@>", key, dic[key], key];
    }
    [muStr appendString:@"</x>"];
    
//    NSLog(@"param = %@", muStr);
    
    return muStr;
}

- (NSData *)dataWithParamString:(NSString *)str {
    
    NSUInteger len = str.length;
    char *p_len = (char *)&len;
    char str_len[4] = {0};
    
    for(int i= 0 ;i < 4 ;i++) {
        str_len[i] = *p_len;
        p_len ++;
    }
    
//    NSLog(@"str = %s",str_len);
    
    NSMutableData *muData = [NSMutableData dataWithBytes:str_len length:4];
    [muData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    return muData;
}

- (void)sendMessage:(NSDictionary *)dic result:(Result)result {
    
    _sendState = nil;
    
    _result = nil;
    _result = result;
    
    [_socket writeData:[self dataWithParamString:[self paramStringWithDic:dic]] withTimeout:-1 tag:0];
    //发送完数据手动读取，-1不设置超时
    [_socket readDataWithTimeout:-1 tag:0];
}


- (void)sendMessage:(NSDictionary *)dic sendState:(LinkState)state {
    
    _sendState = nil;
    _sendState = state;
    
    [_socket writeData:[self dataWithParamString:[self paramStringWithDic:dic]] withTimeout:-1 tag:0];
    //发送完数据手动读取，-1不设置超时
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)sendFialureState {
    
    [_socket writeData:[self dataWithParamString:@"<x>200</x>"] withTimeout:-1 tag:0];
    //发送完数据手动读取，-1不设置超时
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)closeSocketConnection {
    
    _result = nil;
    _sendState = nil;
    
    if(_socket.isConnected) {
        [_socket disconnect];
    }
}

//int bytesToInt(Byte *bytes) {
//    
//    int addr = bytes[0] & 0xFF;
//    
//    addr |= ((bytes[1] << 8) & 0xFF00);
//    
//    addr |= ((bytes[2] << 16) & 0xFF0000);
//    
//    addr |= ((bytes[3] << 24) & 0xFF000000);
//    
//    return addr;
//}


#pragma mark - 读取成功
// 读取成功
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
        
//    NSLog(@"--0--data = %@", data);
    
    if(_muDataCount == 0 && _muData.length == 0) {
        
        NSData *intData = nil;
        
        if(data.length == 4) {
            intData = data;
            
        } else if(data.length > 4) {
            intData = [data subdataWithRange:NSMakeRange(0, 4)];
            data = [data subdataWithRange:NSMakeRange(4, data.length-4)];
            
            [_muData appendData:data];
        }
        
        int i;
        [intData getBytes: &i length: sizeof(i)];
        _muDataCount = i;
        
    } else {
        if(_muDataCount != _muData.length) {
            [_muData appendData:data];
        }
    }
    
    if(_muData.length == _muDataCount) {
        
        NSString *str = [[NSString alloc] initWithData:_muData encoding:NSUTF8StringEncoding];
//        NSLog(@"str = %@", str);
        
        _muData = [NSMutableData data];
        _muDataCount = 0;
        
        if(_result) {
            ServerResult *result = [[ServerResult alloc] initWithResult:str];
            _result(result);
            
            
            if([result.cmdStr isEqualToString:@"pop"]) {
                
                if(!_isShowAlert) {
                    _isShowAlert = YES;
                    [UIAlertView showMsgWithString:result.messageStr title:Normal_Alert_Text tapButtonActionBlocks:^(NSInteger buttonIndex) {
                        if(buttonIndex == 0) {
                            [self closeSocketConnection];
                            UIViewController *vc = [[[UIApplication sharedApplication] delegate] window].rootViewController;
                            [vc dismissViewControllerAnimated:YES completion:^{
                                _isShowAlert = NO;
                            }];
                        }
                    }];
                }
                
                
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:PopAlertInfoKey object:nil userInfo:@{@"message":result.messageStr}];
            } else if([result.cmdStr isEqualToString:@"dns"] ||
                      [result.cmdStr isEqualToString:@"login"]) {
                if(!result.retCode) {
                    [APPDELEGATE showAlertMessage:result.resultDic[@"ep"]];
                    [self sendFialureState];
                }
            }
            
            //            _muStr = [NSMutableString string];
        }
    }
    
    [sock readDataWithTimeout:-1 tag:tag];
}


#pragma mark - 发送成功
// 发送成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    if(_sendState) {
        _sendState(YES);
    }
    
    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark - 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    if(_linkSuccess) {
        _linkSuccess(YES);
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark - 断开连接

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    if(_linkFailure) {
        if (err) {
            // 链接失败
            _linkFailure(NO);
            
            if(!_isShowAlert) {
                
                _isShowAlert = YES;
                UIViewController *vc = [[[UIApplication sharedApplication] delegate] window].rootViewController;
                [self closeSocketConnection];
                
                if(vc.presentedViewController) {
                    
                    [UIAlertView showMsgWithString:@"服务器连接已断开，请重新登录。" title:@"提示" tapButtonActionBlocks:^(NSInteger buttonIndex) {
                        if(buttonIndex == 0) {
                            
                            
                            [vc dismissViewControllerAnimated:YES completion:^{
                                _isShowAlert = NO;
                            }];
                        }
                    }];
                } else {
                    
                    [UIAlertView showMsgWithString:@"链接服务器失败，请检查网络或你设置的服务器地址及端口..." title:@"登录失败" tapButtonActionBlocks:^(NSInteger buttonIndex) {
                        if(buttonIndex == 0) {
                            _isShowAlert = NO;
                        }
                    }];
                }
            }
        }else{
            // 正常断开
            _linkFailure(YES);
        }
    }
    
//    if (err) {
//        NSLog(@"连接失败");
//    }else{
//        NSLog(@"正常断开");
//    }
}




@end
