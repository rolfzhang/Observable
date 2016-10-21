//
//  Observable.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import Foundation

public let ObservableError = NSError(domain: "ObservableError", code: 0, userInfo: nil)

public protocol ObserverType: NSObjectProtocol {
    func update()
    func attach()
    func detach()
}

public protocol ObservableType: class {
    associatedtype T
    
    var observers: NSMutableArray { get }
    
    func addObserver(observer: ObserverType)
    func removeObserver(observer: ObserverType)
    func notify()
    func value() -> T?
}

public protocol ObservableEditableType: ObservableType {
    func setValue(value: T?)
}

extension ObservableType {
    public func addObserver(observer: ObserverType) {
        if observers.containsObject(observers) == false {
            observers.addObject(observer)
        }
    }
    
    public func removeObserver(observer: ObserverType) {
        observers.removeObject(observer)
    }
    
    public func notify() {
        observers.forEach { (observer) in
            observer.update()
        }
    }
}

public class Observer<L: AnyObject, S: ObservableType>: NSObject, ObserverType {
    
    weak var listener: L?
    weak var source: S?
    var handler: (L, S.T?)->()
    
    public init(_ listener: L, _ source: S, handler: (L, S.T?)->()) {
        self.listener = listener
        self.handler = handler
        self.source = source
        
        super.init()
        
        attach()
        update()
    }
    
    public func update() {
        guard let observer = listener else {
            detach()
            return
        }
        
        handler(observer, source?.value())
    }
    
    public func attach() {
        if let o = source as? ObserverType {
            o.attach()
        }
        source?.addObserver(self)
    }
    
    public func detach() {
        if let o = source as? ObserverType {
            o.detach()
        }
        source?.removeObserver(self)
    }
}

public class Observable<O1>: ObservableEditableType {
    
    public typealias T = O1
    public typealias Getter = ()->T?
    public typealias Setter = (T?) throws ->()
    public typealias NotNilSetter = (T) throws ->()
    
    public let observers: NSMutableArray = []
    
    private var data: T?
    private var get: Getter?
    private var set: Setter?
    
    public init(get: Getter, set: Setter? = nil) {
        self.get = get
        self.set = set
    }
    
    public convenience init(get: Getter, setNotNil: NotNilSetter) {
        self.init(
            get: get,
            set: {
                guard let newValue = $0 else {
                    throw ObservableError
                }
                try setNotNil(newValue)
        })
    }
    
    public convenience init(_ value: T? = nil) {
        self.init(get: { nil })
        self.data = value
        
        weak var _self = self
        self.get = { return _self?.data }
        self.set = { _self?.data = $0 }
    }
    
    public func value() -> T? {
        return get?()
    }
    
    public func setValue(value: T?) {
        do {
            try set?(value)
            self.notify()
        } catch {}
    }
}
