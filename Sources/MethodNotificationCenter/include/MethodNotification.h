//
//  MethodNotification.h
//  MethodNotificationCenter
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodNotification: NSObject

@property (nonatomic, weak, readonly)   id object;
@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, assign, readonly) BOOL isPriorToMethodCall;

- (instancetype)initWithObject:(id)object selector:(SEL)selector isPriorToMethodCall:(BOOL)isPriorToMethodCall;

@end

NS_ASSUME_NONNULL_END
