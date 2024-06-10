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
    var color: Color = .blue
}
