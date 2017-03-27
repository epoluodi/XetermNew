//
//  CoreServer.h
//  Xeterm
//  网络交互控制类
//  Created by Stereo on 2017/3/27.
//  Copyright © 2017年 klwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketClient.h"

@protocol CoreServerDelegate

-(void)PayResult:(Boolean)on;
-(void)WaitViewStop;
-(void)openMainViewController:(NSDictionary *)loginDic;
@end
@interface CoreServer : NSObject
{

}

//设定sock类
@property (weak,nonatomic)SocketClient *client;
@property (weak,nonatomic)NSObject<CoreServerDelegate> * delegate;
@property (weak,nonatomic)NSString *serverAddress;
@property (weak,nonatomic)NSString *serverPort;
@property (weak,nonatomic)NSString *userName;
@property (weak,nonatomic)NSString *userPwd;
@property (weak,nonatomic)NSString *appVer;
//请求DNS
- (void)requestNDS;
@end
