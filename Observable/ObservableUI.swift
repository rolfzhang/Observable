//
//  ObservableUI.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import UIKit

public class ObservableUI<O: UIControl, V>: NSObject, ObservableEditableType {
    public typealias T = V
    public typealias Getter = O->T?
    public typealias Setter = (O, T?) throws ->()
    public typealias NotNilSetter = (O, T) throws ->()
    
    public let observers: NSMutableArray = []
    
    weak var source: O?
    var event: UIControlEvents!
    private var get: Getter!
    private var set: Setter?
    
    public init(_ source: O, _ event: UIControlEvents, get: Getter, set: Setter? = nil) {
        super.init()
        
        self.source = source
        self.event = event
        self.get = get
        self.set = set
        
        source.addTarget(self, action: #selector(onEvent), forControlEvents: event)
        source.observables[event.rawValue] = self
    }
    
    public convenience init(_ source: O, _ event: UIControlEvents, get: Getter, setNotNil: NotNilSetter) {
        self.init(
            source, event,
            get: get,
            set: {
                guard let newValue = $1 else {
                    throw ObservableError
                }
                try setNotNil($0, newValue)
            })
    }
    
    public func value() -> T? {
        if let object = source {
            return get(object)
        }
        return nil
    }
    
    public func setValue(value: T?) {
        if let source = source, let set = set {
            do {
                try set(source, value)
                self.notify()
            } catch {}
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

extension UITextField {
    public func o_text(event: UIControlEvents = .EditingChanged) -> ObservableUI<UITextField, String> {
        return ObservableUI(self, event,
                            get: { return $0.text },
                            set: { $0.text = $1 })
    }
}

extension UISlider {
    public func o_value(event: UIControlEvents = .EditingChanged) -> ObservableUI<UISlider, Float> {
        return ObservableUI(self, event,
                            get: { return $0.value },
                            setNotNil: { $0.setValue($1, animated: true) })
    }
}

extension UIStepper {
    public func o_value(event: UIControlEvents = .EditingChanged) -> ObservableUI<UIStepper, Double> {
        return ObservableUI(self, event,
                            get: { return $0.value },
                            setNotNil: { $0.value = $1 })
    }
}

extension UISwitch {
    public func o_on(event: UIControlEvents = .EditingChanged) -> ObservableUI<UISwitch, Bool> {
        return ObservableUI(self, event,
                            get: { return $0.on },
                            setNotNil: { $0.setOn($1, animated: true) })
    }
}

