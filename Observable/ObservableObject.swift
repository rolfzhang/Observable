//
//  ObservableObject.swift
//  Observable
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import UIKit

public class ObservableEvent {
    
}

public class ObservableTextField: ObservableType {
    public typealias T = String
    public let observers: NSMutableArray = []
    
    weak var field: UITextField?
    
    
    public init(field: UITextField) {
        self.field = field
        
        field.addTarget(self, action: #selector(onEvent), forControlEvents: .EditingChanged)
    }
    
    public func value() -> T? {
        return field?.text
    }
 
    @objc func onEvent() {
        notify()
    }
}
