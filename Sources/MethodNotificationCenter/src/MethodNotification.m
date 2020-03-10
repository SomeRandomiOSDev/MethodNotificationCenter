//
//  MethodNotification.m
//  MethodNotificationCenter
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

#import "MethodNotification.h"

#pragma mark - MethodNotification Implementation

@implementation MethodNotification

#pragma mark Property Synthesis

@synthesize object = _object, selector = _selector, isPriorToMethodCall = _isPriorToMethodCall;

#pragma mark Initialization

- (instancetype)initWithObject:(id)object selector:(SEL)selector isPriorToMethodCall:(BOOL)isPriorToMethodCall {
    if (self = [super init]) {
        _object              = object;
        _selector            = selector;
        _isPriorToMethodCall = isPriorToMethodCall;
    }

    return self;
}

@end
