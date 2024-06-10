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
        })
        .onAppear {
            ToastKit.configure(type: .drop)
        }
    }
    
    func presentToast() {
        Task {
            await ToastKit.present(message: "Some cool message", color: Color.red)
        }
    }
}

#Preview {
    ExampleView()
}
