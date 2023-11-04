//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//

import Foundation

public enum AppIcon {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didTapClose
        case didSelectIcon(AppIcon.ViewModel.Icon)
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let selectedIcon: AppIcon.ViewModel.Icon
        public let allIcons: [AppIcon.ViewModel.Icon]
        public let error: Error?
        
        public init(isLoading: Bool, selectedIcon: AppIcon.ViewModel.Icon, error: Error?) {
            self.isLoading = isLoading
            self.selectedIcon = selectedIcon
            self.allIcons = AppIcon.ViewModel.Icon.allCases
            self.error = error
        }
    }
}

extension AppIcon.ViewModel {
    public enum Icon: String, CaseIterable {
        case whiteGrey
        case greyWhite
        case blackWhite
        // Blue icons
        case whiteBlue
        case blueWhite
        case blackBlue
        // Green icons
        case whiteGreen
        case greenWhite
        case blackGreen
        // Orange icons
        case whiteOrange
        case orangeWhite
        case blackOrange
        // LexiPink
        case whiteLexiPink
        case lexiPinkWhite
        case blackLexiPink
        // Pink icons
        case whitePink
        case pinkWhite
        case blackPink
        // Purple icons
        case whitePurple
        case purpleWhite
        case blackPurple
        // Red icons
        case whiteRed
        case redWhite
        case blackRed
        // Yellow icons
        case whiteYellow
        case yellowWhite
        case blackYellow
        // Rainbow icons
        case whiteRainbow
        case rainbowWhite
        case blackRainbow
    }

}

extension AppIcon.ViewModel {
    public enum Error: Swift.Error {
        case donNotSupportAlternateIcons
        case failedSettingAlternateIcons
    }
}
