//
//  ViewController.swift
//  Example
//
//  Created by JoeJoe on 2016/12/13.
//  Copyright © 2016年 Joe. All rights reserved.
//

import UIKit
import ScratchCard

class ViewController: UIViewController {

    var ScratchCard: ScratchUIView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ScratchCard  = ScratchUIView(frame: CGRect(x:50, y:80, width:320, height:480),Coupon: "image", MaskImage: "mask", ScratchWidth: CGFloat(40))
        self.view.addSubview(ScratchCard)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getScratchPercent(_ sender: Any) {
    
        let scratch_percent:Double = ScratchCard.getScratchPercent()
        textField.text = String(format: "%.2f", scratch_percent*100) + "%"
    }

}

