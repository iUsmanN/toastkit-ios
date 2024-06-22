//
//  File.swift
//  
//
//  Created by Usman Nazir on 11/06/2024.
//

import Foundation
import UIKit

extension UIWindow {
    public static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    public static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
