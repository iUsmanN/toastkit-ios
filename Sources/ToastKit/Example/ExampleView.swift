//
//  SwiftUIView.swift
//
//
//  Created by Usman Nazir on 09/06/2024.
//

import SwiftUI

struct ExampleView: View {
    var body: some View {
        Button(action: {
            presentToast()
        }, label: {
            Text("Present Toast")
        }).tint(.red)
        Button(action: {
            presentToast2()
        }, label: {
            Text("Present Another Toast")
        }).tint(.green)
        .onAppear {
            ToastKit.configure(type: .solid)
        }
    }
    
    func presentToast() {
        ToastKit.present(message: "Some cool message", color: Color.red)
    }
    
    func presentToast2() {
        ToastKit.present(message: "Some cool message", color: Color.green)
    }
}

#Preview {
    ExampleView()
}
