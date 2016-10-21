//
//  ObservableObject.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import UIKit

public class ObservableUI<O: UIControl, V>: NSObject, ObservableEditableType {
    public typealias T = V
    public let observers: NSMutableArray = []
    
    weak var source: O?
    var event: UIControlEvents!
    private var get: (O->T?)!
    private var set: ((O, V?)->())?
    
    public init(_ source: O, _ event: UIControlEvents, get: O->T?, set: ((O, V?)->())? = nil) {
        super.init()
        
        self.source = source
        self.event = event
        self.get = get
        self.set = set
        
        source.addTarget(self, action: #selector(onEvent), forControlEvents: event)
        source.observables[event.rawValue] = self
    }
    
    public func value() -> T? {
        if let object = source {
            return get(object)
        }
        return nil
    }
    
    public func setValue(value: T?) {
        if let source = source, let set = set {
            set(source, value)
            self.notify()
        }
    }
    
    public func detach() {
        source?.observables[event.rawValue] = nil
    }
    
    @objc private func onEvent() {
        notify()
    }
}

extension UIControl {
    var observables: NSMutableDictionary {
        get {
            let key = "observables"
            
            if let observables = objc_getAssociatedObject(self, key) as? NSMutableDictionary {
                return observables
            }
            else {
                let observables = NSMutableDictionary()
                objc_setAssociatedObject(self, key, observables, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return observables
            }
        }
    }
}

