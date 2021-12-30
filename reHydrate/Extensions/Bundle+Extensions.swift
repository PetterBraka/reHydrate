//
//  BundleExtension.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 30/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import UIKit

var bundleKey: UInt8 = 0

class LanguageBundle: Bundle {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path)
        else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }

        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, LanguageBundle.self)
        }

        objc_setAssociatedObject(Bundle.main, &bundleKey,
                                 Bundle.main.path(forResource: language, ofType: "lproj"),
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
