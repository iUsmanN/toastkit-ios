//
//  UIDevice+Toast.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import Foundation
import UIKit

enum ScreenType: String {
    case dynamicIsland
    case notch
    case none
}

extension UIDevice {
    
    var screenType: ScreenType {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            return .none
        }
        
        let topInset = window.safeAreaInsets.top
        let bottomInset = window.safeAreaInsets.bottom
        
        // Check for Dynamic Island (typically more prominent top inset)
        if topInset > 50 {
            return .dynamicIsland
        }
        
        // Check for notch (noticeable top inset but less than Dynamic Island)
        if topInset > 20 || bottomInset > 20 {
            return .notch
        }
        
        // No significant insets means a standard screen
        return .none
    }
}
