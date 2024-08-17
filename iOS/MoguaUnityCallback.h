//
// Created by Mogua.
// Copyright © 2024 Mogua. All rights reserved.
//

#ifndef MOGUA_UNITY_CALLBACK_H
#define MOGUA_UNITY_CALLBACK_H

#import "MoguaSDK/MoguaCallback.h"

@interface MoguaUnityCallback : MoguaCallback

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOnData:(DataCallback)onData onError:(ErrorCallback)onError NS_UNAVAILABLE;

+ (instancetype)sharedInstallCallback;
+ (instancetype)sharedOpenCallback;

@end

#endif //MOGUA_UNITY_CALLBACK_H
