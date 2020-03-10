//
//  MethodNotificationCenterTests.m
//  MethodNotificationCenterTests
//
//  Created by Joseph Newton on 3/7/20.
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MethodNotificationCenter;

@interface TestClass1: NSObject
@property (nonatomic, assign) NSInteger value;
- (void)increment;
- (void)incrementBy2;
- (void)noop;
@end

@interface MethodNotificationCenterTests : XCTestCase
@end

@implementation MethodNotificationCenterTests

- (void)testRecivingNotifications {
    TestClass1 *test = [[TestClass1 alloc] init];

    id observer = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2));
        test.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    [test increment];
    XCTAssertEqual(test.value, 3);

    [MethodNotificationCenter removeObserver:observer];
}

- (void)testSameNotificationsOfDifferentObjects {
    TestClass1 *test = [[TestClass1 alloc] init];
    TestClass1 *test2 = [[TestClass1 alloc] init];

    id observer = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2));
        test.value += 1;
    }];
    id observer2 = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test2 callback:^(MethodNotification *notification) {
        XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 0 : 2));
        test2.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    XCTAssertEqual(test2.value, 0);
    [test increment];
    [test2 increment];
    XCTAssertEqual(test.value, 3);
    XCTAssertEqual(test2.value, 3);

    [MethodNotificationCenter removeObserver:observer];
    [MethodNotificationCenter removeObserver:observer2];
}

- (void)testMultipleNotificationsOnSameObject {
    TestClass1 *test = [[TestClass1 alloc] init];

    id observer = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2));
        test.value += 1;
    }];
    id observer2 = [MethodNotificationCenter addObserverForSelector:@selector(incrementBy2) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 6));
        test.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    [test increment];
    XCTAssertEqual(test.value, 3);
    [test incrementBy2];
    XCTAssertEqual(test.value, 7);
    [MethodNotificationCenter removeObserver:observer2];
    [test incrementBy2];
    XCTAssertEqual(test.value, 9);
    [MethodNotificationCenter removeObserver:observer];
    [test increment];
    XCTAssertEqual(test.value, 10);
}

- (void)testMultipleNotificationsOnDifferentObjects {
    TestClass1 *test = [[TestClass1 alloc] init];
    TestClass1 *test2 = [[TestClass1 alloc] init];

    id observer = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2));
        test.value += 1;
    }];
    id observer2 = [MethodNotificationCenter addObserverForSelector:@selector(incrementBy2) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 6));
        test.value += 1;
    }];
    id observer3 = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test2 callback:^(MethodNotification *notification) {
        XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 0 : 2));
        test2.value += 1;
    }];
    id observer4 = [MethodNotificationCenter addObserverForSelector:@selector(incrementBy2) object:test2 callback:^(MethodNotification *notification) {
        XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 3 : 6));
        test2.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    XCTAssertEqual(test2.value, 0);
    [test increment];
    [test2 increment];
    XCTAssertEqual(test.value, 3);
    XCTAssertEqual(test2.value, 3);
    [test incrementBy2];
    [test2 incrementBy2];
    XCTAssertEqual(test.value, 7);
    XCTAssertEqual(test2.value, 7);
    [MethodNotificationCenter removeObserver:observer2];
    [MethodNotificationCenter removeObserver:observer4];
    [test incrementBy2];
    [test2 incrementBy2];
    XCTAssertEqual(test.value, 9);
    XCTAssertEqual(test2.value, 9);
    [MethodNotificationCenter removeObserver:observer];
    [MethodNotificationCenter removeObserver:observer3];
    [test increment];
    [test2 increment];
    XCTAssertEqual(test.value, 10);
    XCTAssertEqual(test2.value, 10);
}

- (void)testDuplicateNotificationsOnSameObject {
    TestClass1 *test = [[TestClass1 alloc] init];

    id observer = [MethodNotificationCenter addObserverForSelector:@selector(noop) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 4));
        test.value += 1;
    }];
    id observer2 = [MethodNotificationCenter addObserverForSelector:@selector(noop) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 1 : 5));
        test.value += 1;
    }];
    id observer3 = [MethodNotificationCenter addObserverForSelector:@selector(noop) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 2 : 6));
        test.value += 1;
    }];
    id observer4 = [MethodNotificationCenter addObserverForSelector:@selector(noop) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 7));
        test.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    [test noop];
    XCTAssertEqual(test.value, 8);

    [MethodNotificationCenter removeObserver:observer];
    [MethodNotificationCenter removeObserver:observer2];
    [MethodNotificationCenter removeObserver:observer3];
    [MethodNotificationCenter removeObserver:observer4];
}

- (void)testInvalidateObserver {
    TestClass1 *test = [[TestClass1 alloc] init];

    MethodNotificationObservable *observer = [MethodNotificationCenter addObserverForSelector:@selector(increment) object:test callback:^(MethodNotification *notification) {
        XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2));
        test.value += 1;
    }];

    XCTAssertEqual(test.value, 0);
    [test increment];
    XCTAssertEqual(test.value, 3);
    [observer invalidate];
    [test increment];
    XCTAssertEqual(test.value, 4);
}

@end

@implementation TestClass1

@synthesize value = _value;

- (void)increment {
    _value += 1;
}

- (void)incrementBy2 {
    _value += 2;
}

- (void)noop { /* Nothing to do */ }

@end
