//
//  ScratchView.swift
//  ScratchCard
//
//  Created by JoeJoe on 2016/4/15.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import Foundation
import UIKit


var width:Int!
var height:Int!
var location: CGPoint!
var previous_location: CGPoint!
var first_touch:Bool!
var scratchable:CGImageRef!
var scratched:CGImageRef!
var _scratched:CGImageRef!
var alpha_pixels:CGContextRef!
var provider:CGDataProviderRef!
var _mask_image: String!
var _scratch_width: CGFloat!
var count: Double!

public class ScratchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
        
    }
    
    init(frame: CGRect, MaskImage: String, ScratchWidth: CGFloat) {
        super.init(frame: frame)
        _mask_image = MaskImage
        _scratch_width = ScratchWidth
        self.Init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.InitXib()
    }
    
    private func Init() {
        
        count = 0
        scratchable = UIImage(named: _mask_image)!.CGImage
        width = (Int)(self.frame.width)
        height = (Int)(self.frame.height)
        
        self.opaque = false
        let colorspace:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        
        let pixels: CFMutableDataRef = CFDataCreateMutable ( nil , width * height )
        alpha_pixels = CGBitmapContextCreate( CFDataGetMutableBytePtr( pixels ) , width , height , 8 , width, colorspace ,CGImageAlphaInfo.None.rawValue )
        provider = CGDataProviderCreateWithCFData(pixels);
        CGContextSetFillColorWithColor(alpha_pixels, UIColor.blackColor().CGColor)
        CGContextFillRect(alpha_pixels, frame);
        CGContextSetStrokeColorWithColor(alpha_pixels, UIColor.whiteColor().CGColor);
        CGContextSetLineWidth(alpha_pixels, _scratch_width);
        CGContextSetLineCap(alpha_pixels, CGLineCap.Round)
        
        let mask:CGImageRef = CGImageMaskCreate(width, height, 8, 8, width , provider, nil, false)!
        scratched = CGImageCreateWithMask(scratchable, mask);
        
    }
    
    private func InitXib() {
        
    }
    
    override public func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?){
            if let touch = touches.first{
                first_touch = true
                location = CGPoint(x: touch.locationInView(self).x, y: self.frame.size.height-touch.locationInView(self).y)            }
    }
    
    override public func touchesMoved(touches: Set<UITouch>,
        withEvent event: UIEvent?){
            if let touch = touches.first{
                
                if ((first_touch)!) {
                    first_touch = false;
                    previous_location =  CGPoint(x: touch.previousLocationInView(self).x, y: self.frame.size.height-touch.previousLocationInView(self).y)
                } else {
                    
                    location = CGPoint(x: touch.locationInView(self).x, y: self.frame.size.height-touch.locationInView(self).y)
                    previous_location = CGPoint(x: touch.previousLocationInView(self).x, y: self.frame.size.height-touch.previousLocationInView(self).y)
                }
                
                renderLineFromPoint(previous_location,end: location)
                
            }
    }
    
    override public func touchesEnded(touches: Set<UITouch>,
        withEvent event: UIEvent?){
            if let touch = touches.first{
                if ((first_touch)!) {
                    first_touch = false;
                    previous_location =  CGPoint(x: touch.previousLocationInView(self).x, y: self.frame.size.height-touch.previousLocationInView(self).y)
                    renderLineFromPoint(previous_location,end: location)
                    
                }
            }
    }
    
    override public func drawRect(rect: CGRect){
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), self.frame.origin.x, self.frame.origin.y);
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.frame.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -self.frame.origin.x, -self.frame.origin.y);
        CGContextDrawImage(UIGraphicsGetCurrentContext() , self.frame, scratched);
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
        
    }
    
    
    func renderLineFromPoint(start:CGPoint, end:CGPoint){
        
        CGContextMoveToPoint(alpha_pixels, start.x, start.y);
        CGContextAddLineToPoint(alpha_pixels, end.x, end.y);
        CGContextStrokePath(alpha_pixels);
        
        self.setNeedsDisplay();
    }
    
    
    
    internal func getAlphaPixelPercent() -> Double {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(CGBitmapContextCreateImage(alpha_pixels)))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let w: size_t = CGImageGetWidth(CGBitmapContextCreateImage(alpha_pixels))
        let h: size_t = CGImageGetHeight(CGBitmapContextCreateImage(alpha_pixels))
        var byteIndex: Int  = 0
        count = 0
        for _ in 0...(w * h){
            if(data[byteIndex+3] != 0)
            {
                count!++
            }
            byteIndex += 1
        }
        
        return (count!) / Double(w * h)
    }
    
    
}