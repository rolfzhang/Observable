//
//  ObservableMethods.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import Foundation

// MARK: - assignment

infix operator <- {}
public func <- <T>(left: Observable<T>, right: T?) {
    left.setValue(right)
}

public func <- <T>(inout left: T?, right: Observable<T>) {
    left = right.value()
}

// MARK: - bind

public func bind<V: AnyObject, T>(observer: V, _ subject: Observable<T>, handler: (V, T?)->()) -> ObserverType
{
    return Observer(observer, subject, handler: handler)
}

public func bind<V: AnyObject, O1: ObservableType, O2: ObservableType>(observer: V, _ o1: O1, _ o2: O2, handler: (V, O1.T?, O2.T?)->()) -> ObserverType
{
    return Observer(observer, ObservableTwo(o1, o2)) { v, t in
        handler(v, t?.0, t?.1)
    }
}

public func bind<V: AnyObject, O1: ObservableType, O2: ObservableType, O3: ObservableType>(observer: V, _ o1: O1, _ o2: O2, _ o3: O3, handler: (V, O1.T?, O2.T?, O3.T?)->()) -> ObserverType
{
    return Observer(observer, ObservableThree(o1, o2, o3)) { v, t in
        handler(v, t?.0, t?.1, t?.2)
    }
}

// MARK: - ObservableProperty

public func ObservableProperty(object: NSObject, property: String) -> Observable<AnyObject> {
    return Observable(get: { object.valueForKeyPath(property) },
                      set: { object.setValue($0, forKeyPath: property) })
}

public func ObservableProperty<T: AnyObject>(object: NSObject, property: String, type: T.Type) -> Observable<T> {
    return Observable(get: { object.valueForKeyPath(property) as? T },
                      set: { object.setValue($0, forKeyPath: property) })
}
