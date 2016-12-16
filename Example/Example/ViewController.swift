//
//  ViewController.swift
//  Example
//
//  Created by JoeJoe on 2016/12/13.
//  Copyright © 2016年 Joe. All rights reserved.
//

import UIKit
import ScratchCard

class ViewController: UIViewController, ScratchUIViewDelegate {
    
    var scratchCard: ScratchUIView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scratchCard = ScratchUIView(frame: CGRect(x:50, y:80, width:320, height:480), Coupon: "image", MaskImage: "mask", ScratchWidth: CGFloat(40))
        scratchCard.delegate = self
        
        self.view.addSubview(scratchCard)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getScratchPercent(_ sender: Any) {
        let scratchPercent: Double = scratchCard.getScratchPercent()
        textField.text = String(format: "%.2f", scratchPercent * 100) + "%"
    }
    
    //Scratch Began Event(optional)
    func scratchBegan(_ view: ScratchUIView) {
        print("scratchBegan")
    }
    
    //Scratch Moved Event(optional)
    func scratchMoved(_ view: ScratchUIView) {
        let scratchPercent: Double = scratchCard.getScratchPercent()
        textField.text = String(format: "%.2f", scratchPercent * 100) + "%"
        print("scratchMoved")
    }
    
    //Scratch Ended Event(optional)
    func scratchEnded(_ view: ScratchUIView) {
        print("scratchEnded")
    }
}
