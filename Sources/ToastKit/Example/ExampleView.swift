//
//  SwiftUIView.swift
//
//
//  Created by Usman Nazir on 09/06/2024.
//

import SwiftUI

struct ExampleView: View {
    var body: some View {
        ZStack {
//            LinearGradient(colors: [.red, .blue, .green, .yellow, .red], startPoint: .leading, endPoint: .trailing)
            ScrollView {
                VStack {
                    Button(action: {
                        presentToast()
                    }, label: {
                        Text("Present Toast")
                    }).tint(.black)
                    Button(action: {
                        presentToast2()
                    }, label: {
                        Text("Present Another Toast")
                    }).tint(.black)
                }
                .padding(.top, 300)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            ToastKit.configure(type: .glass(centred: true))
        }
    }
    
    func presentToast() {
        ToastKit.present(message: "Some cool message", color: Color.black)
    }
    
    func presentToast2() {
        ToastKit.present(message: "Some cool message", color: Color.green)
    }
}

#Preview {
    ExampleView()
}
