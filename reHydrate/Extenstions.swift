//
//  Extenstions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension UITextField {
    // MARK: TextField padding
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIApplication {
    
    /**
     Will check if it is the first time the app is ever launched on this phone
     
     - returns: **Bool** true if its the first time false if not.
     
     # Example #
     ```
     if UIApplication.isFirstLaunch() {
     print("first time to launch this app")
     //Do something
     }
     ```
     */
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: versionString) {
            UserDefaults.standard.set(true, forKey: versionString)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

extension UIImage {
    func colored(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }
    
    func renderResizedImage (newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let image = renderer.image { (_) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
    
    /**
     Will create a greayed out version of the image.
     
     - returns: The image grayed out.
     
     # Example #
     ```
     imageView.image  = imageView.image?.grayed
     ```
     */
    var grayed: UIImage {
        guard let ciImage = CIImage(image: self)
        else { return self }
        let filterParameters = [ kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 1.0 ] as [String: Any]
        let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
        return UIImage(ciImage: grayscale)
    }
}

extension Double {
    
    /**
     Will clean up a **Double** so that it has a maximum of 1 desimal
     
     - returns: the number as a **String** cleand up
     
     # Example #
     ```
     let number1 = 3.122
     number1.clean // returns 3.1
     
     let number2 = 3.001
     number2.clean // returns 3
     ```
     */
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
