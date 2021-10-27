//
//  MethodNotificationCenterSwiftTests.swift
//  MethodNotificationCenterTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import MethodNotificationCenter
import XCTest

// MARK: - MethodNotificationCenterSwiftTests Definition

class MethodNotificationCenterSwiftTests: XCTestCase {

    // MARK: Test Methods

    func testReceivingNotifications1() {
        let test = TestClass1()
        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)

        MethodNotificationCenter.removeObserver(observer)
    }

    func testReceivingNotifications2() {
        let test = TestClass2()
        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)

        MethodNotificationCenter.removeObserver(observer)
    }

    func testReceivingNotifications3() {
        let test = TestClass3()
        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)

        MethodNotificationCenter.removeObserver(observer)
    }

    func testSameNotificationsOfDifferentObjects() {
        let test = TestClass1()
        let test2 = TestClass1()

        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }
        let observer2 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test2) { notification in
            XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 0 : 2))
            test2.value += 1
        }

        XCTAssertEqual(test.value, 0)
        XCTAssertEqual(test2.value, 0)
        test.perform(#selector(TestClass1.increment))
        test2.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        // test2.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)
        XCTAssertEqual(test2.value, 3)

        MethodNotificationCenter.removeObserver(observer)
        MethodNotificationCenter.removeObserver(observer2)
    }

    func testMultipleNotificationsOnSameObject() {
        let test = TestClass1()

        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }
        let observer2 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.incrementBy2), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 6))
            test.value += 1
        }

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)
        test.perform(#selector(TestClass1.incrementBy2))
        // test.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 7)
        MethodNotificationCenter.removeObserver(observer2)
        test.perform(#selector(TestClass1.incrementBy2))
        // test.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 9)
        MethodNotificationCenter.removeObserver(observer)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 10)
    }

    func testMultipleNotificationsOnDifferentObjects() {
        let test = TestClass1()
        let test2 = TestClass1()

        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }
        let observer2 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.incrementBy2), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 6))
            test.value += 1
        }
        let observer3 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test2) { notification in
            XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 0 : 2))
            test2.value += 1
        }
        let observer4 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.incrementBy2), object: test2) { notification in
            XCTAssertEqual(test2.value, (notification.isPriorToMethodCall ? 3 : 6))
            test2.value += 1
        }

        XCTAssertEqual(test.value, 0)
        XCTAssertEqual(test2.value, 0)
        test.perform(#selector(TestClass1.increment))
        test2.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        // test2.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)
        XCTAssertEqual(test2.value, 3)
        test.perform(#selector(TestClass1.incrementBy2))
        test2.perform(#selector(TestClass1.incrementBy2))
        // test.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        // test2.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 7)
        XCTAssertEqual(test2.value, 7)
        MethodNotificationCenter.removeObserver(observer2)
        MethodNotificationCenter.removeObserver(observer4)
        test.perform(#selector(TestClass1.incrementBy2))
        test2.perform(#selector(TestClass1.incrementBy2))
        // test.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        // test2.incrementBy2() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 9)
        XCTAssertEqual(test2.value, 9)
        MethodNotificationCenter.removeObserver(observer)
        MethodNotificationCenter.removeObserver(observer3)
        test.perform(#selector(TestClass1.increment))
        test2.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        // test2.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 10)
        XCTAssertEqual(test2.value, 10)
    }

    func testDuplicateNotificationsOnSameObject() {
        let test = TestClass1()

        let observer = MethodNotificationCenter.addObserver(for: #selector(TestClass1.noop), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 4))
            test.value += 1
        }
        let observer2 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.noop), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 1 : 5))
            test.value += 1
        }
        let observer3 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.noop), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 2 : 6))
            test.value += 1
        }
        let observer4 = MethodNotificationCenter.addObserver(for: #selector(TestClass1.noop), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 3 : 7))
            test.value += 1
        }

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.noop))
        // test.noop() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 8)

        MethodNotificationCenter.removeObserver(observer)
        MethodNotificationCenter.removeObserver(observer2)
        MethodNotificationCenter.removeObserver(observer3)
        MethodNotificationCenter.removeObserver(observer4)
    }

    func testInvalidateObserverOnDealloc() {
        let test = TestClass1()
        let unmanagedObserver = Unmanaged.passUnretained(MethodNotificationCenter.addObserver(for: #selector(TestClass1.increment), object: test) { notification in
            XCTAssertEqual(test.value, (notification.isPriorToMethodCall ? 0 : 2))
            test.value += 1
        }
        .invalidateOnDealloc())

        XCTAssertEqual(test.value, 0)
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 3)
        unmanagedObserver.release() // causes observer to be overreleased, but that's okay for our unit testing
        test.perform(#selector(TestClass1.increment))
        // test.increment() // Can't call directly in Swift as the complier will skip the ObjC runtime and call the Swift function directly
        XCTAssertEqual(test.value, 4)
    }
}

// MARK: - TestClass1 Definition

@objc class TestClass1: NSObject {
    var value: Int = 0

    @objc func increment() {
        value += 1
    }
    @objc func incrementBy2() {
        value += 2
    }
    @objc func noop() {
        /* Nothing to do */
    }
}

// MARK: - TestClass2 Definition

@objc class TestClass2: NSObject {
    var value: Int = 0

    @objc func increment() {
        value += 1
    }
}

// MARK: - TestClass3 Definition

@objc class TestClass3: NSObject {
    var value: Int = 0

    @objc func increment() {
        value += 1
    }
}
