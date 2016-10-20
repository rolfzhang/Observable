//
//  CombinedObservable.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import Foundation

protocol CombinedObservable: ObservableType, ObserverType {}

public class ObservableTwo<O1: ObservableType, O2: ObservableType>: NSObject, CombinedObservable {
    public typealias T = (O1.T?, O2.T?)
    public let observers: NSMutableArray = []
    
    weak var o1: O1?
    weak var o2: O2?
    
    public init(_ o1: O1, _ o2: O2) {
        self.o1 = o1
        self.o2 = o2
        
        super.init()
        
        attach()
        update()
    }
    
    public func value() -> T? {
        return (o1?.value(), o2?.value())
    }
    
    public func update() { notify() }
    
    public func attach() {
        o1?.addObserver(self)
        o2?.addObserver(self)
    }
    
    public func detach() {
        o1?.removeObserver(self)
        o2?.removeObserver(self)
    }
}

public class ObservableThree<O1: ObservableType, O2: ObservableType, O3: ObservableType>: NSObject, CombinedObservable {
    public typealias T = (O1.T?, O2.T?, O3.T?)
    public let observers: NSMutableArray = []
    
    weak var o1: O1?
    weak var o2: O2?
    weak var o3: O3?
    
    public init(_ o1: O1, _ o2: O2, _ o3: O3) {
        self.o1 = o1
        self.o2 = o2
        self.o3 = o3
        
        super.init()
        
        attach()
        update()
    }
    
    public func value() -> T? {
        return (o1?.value(), o2?.value(), o3?.value())
    }
    
    public func update() {
        notify()
    }
    
    public func attach() {
        o1?.addObserver(self)
        o2?.addObserver(self)
        o3?.addObserver(self)
    }
    
    public func detach() {
        o1?.removeObserver(self)
        o2?.removeObserver(self)
        o3?.removeObserver(self)
    }
}
