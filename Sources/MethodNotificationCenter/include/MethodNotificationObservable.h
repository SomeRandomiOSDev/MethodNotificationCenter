//
//  MethodNotificationObservable.h
//  MethodNotificationCenter
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodNotificationObservable: NSObject

- (instancetype)invalidateOnDealloc;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
