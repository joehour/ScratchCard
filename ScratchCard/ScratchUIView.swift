//
//  ScratchUIView.swift
//  ScratchCard
//
//  Created by JoeJoe on 2016/4/15.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import Foundation
import UIKit

var couponImage: UIImageView!
var scratchCard: ScratchView!
var coupon: String!
var uiScratchWidth: CGFloat!

open class ScratchUIView: UIView {
    
    @IBOutlet fileprivate var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
    }
    
    open func getScratchPercent() -> Double {
        return scratchCard.getAlphaPixelPercent()
    }
    
    public init(frame: CGRect, Coupon: String, MaskImage: String, ScratchWidth: CGFloat) {
        super.init(frame: frame)
        coupon = Coupon
        maskImage = MaskImage
        uiScratchWidth = ScratchWidth
        self.Init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.InitXib()
    }
    
    fileprivate func Init() {
        couponImage = UIImageView(image:UIImage(named:coupon))
        scratchCard = ScratchView(frame: self.frame, MaskImage: maskImage, ScratchWidth: uiScratchWidth)
        couponImage.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scratchCard.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(couponImage)
        self.addSubview(scratchCard)
        self.bringSubview(toFront: scratchCard)
    }
    
    fileprivate func InitXib() {
        
    }
}
