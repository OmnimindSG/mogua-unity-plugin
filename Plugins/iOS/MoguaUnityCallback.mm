//
// Created by Mogua.
// Copyright © 2024 Mogua. All rights reserved.
//

#import "MoguaUnityCallback.h"
#import "Unity/UnityInterface.h"

static const char* UnityObject = "Mogua";

@interface MoguaUnityCallback ()

@property (nonatomic, copy) NSString *onDataMethod;
@property (nonatomic, copy) NSString *onErrorMethod;
@property (nonatomic, assign) BOOL readyToSend;
@property (nonatomic, strong) NSDictionary<NSString *, id> *pendingData;
@property (nonatomic, strong) NSError *pendingError;

- (instancetype)initWithOnDataMethod:(NSString *)onDataMethod onErrorMethod:(NSString *)onErrorMethod;

- (NSString *)dictionaryToQueryParameters:(NSDictionary *)dict;
- (void)sendDataMessage:(NSDictionary<NSString *, id> *)data;
- (void)sendErrorMessage:(NSError *)error;
- (void)sendPendingMessage;

@end

@implementation MoguaUnityCallback

- (instancetype)initWithOnDataMethod:(NSString *)onDataMethod onErrorMethod:(NSString *)onErrorMethod {
    if (self = [super initWithOnData:^(NSDictionary<NSString *, id> * _Nonnull data) {
        if (self->_readyToSend) {
            [self sendDataMessage:data];
        } else {
            self->_pendingData = data;
        }
    } onError:^(NSError * _Nonnull error) {
        if (self->_readyToSend) {
            [self sendErrorMessage:error];
        } else {
            self->_pendingError = error;
        }
    }]) {
        self.onDataMethod = onDataMethod;
        self.onErrorMethod = onErrorMethod;
        self.readyToSend = NO;
    }
    return self;
}

- (NSString *)dictionaryToQueryParameters:(NSDictionary *)dict {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in dict) {
        NSString *value = [dict[key] description];
        NSCharacterSet *chars = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:chars];
        NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:chars];
        encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        encodedValue = [encodedValue stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *item = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        [items addObject:item];
    }
    return [items componentsJoinedByString:@"&"];
}

- (void)sendDataMessage:(NSDictionary<NSString *, id> *)data {
    NSString *queryParameters = [self dictionaryToQueryParameters:data];
    UnitySendMessage(UnityObject, [_onDataMethod UTF8String], [queryParameters UTF8String]);
}

- (void)sendErrorMessage:(NSError *)error {
    UnitySendMessage(UnityObject, [_onErrorMethod UTF8String], [[error description] UTF8String]);
}

- (void)sendPendingMessage {
    if (_pendingData) {
        [self sendDataMessage:_pendingData];
        self.pendingData = nil;
    } else if (_pendingError) {
        [self sendErrorMessage:_pendingError];
        self.pendingError = nil;
    }
}

+ (instancetype)sharedInstallCallback {
    static MoguaUnityCallback *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithOnDataMethod:@"InstallOnData" onErrorMethod:@"InstallOnError"];
    });
    return sharedInstance;
}

+ (instancetype)sharedOpenCallback {
    static MoguaUnityCallback *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithOnDataMethod:@"OpenOnData" onErrorMethod:@"OpenOnError"];
    });
    return sharedInstance;
}

@end

extern "C" {
    void _GetInstallData() {
        MoguaUnityCallback *callback = [MoguaUnityCallback sharedInstallCallback];
        callback.readyToSend = YES;
        [callback sendPendingMessage];
    }
}

extern "C" {
    void _GetOpenData() {
        MoguaUnityCallback *callback = [MoguaUnityCallback sharedOpenCallback];
        callback.readyToSend = YES;
        [callback sendPendingMessage];
    }
}

