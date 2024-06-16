//
//  ToastModel.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import Foundation
import SwiftUI

public class ToastModel: ObservableObject {
    var toastType: ToastType = .liquid
    @Published var expanded: Bool = false
    var message: String = ""
    var color: Color = .black
    var tint: Color = .white
    var width: CGFloat = 250.0
    var symbol: Image? = nil
    
    var isCentered: Bool {
        switch toastType {
        case .solid(let centred):
            return centred
        case .glass(let centred):
            return centred
        default:
            return false
        }
    }
}
