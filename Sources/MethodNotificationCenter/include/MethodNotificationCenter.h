//
//  MethodNotificationCenter.h
//  MethodNotificationCenter
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MethodNotification.h"
#import "MethodNotificationObservable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MethodNotificationCenter: NSObject

+ (MethodNotificationObservable *)addObserverForSelector:(SEL)selector object:(__kindof NSObject *)object callback:(void (^)(MethodNotification *))callback;
+ (void)removeObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
