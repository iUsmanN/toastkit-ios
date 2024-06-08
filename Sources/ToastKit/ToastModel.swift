//
//  ToastModel.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import Foundation
import SwiftUI

public class ToastModel: ObservableObject {
    @Published var expanded: Bool = false
    @Published var message: String = ""
    @Published var color: Color = .blue
}
