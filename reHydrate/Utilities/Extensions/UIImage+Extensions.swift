//
//  UIImage+Extensions.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/08/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

extension UIImage {
    func colored(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }

    func renderResizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)

        let image = renderer.image { _ in
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
        let filterParameters = [kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 1.0] as [String: Any]
        let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
        return UIImage(ciImage: grayscale)
    }
}
