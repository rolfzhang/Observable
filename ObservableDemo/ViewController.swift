//
//  ViewController.swift
//  ObservableDemo
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import UIKit
import Observable

func ObservableTextField(field: UITextField) -> ObservableObject<UITextField, String> {
    return ObservableObject(
        object: field,
        bind: { field, observable in
//            field.addTarget(observable,
//                action: #selector(observable.notify),
//                forControlEvents: .EditingChanged)
        },
        getValue: { return $0.text })
}

class ViewController: UIViewController {

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        bind(result, ObservableTextField(first), ObservableTextField(first), ObservableTextField(first)) { label, v1, v2, v3 in
            label.text = "\(v1!+v2!+v3!)"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

