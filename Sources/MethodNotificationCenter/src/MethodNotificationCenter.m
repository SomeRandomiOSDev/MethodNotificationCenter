//
//  MethodNotificationCenter.m
//  MethodNotificationCenter
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import "MethodNotificationCenter.h"
#import "MethodNotificationObservable.h"
#import "MethodNotification.h"

#import <dispatch/dispatch.h>
#import <objc/runtime.h>

#if !OBJC_OLD_DISPATCH_PROTOTYPES
extern void _mnc_msgForward(void);
#else
extern id _mnc_msgForward(id, SEL, ...);
#endif

#pragma mark - MethodNotificationObservable Extension

@interface MethodNotificationObservable()

@property (nonatomic, weak, nullable, readonly) id object;
@property (nonatomic, assign, readonly)         SEL selector;
@property (nonatomic, strong, readonly)         void (^callback)(MethodNotification *);

- (instancetype)initWithObject:(id)object selector:(SEL)selector callback:(void (^)(MethodNotification *))callback;

@end

#pragma mark - MethodNotificationCenter Implementation

@implementation MethodNotificationCenter

#pragma mark Static Properties

static NSMutableDictionary<NSString *, NSMutableArray<MethodNotificationObservable *> *> *_observables;
static dispatch_queue_t _synchronizationQueue;

#pragma mark Initialization

+ (void)initialize {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _observables = [NSMutableDictionary dictionary];
        _synchronizationQueue = dispatch_queue_create("com.somerandomiosdev.methodnotificationcenter.syncqueue", DISPATCH_QUEUE_SERIAL);
    });
}

#pragma mark Public Methods

+ (id)addObserverForSelector:(SEL)selector object:(__kindof NSObject *)object callback:(void (^)(MethodNotification *))callback {
    MethodNotificationObservable * const observable = [[MethodNotificationObservable alloc] initWithObject:object selector:selector callback:callback];

    dispatch_sync(_synchronizationQueue, ^{
        Class const originalClass = object_getClass(object);
        NSString* const newClassName = [self newClassNameForObject:object];
        NSMutableArray<MethodNotificationObservable *> *registeredObservables = _observables[newClassName];
        Class newClass;

        if (registeredObservables != nil && registeredObservables.count > 0) {
            newClass = objc_getRequiredClass(newClassName.UTF8String);
            BOOL selectorIsRegistered = NO;

            for (MethodNotificationObservable *observable in registeredObservables) {
                if (sel_isEqual(observable.selector, selector)) {
                    selectorIsRegistered = (class_getInstanceMethod(newClass, selector) != NULL);
                    break;
                }
            }

            if (!selectorIsRegistered)
                class_addMethod(newClass, selector, (IMP)_mnc_msgForward, method_getTypeEncoding(class_getInstanceMethod(originalClass, selector)));
        } else {
            registeredObservables = [NSMutableArray array];
            _observables[newClassName] = registeredObservables;

            newClass = objc_allocateClassPair(originalClass, newClassName.UTF8String, 0);

            void (^ const forwardInvocation)(id, NSInvocation *) = ^(id _self, NSInvocation *invocation) {
                __block NSArray<void (^)(MethodNotification *)> *registeredCallbacks = nil;
                dispatch_sync(_synchronizationQueue, ^{
                    registeredCallbacks = [MethodNotificationCenter callbacksForInvocation:invocation toObject:_self];
                });

                if (registeredCallbacks != nil) {
                    MethodNotification *notification = [[MethodNotification alloc] initWithObject:_self selector:selector isPriorToMethodCall:YES];
                    for (void (^callback)(MethodNotification *) in registeredCallbacks) {
                        callback(notification);
                    }

                    object_setClass(_self, originalClass);
                    [invocation invoke];
                    object_setClass(_self, newClass);

                    notification = [[MethodNotification alloc] initWithObject:_self selector:selector isPriorToMethodCall:NO];
                    for (void (^callback)(MethodNotification *) in registeredCallbacks) {
                        callback(notification);
                    }
                }
            };

            IMP forwardInvocationImp = imp_implementationWithBlock(forwardInvocation);
            class_addMethod(newClass, @selector(forwardInvocation:), forwardInvocationImp, method_getTypeEncoding(class_getInstanceMethod(originalClass, @selector(forwardInvocation:))));

            class_addMethod(newClass, selector, (IMP)_mnc_msgForward, method_getTypeEncoding(class_getInstanceMethod(originalClass, selector)));

            objc_registerClassPair(newClass);
        }

        object_setClass(object, newClass);
        [registeredObservables addObject:observable];
    });

    return observable;
}

