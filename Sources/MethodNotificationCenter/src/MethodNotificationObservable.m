//
//  MethodNotificationObservable.m
//  MethodNotificationCenter
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

#import "MethodNotificationObservable.h"
#import "MethodNotificationCenter.h"
#import "MethodNotification.h"

@interface MethodNotificationObservable() {
    BOOL _invalidateOnDealloc;
    BOOL _hasInvalidated;
}

@property (nonatomic, weak, nullable) id object;
@property (nonatomic, assign)         SEL selector;
@property (nonatomic, strong)         void (^callback)(MethodNotification *);

- (instancetype)initWithObject:(id)object selector:(SEL)selector callback:(void (^)(MethodNotification *))callback;

@end

#pragma mark - MethodNotificationObservable Implementation

@implementation MethodNotificationObservable

#pragma mark Property Synthesis

@synthesize object = _object, selector = _selector, callback = _callback;

#pragma mark Initialization

- (instancetype)initWithObject:(id)object selector:(SEL)selector callback:(void (^)(MethodNotification *))callback {
    if (self = [super init]) {
        _object              = object;
        _selector            = selector;
        _callback            = callback;
        _invalidateOnDealloc = NO;
        _hasInvalidated      = NO;
    }

    return self;
}

- (void)dealloc {
    if (_invalidateOnDealloc)
        [self invalidate];
}

#pragma mark Public Methods

- (instancetype)invalidateOnDealloc {
    _invalidateOnDealloc = YES;
    return self;
}

- (void)invalidate {
    if (!_hasInvalidated) {
        _hasInvalidated = YES;
        [MethodNotificationCenter removeObserver:self];
    }
}

@end
