//
//  ViewController.swift
//  testImage
//
//  Created by longxiang on 2017/4/20.
//  Copyright © 2017年 longxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originImage: UIImageView!
    @IBOutlet weak var convertImage: UIImageView!
    @IBOutlet weak var orignImageBytes: UILabel!
    @IBOutlet weak var compressImageBytes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image  = UIImage.init(named: "test")
        guard let cgImage = image?.cgImage else {
            orignImageBytes.text = "unable to read"
        
        }
        originImage.image = image
        orignImageBytes.text = "\(cgImage.bytesPerRow * cgImage.height / 1024)" + "KB"
        let tuple = image?.compress(threadhold: 500 * 1024)
        guard let compressImage = tuple?.image, let convertImageData = tuple?.imageData else {
            return
        }
        convertImage.image = compressImage
        try? convertImageData.write(to: URL.init(fileURLWithPath: "/Users/longxiang/Desktop/JavaScript/convertImageData.jpg"), options: Data.WritingOptions.atomic)
        compressImageBytes.text = "\(convertImageData.count / 1024)" + "KB"
    }
}


extension UIImage {
    
    func compress(threadhold:Int = 200 * 1024) -> (image:UIImage?,imageBase64:String?,imageData:Data?)? {
        guard let orginImage = self.copy() as? UIImage else {
            return nil
        }
        let adaptImage = self.adaptImageResolutionIfNeeded(orginImage)
        guard var originImageData = UIImageJPEGRepresentation(adaptImage, 1.0) else {
            return nil
        }
        
        var actualThreadhold = compressConfing.minCompressThreshold
        if threadhold >= compressConfing.minCompressThreshold && threadhold <= compressConfing.maxCompressThreshold {
            actualThreadhold = threadhold
        }
        
        var imageBase64    = originImageData.base64EncodedString()
        var image:UIImage? = adaptImage
        let originBytes    = originImageData.count
        let detaBytes      = originBytes - actualThreadhold
        if  detaBytes  <= 0 {
            return (image:image,imageBase64:imageBase64,imageData:originImageData)
        }
        var notReachJPGCompressLimit = true
        var needContinuteJPGCompress = true
        var compressDefaultRatio     = compressConfing.compressDefaultRatio
        let compressStepRatio        = compressConfing.compressStepRatio
        while notReachJPGCompressLimit && needContinuteJPGCompress {
            guard let compressImageData = UIImageJPEGRepresentation(adaptImage, compressDefaultRatio) else {
                return nil
            }
            compressDefaultRatio = compressDefaultRatio - compressStepRatio
            notReachJPGCompressLimit = (compressDefaultRatio > 0.2)
            needContinuteJPGCompress = compressImageData.count > actualThreadhold
            originImageData = compressImageData
        }
        
        imageBase64     = originImageData.base64EncodedString()
        image           = UIImage(data: originImageData)
        if notReachJPGCompressLimit {
            return (image:image,imageBase64:imageBase64,imageData:originImageData)
        }
        guard let compressImage = image else {
            return nil
        }
        guard let sacleImage = compressImage.drawImage(size: compressImage.size, sacle: 0.95) else {
            return nil
        }
        return sacleImage.compress(threadhold: actualThreadhold)
    }
    
    func adaptImageResolutionIfNeeded(_ image:UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        let aspectRatio   = Float(cgImage.width * cgImage.height) / Float(compressConfing.resolution)
        if aspectRatio < 1.0 {
            return image
        }
        let sacleRatio        = Float(sqrt(aspectRatio))
        let width             = Int(Float(cgImage.width) / sacleRatio )
        let height            = Int(Float(cgImage.height) / sacleRatio)
        let bitesPerComponent = compressConfing.bitesPerComponent
        let bytesPerRow       = cgImage.width  * compressConfing.bytesPerPixel
        let pixelbufferLength = cgImage.height * bytesPerRow
        let colorsapce        = CGColorSpaceCreateDeviceRGB()
        let bitmapData        = malloc(pixelbufferLength)
        let bitmapContext     = CGContext(data: bitmapData,width: width,height: height,bitsPerComponent: bitesPerComponent,bytesPerRow: bytesPerRow,space: colorsapce,bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue|CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let drawRect = CGRect.init(x: 0, y: 0, width: width, height:height)
        bitmapContext?.draw(cgImage, in: drawRect)
        guard let newCgImage = bitmapContext?.makeImage() else {
            return image
        }
        return UIImage(cgImage: newCgImage)
    }
    
    func drawImage(size:CGSize,sacle:CGFloat = 1.0) -> UIImage? {
        let actualSize = CGSize.init(width:  size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(actualSize)
        self.draw(in: CGRect.init(x: 0, y: 0, width: actualSize.width, height: actualSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    var compressConfing : (
        bitesPerPixel:Int,
        bitesPerComponent:Int,
        bytesPerPixel:Int,
        resolution:Int,
        minCompressThreshold:Int,
        maxCompressThreshold:Int,
        compressDefaultRatio:CGFloat,
        compressStepRatio:CGFloat
        ) {
        return (32,8,4,1242 * 2208,200*1024,500*1024,0.99,0.01)
    }
}

