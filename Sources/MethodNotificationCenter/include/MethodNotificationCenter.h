//
//  MethodNotificationCenter.h
//  MethodNotificationCenter
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MethodNotification, MethodNotificationObservable;

@interface MethodNotificationCenter: NSObject

+ (MethodNotificationObservable *)addObserverForSelector:(SEL)selector object:(__kindof NSObject *)object callback:(void (^)(MethodNotification *))callback;
+ (void)removeObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
