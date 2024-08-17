//
//  MoguaCallback.h
//  MoguaSDK-OBJC
//
//  Created by Shaowen Su on 2024/8/1.
//

#ifndef MoguaCallback_h
#define MoguaCallback_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoguaCallback : NSObject

typedef void (^DataCallback)(NSDictionary<NSString *, id> *data);
typedef void (^ErrorCallback)(NSError *error);

@property (nonatomic, copy) DataCallback onData;
@property (nonatomic, copy) ErrorCallback onError;

/// Initializes a `MoguaCallback` object with specified `onData` and `onError` callbacks.
/// This initializer is typically used in conjunction with the `getInstallData` or `getOpenData` methods to handle the retrieved data or any errors.
/// - Parameters:
///   - onData: Callback to handle the retrieved data (key-value pairs). Relevant statistics can be viewed on the dashboard at www.mogua.io.
///   - onError: Callback to handle any errors that occur.
- (instancetype)initWithOnData:(DataCallback)onData onError:(ErrorCallback)onError;

@end

NS_ASSUME_NONNULL_END

#endif /* MoguaCallback_h */
