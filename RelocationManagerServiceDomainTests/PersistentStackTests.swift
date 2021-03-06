//
//  PersistentStackTestCase.swift
//  RelocationManagerServiceDomain
//
//  Created by Christian Tietze on 16.11.14.
//  Copyright (c) 2014 Christian Tietze. All rights reserved.
//

import Cocoa
import XCTest

import RelocationManagerServiceDomain

class TestPersistentStack: PersistentStack {
    init(storeURL: NSURL, modelURL: NSURL) {
        super.init(storeURL: storeURL, modelURL: modelURL, errorHandler: TestErrorHandler())
    }
    
    override func defaultStoreOptions() -> [String : String] {
        // Prevent iCloud usage (if set up in default options)
        return [String: String]()
    }
}

class PersistentStackTests: XCTestCase {
    let storeURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("test.sqlite"))
    lazy var persistentStack: TestPersistentStack = {
        let modelURL = NSBundle.mainBundle().URLForResource(kDefaultModelName, withExtension: "mom")
        return TestPersistentStack(storeURL: self.storeURL!, modelURL: modelURL!)
    }()
    
    override func tearDown() {
        if let storeURL: NSURL! = self.storeURL {
            var error: NSError?
            let success = NSFileManager.defaultManager().removeItemAtURL(storeURL!, error: &error)
            XCTAssertTrue(success, "couldn't clean  up test database file")
            //String(format: "couldn't clean  up test database file: %@", error!.localizedDescription));
        }
        
        super.tearDown()
    }
    
    func testInitializer() {
        XCTAssertNotNil(self.persistentStack, "Should have a persistent stack");
    }
    
    func testManagedObjectContextSetUp() {
        XCTAssertNotNil(self.persistentStack.managedObjectContext, "Should have a managed object context");
        XCTAssertNotNil(self.persistentStack.managedObjectContext?.persistentStoreCoordinator, "Should have a persistent store coordinator");
        let store: NSPersistentStore! = self.persistentStack.managedObjectContext?.persistentStoreCoordinator?.persistentStores[0] as! NSPersistentStore;
        XCTAssertNotNil(store, "Should have a persistent store");
        XCTAssertEqual(store.type, NSSQLiteStoreType, "Should be a sqlite store");
        XCTAssertNotNil(self.persistentStack.managedObjectContext?.undoManager, "Should have an undo manager");
    }
}
