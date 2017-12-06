//
//  ScratchView.swift
//  ScratchCard
//
//  Created by JoeJoe on 2016/4/15.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import Foundation
import UIKit

var width: Int!
var height: Int!
var location: CGPoint!
var previousLocation: CGPoint!
var firstTouch: Bool!
//var scratchable: CGImage!
var scratched: CGImage!
var alphaPixels: CGContext!
var provider: CGDataProvider!
var pixelBuffer: UnsafeMutablePointer<UInt8>!
var couponImage: String!
var scratchWidth: CGFloat!
var contentLayer: CALayer!
var maskLayer: CAShapeLayer!

internal protocol ScratchViewDelegate: class {
    func began(_ view: ScratchView)
    func moved(_ view: ScratchView)
    func ended(_ view: ScratchView)
}

open class ScratchView: UIView {
    
    internal weak var delegate: ScratchViewDelegate!
    internal var position: CGPoint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
    }
    
    init(frame: CGRect, CouponImage: String, ScratchWidth: CGFloat) {
        super.init(frame: frame)
        couponImage = CouponImage
        scratchWidth = ScratchWidth
        self.Init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.InitXib()
    }
    
    fileprivate func Init() {
        let image = processPixels(image: UIImage(named: couponImage)!)
        if image != nil {
            scratched = image?.cgImage
        } else {
            scratched = UIImage(named: couponImage)?.cgImage
        }
        width = (Int)(self.frame.width)
        height = (Int)(self.frame.height)
        
        self.isOpaque = false
        
        let colorspace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        let pixels: CFMutableData = CFDataCreateMutable(nil, width * height)
        
        alphaPixels = CGContext( data: CFDataGetMutableBytePtr(pixels), width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorspace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        alphaPixels.setFillColor(UIColor.black.cgColor)
        alphaPixels.setStrokeColor(UIColor.white.cgColor)
        alphaPixels.setLineWidth(scratchWidth)
        alphaPixels.setLineCap(CGLineCap.round)
    
        //fix mask initialization error on simulator device(issue9)
        pixelBuffer = alphaPixels.data?.bindMemory(to: UInt8.self, capacity: width * height)
        var byteIndex: Int  = 0
        for _ in 0...width * height {
            if  pixelBuffer?[byteIndex] != 0 {
                pixelBuffer?[byteIndex] = 0
            }
            byteIndex += 1
        }
        provider = CGDataProvider(data: pixels)
        
        maskLayer = CAShapeLayer()
        maskLayer.frame =  CGRect(x:0, y:0, width:width, height:height)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        
        contentLayer = CALayer()
        contentLayer.frame =  CGRect(x:0, y:0, width:width, height:height)
        contentLayer.contents = scratched
        contentLayer.mask = maskLayer
        self.layer.addSublayer(contentLayer)
    }
    
    fileprivate func InitXib() {
        
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?) {
            if let touch = touches.first {
                firstTouch = true
                location = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
                
                position = location
                
                if self.delegate != nil {
                    self.delegate.began(self)
                }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?) {
            if let touch = touches.first {
                if firstTouch! {
                    firstTouch = false
                    previousLocation =  CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)
                } else {
                    
                    location = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
                    previousLocation = CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)
                }
                
                position = previousLocation
                
                renderLineFromPoint(previousLocation, end: location)
                
                if self.delegate != nil {
                    self.delegate.moved(self)
                }
            }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>,
        with event: UIEvent?) {
            if let touch = touches.first {
                if firstTouch! {
                    firstTouch = false
                    previousLocation =  CGPoint(x: touch.previousLocation(in: self).x, y: touch.previousLocation(in: self).y)

                    position = previousLocation
                    
                    renderLineFromPoint(previousLocation, end: location)
                    
                    if self.delegate != nil {
                        self.delegate.ended(self)
                    }
                }
            }
    }
    
//    override open func draw(_ rect: CGRect) {
//        UIGraphicsGetCurrentContext()?.saveGState()
//        contentLayer.render(in:  UIGraphicsGetCurrentContext()!)
//        UIGraphicsGetCurrentContext()?.restoreGState()
//        
//    }
    
    func renderLineFromPoint(_ start: CGPoint, end: CGPoint) {
        alphaPixels.move(to: CGPoint(x: start.x, y: start.y))
        alphaPixels.addLine(to: CGPoint(x: end.x, y: end.y))
        alphaPixels.strokePath()
        drawLine(onLayer: maskLayer, fromPoint: start, toPoint: end)
    }
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        linePath.lineCapStyle = .round
        line.lineWidth = scratchWidth
        line.path = linePath.cgPath
        line.opacity = 1
        line.strokeColor = UIColor.white.cgColor
        line.lineCap = "round"
        layer.addSublayer(line)
    }
    
    internal func getAlphaPixelPercent() -> Double {
        var byteIndex: Int  = 0
        var count: Double = 0
        let data = UnsafePointer(pixelBuffer)
        for _ in 0...width * height {
            if  data![byteIndex] != 0 {
                count += 1
            }
            byteIndex += 1
        }
        return count / Double(width * height)
    }
    
    // iOS 11.2 error
    //    internal func getAlphaPixelPercent() -> Double {
    //        let pixelData = provider.data
    //        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    //        let imageWidth: size_t = alphaPixels.makeImage()!.width
    //        let imageHeight: size_t = alphaPixels.makeImage()!.height
    //
    //        var byteIndex: Int  = 0
    //        var count: Double = 0
    //
    //        for _ in 0...imageWidth * imageHeight {
    //            if data[byteIndex] != 0 {
    //                count += 1
    //            }
    //            byteIndex += 1
    //        }
    //
    //        return count / Double(imageWidth * imageHeight)
    //    }
    
    func processPixels(image: UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: UInt8.self, capacity: width * height)
        var byteIndex: Int  = 0
        for _ in 0...width * height {
            if  pixelBuffer[byteIndex] == 0 {
                pixelBuffer[byteIndex] = 255
                pixelBuffer[byteIndex+1] = 255
                pixelBuffer[byteIndex+2] = 255
                pixelBuffer[byteIndex+3] = 255
            }
            byteIndex += 4
        }
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        return outputImage
    }
}
