//
//  ScratchUIView.swift
//  ScratchCard
//
//  Created by JoeJoe on 2016/4/15.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import Foundation
import UIKit


var CouponImage: UIImageView!
var ScratchCard: ScratchView!
var coupon: String!
var mask_image: String!
var scratch_width: CGFloat!

public class ScratchUIView: UIView {
    
    @IBOutlet private var contentView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
    }
    
    public func getScratchPercent()->Double{
        return ScratchCard.getAlphaPixelPercent()
    }
    
    public init(frame: CGRect, Coupon: String, MaskImage: String, ScratchWidth:CGFloat) {
        super.init(frame: frame)
        coupon = Coupon
        mask_image = MaskImage
        scratch_width = ScratchWidth
        self.Init()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.InitXib()
    }
    
    private func Init() {
        
        CouponImage = UIImageView(image:UIImage(named:coupon))
        ScratchCard = ScratchView(frame: self.frame, MaskImage: mask_image, ScratchWidth: scratch_width)
        CouponImage.frame = CGRectMake(0,0, self.frame.width, self.frame.height)
        ScratchCard.frame = CGRectMake(0,0,self.frame.width, self.frame.height)
        self.addSubview(CouponImage)
        self.addSubview(ScratchCard)
        self.bringSubviewToFront(ScratchCard)
    }
    
    private func InitXib() {
        
    }
    
}
