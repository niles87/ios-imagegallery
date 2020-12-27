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
        let newImg = image.fixOrientation()
        filter.setValue(CIImage(image: newImg), forKey: kCIInputImageKey)
        let output = filter.outputImage
        return UIImage(cgImage: context.createCGImage(output!, from: output!.extent)!, scale: 1.0, orientation: .up)
    }
    
    func sepiaTone(value: Float, image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(value, forKey: kCIInputIntensityKey)
        return display(filter: filter!, image: image, context: context)
    }
    
    func greyScale(value: Float, color: String, image: UIImage!, context: CIContext) -> UIImage {
        let filter = CIFilter(name: "CIColorMonochrome")
        var clr: CIColor
        switch color {
        case "Blue":
            clr = .blue
        case "Grey":
            clr = .gray
        case "Green":
            clr = .green
        case "Orange":
            clr = .init(red: 1.0, green: 0.5, blue: 0.0)
        case "Purple":
            clr = .init(red: 0.5, green: 0.0, blue: 0.5)
        case "Red":
            clr = .red
        case "Yellow":
            clr = .yellow
        default:
            clr = .gray
        }
        filter?.setValue(clr, forKey: "inputColor")
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
