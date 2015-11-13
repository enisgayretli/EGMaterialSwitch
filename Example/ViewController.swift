//
//  ViewController.swift
//  Example
//
//  Created by joshmay on 11/12/15.
//
//

import UIKit
import EGMaterialSwitch
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let egSwitch = EGMaterialSwitch(size: .Normal, state: .On)
        let screenFrame = UIScreen.mainScreen().bounds
        egSwitch.center = CGPointMake(screenFrame.size.width*6/7, 45)
        self.view.addSubview(egSwitch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

