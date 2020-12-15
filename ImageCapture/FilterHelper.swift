//
//  FilterHelper.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/13/20.
//

import UIKit
import Foundation

class Filters {
    static let main = Filters()
    
    private init() {}
    
    private func display(filter: CIFilter, image: UIImage!, context: CIContext) -> UIImage {
        print("in display function")
        let newImg = image.fixOrientation()
        filter.setValue(CIImage(image: newImg), forKey: kCIInputImageKey)
        let output = filter.outputImage
        return UIImage(cgImage: context.createCGImage(output!, from: output!.extent)!, scale: 1.0, orientation: .up)
    }
    
    func sepiaTone(value: Float, image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(value, forKey: kCIInputIntensityKey)
        print("in sepiaTone")
        return display(filter: filter!, image: image, context: context)
    }
    
    func greyScale(value: Float, image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(CIColor(color: .gray), forKey: "inputColor")
        filter?.setValue(value, forKey: "inputIntensity")
        return display(filter: filter!, image: image, context: context)
    }
    
    func noir(image: UIImage!, context:CIContext) -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        return display(filter: filter!, image: image, context: context)
    }
    
    func invert(image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CIColorInvert")
        return display(filter: filter!, image: image, context: context)
    }
    
    func vintage(image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        return display(filter: filter!, image: image, context: context)
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