+ (void)removeObserver:(id)observer {
    if (observer == nil || ![observer isKindOfClass:MethodNotificationObservable.class])
        return;

    __strong id observedObject = ((MethodNotificationObservable *)observer).object;
    Class const observedObjectClass = object_getClass(observedObject);
    NSString * const className = NSStringFromClass(observedObjectClass);

    if (observedObject == nil || ![className containsString:@"mnc_observer_class"])
        return;

    dispatch_sync(_synchronizationQueue, ^{
        NSMutableArray<MethodNotificationObservable *> * const registeredObservables = _observables[className];

        if (registeredObservables != nil) {
            __block NSUInteger index = NSNotFound;

            [registeredObservables enumerateObjectsUsingBlock:^(MethodNotificationObservable *registeredObservable, NSUInteger i, BOOL *stop) {
                if (registeredObservable == observer) {
                    index = i;
                    *stop = YES;
                }
            }];

            if (index != NSNotFound) {
                [registeredObservables removeObjectAtIndex:index];
                object_setClass(observedObject, class_getSuperclass(object_getClass(observedObject)));
            }

            if (registeredObservables.count == 0) {
                [_observables removeObjectForKey:className];

                IMP const forwardInvocationBlock = class_getMethodImplementation(observedObjectClass, @selector(forwardInvocation:));
                imp_removeBlock(forwardInvocationBlock);

                if (object_getClass(observedObject) != observedObjectClass)
                    objc_disposeClassPair(observedObjectClass);
            }
        }
    });
}

#pragma mark Private Methods

+ (NSArray<void (^)(MethodNotification *)> *)callbacksForInvocation:(NSInvocation *)invocation toObject:(id)object {
    NSString * const className = [NSString stringWithUTF8String:object_getClassName(object)];
    NSArray<MethodNotificationObservable *> * const obserables = _observables[className];

    NSMutableArray<void (^)(MethodNotification *)> * const callbacks = [NSMutableArray arrayWithCapacity:obserables.count];
    for (MethodNotificationObservable *observable in obserables) {
        if (observable.object == object && sel_isEqual(observable.selector, invocation.selector)) {
            [callbacks addObject:observable.callback];
        }
    }

    return callbacks.count > 0 ? [callbacks copy] : nil;
}

+ (NSString *)newClassNameForObject:(id)object {
    const char *originalClassName = object_getClassName(object);
    NSString *newClassName;

    if ([[NSString stringWithUTF8String:originalClassName] containsString:@"__mnc_observer_class"])
        return [NSString stringWithUTF8String:originalClassName];

    if (strncmp(originalClassName, "_TtC", 4) == 0) { // Swift Class
        const char *className = originalClassName + 4, *end = originalClassName + strlen(originalClassName);
        const char *lastComponent = className;
        const char *leadingComponents = className;

        while (className < end) {
            while (!isdigit(*className) && className != end)
                className++;
            if (className == end)
                break;

            leadingComponents = className;

            unsigned int componentLength = 0;
            while (isdigit(*className) && className != end) {
                componentLength = (componentLength * 10) + (*className - '0');
                className++;
            }

            lastComponent = className;
            className += componentLength;
        }

        if (lastComponent != (originalClassName + 4)) {
            NSString *classComponentName = [NSString stringWithFormat:@"__mnc_observer_class_%s", lastComponent];
            NSString *classComponentPrefix = [[NSString stringWithUTF8String:originalClassName] substringToIndex:(leadingComponents - originalClassName)];

            newClassName = [NSString stringWithFormat:@"%@%lu%@", classComponentPrefix, (unsigned long)classComponentName.length, classComponentName];
        } else {
            newClassName = [NSString stringWithFormat:@"__mnc_observer_class_%s", originalClassName];
        }
    } else {
        NSString * const className = [NSString stringWithUTF8String:originalClassName];
        NSMutableArray<NSString *> * const classComponents = [NSMutableArray arrayWithArray:[className componentsSeparatedByString:@"."]];

        if (classComponents.count > 1) {
            classComponents[classComponents.count - 1] = [NSString stringWithFormat:@"__mnc_observer_class_%@", classComponents[classComponents.count - 1]];
            newClassName = [classComponents componentsJoinedByString:@"."];
        } else {
            newClassName = [NSString stringWithFormat:@"__mnc_observer_class_%s", originalClassName];
        }
    }

    return newClassName;
}

@end
