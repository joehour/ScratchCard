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
var scratchable:CGImage!
var scratched:CGImage!
var _scratched:CGImage!
var alpha_pixels:CGContext!
var provider:CGDataProvider!
var _mask_image: String!
var _scratch_width: CGFloat!
var count: Double!

open class ScratchView: UIView {
    
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
    
    fileprivate func Init() {
        
        count = 0
        scratchable = UIImage(named: _mask_image)!.cgImage
        width = (Int)(self.frame.width)
        height = (Int)(self.frame.height)
        
        self.isOpaque = false
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        let pixels: CFMutableData = CFDataCreateMutable ( nil , width * height )
        alpha_pixels = CGContext( data: CFDataGetMutableBytePtr( pixels ) , width: width , height: height , bitsPerComponent: 8 , bytesPerRow: width, space: colorspace ,bitmapInfo: CGImageAlphaInfo.none.rawValue )
        provider = CGDataProvider(data: pixels);
        alpha_pixels.setFillColor(UIColor.black.cgColor)
        alpha_pixels.fill(frame);
        alpha_pixels.setStrokeColor(UIColor.white.cgColor);
        alpha_pixels.setLineWidth(_scratch_width);
        alpha_pixels.setLineCap(CGLineCap.round)
        
        let mask:CGImage = CGImage(maskWidth: width, height: height, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: width , provider: provider, decode: nil, shouldInterpolate: false)!
        scratched = scratchable.masking(mask);
        
    }
    
    fileprivate func InitXib() {
        
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?){
            if let touch = touches.first{
                first_touch = true
                location = CGPoint(x: touch.location(in: self).x, y: self.frame.size.height-touch.location(in: self).y)            }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?){
            if let touch = touches.first{
                
                if ((first_touch)!) {
                    first_touch = false;
                    previous_location =  CGPoint(x: touch.previousLocation(in: self).x, y: self.frame.size.height-touch.previousLocation(in: self).y)
                } else {
                    
                    location = CGPoint(x: touch.location(in: self).x, y: self.frame.size.height-touch.location(in: self).y)
                    previous_location = CGPoint(x: touch.previousLocation(in: self).x, y: self.frame.size.height-touch.previousLocation(in: self).y)
                }
                
                renderLineFromPoint(previous_location,end: location)
                
            }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>,
        with event: UIEvent?){
            if let touch = touches.first{
                if ((first_touch)!) {
                    first_touch = false;
                    previous_location =  CGPoint(x: touch.previousLocation(in: self).x, y: self.frame.size.height-touch.previousLocation(in: self).y)
                    renderLineFromPoint(previous_location,end: location)
                    
                }
            }
    }
    
    override open func draw(_ rect: CGRect){
        UIGraphicsGetCurrentContext()?.saveGState();
        UIGraphicsGetCurrentContext()?.translateBy(x: self.frame.origin.x, y: self.frame.origin.y);
        UIGraphicsGetCurrentContext()?.translateBy(x: 0, y: self.frame.size.height);
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0);
        UIGraphicsGetCurrentContext()?.translateBy(x: -self.frame.origin.x, y: -self.frame.origin.y);
        UIGraphicsGetCurrentContext()?.draw(scratched, in: self.frame);
        UIGraphicsGetCurrentContext()?.restoreGState();
        
    }
    
    
    func renderLineFromPoint(_ start:CGPoint, end:CGPoint){
        
        alpha_pixels.move(to: CGPoint(x: start.x, y: start.y));
        alpha_pixels.addLine(to: CGPoint(x: end.x, y: end.y));
        alpha_pixels.strokePath();
        
        self.setNeedsDisplay();
    }
    
    
    
    internal func getAlphaPixelPercent() -> Double {
        
        let pixelData = alpha_pixels.makeImage()?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let w: size_t = alpha_pixels.makeImage()!.width
        let h: size_t = alpha_pixels.makeImage()!.height
        var byteIndex: Int  = 0
        count = 0
        for _ in 0...(w * h){
            if(data[byteIndex+3] != 0)
            {
                count! += 1
            }
            byteIndex += 1
        }
        
        return (count!) / Double(w * h)
    }
    
    
}
