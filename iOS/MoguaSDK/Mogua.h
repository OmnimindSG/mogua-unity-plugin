//
//  Mogua.h
//  MoguaSDK-OBJC
//
//  Created by Shaowen Su on 2024/8/1.
//

#ifndef Mogua_h
#define Mogua_h

#import <Foundation/Foundation.h>
#import "MoguaCallback.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mogua : NSObject

/// Initialize the MoguaSDK.
/// - Parameters:
///   - appKey: The App Key associated with this application, available on the dashboard at www.mogua.io.
///   - allowPasteboardAccess: A Boolean value indicating whether to allow access to the clipboard. Enabling this feature can enhance accuracy but may trigger permission warnings on certain systems.
+ (void)initWithAppKey:(NSString *)appKey allowPasteboardAccess:(BOOL)allowPasteboardAccess;

/// Retrieves data associated with app installation events, allowing the app to respond to deferred deep linking.
/// - Warning: Make sure to initialize the MoguaSDK before calling this method.
/// - Parameters:
///   - callback: A `MoguaCallback` object that contains the `onData` and `onError` closures to handle the retrieved data or any errors.
+ (void)getInstallData:(MoguaCallback *)callback;

/// Retrieves data associated with app opening (e.g., resume or become active from background) events, allowing the app to respond to direct deep linking.
/// - Warning: Make sure to initialize the MoguaSDK before calling this method.
/// - Parameters:
///   - callback: A `MoguaCallback` object that contains the `onData` and `onError` closures to handle the retrieved data or any errors.
+ (void)getOpenData:(MoguaCallback *)callback;

/// Handles URLs when the app is activated.
/// - Note: Calling this method and pass the `URL` within `application:handleOpenURL:` or `application:openURL:sourceApplication:annotation` methods.
/// - Parameters:
///   - url: The `URL` provided by the `UIApplicationDelegate` protocol.
/// - Returns: A `Boolean` value indicating whether the handling was successful.
+ (BOOL)handleOpenUrl:(NSURL *)url;

/// Handles Universal Links passed when the app is activated via NSUserActivity.
/// - Note: Calling this method and pass the `NSUserActivity` within `application:continueUserActivity:restorationHandler`
/// - Parameters:
///   - userActivity: The `NSUserActivity` provided by the `UIApplicationDelegate` protocol.
/// - Returns: A `Boolean` value indicating whether the handling was successful.
+ (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

@end

NS_ASSUME_NONNULL_END

#endif /* Mogua_h */
