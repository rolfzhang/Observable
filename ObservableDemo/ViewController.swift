//
//  ViewController.swift
//  ObservableDemo
//
//  Created by Rolf on 2016/10/20.
//  Copyright © 2016年 Rolf Zhang. All rights reserved.
//

import UIKit
import Observable

class ViewController: UIViewController {

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bind(result, first.o_text(), second.o_text(), third.o_text()) { label, v1, v2, v3 in
            if let v1 = v1, v2 = v2, v3 = v3 {
                let i1 = Int(v1) ?? 0
                let i2 = Int(v2) ?? 0
                let i3 = Int(v3) ?? 0
                
                label.text = "\(i1+i2+i3)"
            }
        }
        
        let count = Observable(0)
        bind(countLabel, count) { label, count in
            label.text = "\(count!) s"
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, repeats: true) { _ in
            count <- count.value()! + 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

