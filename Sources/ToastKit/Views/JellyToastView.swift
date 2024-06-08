//
//  ToastView.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import SwiftUI

struct JellyToastView: View {
    @ObservedObject var model: ToastModel
    
    private static let topMargin = 8.5
    @State var dragoffset: CGSize = .init(width: 0, height: topMargin)//.zero
    
    var topPadding: CGFloat {
        switch UIDevice.current.screenType {
        case .dynamicIsland:
            return 14
        case .notch:
            return -4
        case .none:
            return -37
        }
    }
    
    var minimisedWidth: CGFloat {
        switch UIDevice.current.screenType {
        case .dynamicIsland:
            return 120
        case .notch:
            return 150
        case .none:
            return 120
        }
    }
    
    var body: some View {
        
        ZStack {
            liquidEffectView()
            topAligned()
            //                Button(action: {
            //                    if model.expanded {
            //                        withAnimation(.spring) {
            //                            dragoffset = .init(width: 0, height: JellyToastView.topMargin)
            //                            model.expanded.toggle()
            //                        }
            //                    } else {
            //                        withAnimation(.spring(duration: 0.5)) {
            //                            dragoffset = .init(width: 0, height: 50)
            //                            model.expanded.toggle()
            //                        }
            //                    }
            //                }, label: {
            //                    Text("Button")
            //                })
        }
        .onChange(of: model.expanded, {
            if !$1 {
                withAnimation(.spring) {
                    dragoffset = .init(width: 0, height: JellyToastView.topMargin)
                }
            } else {
                withAnimation(.spring(duration: 0.5)) {
                    dragoffset = .init(width: 0, height: 50)
                }
            }
        })
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func liquidEffectView() -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .black))
            context.addFilter(.blur(radius: 12))
            context.drawLayer { ctx in
                for index in [1, 2] {
                    if let resolvedView = context.resolveSymbol(id: index) {
                        ctx.draw(resolvedView, at: .init(x: size.width/2, y: 30))
                    } else {
                        print("Failed to resolve symbol \(index)")
                    }
                }
            }
        } symbols: {
            liquidToast(offset: dragoffset)
                .tag(1)
            
            liquidIsland()
                .tag(2)
        }
        .gesture(DragGesture()
            .onChanged({ value in
                dragoffset = value.translation
                if !model.expanded {
                    withAnimation {
                        model.expanded.toggle()
                    }
                }
            }).onEnded({ _ in
                withAnimation {
                    dragoffset = .init(width: 0, height: JellyToastView.topMargin)
                    Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
                        withAnimation {
                            model.expanded.toggle()
                        }
                    }
                }
            }))
    }
    
    @ViewBuilder
    func liquidIsland(offset: CGSize = .zero) -> some View {
        Capsule()
            .fill(.red)
            .frame(width: 70, height: 20)
            .padding(.top)
    }
    
    @ViewBuilder
    func liquidToast(offset: CGSize = .zero) -> some View {
        Capsule()
            .frame(width: 70, height: 16)
            .offset(offset)
    }
    
    @ViewBuilder
    func dynamicToast(offset: CGSize = .zero) -> some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black)
            Text("\(model.message)")
                .foregroundStyle(.white)
                .blur(radius: model.expanded ? 0 : 10)
            Rectangle()
                .fill(model.expanded ? .clear : .black)
        }
        .frame(width: model.expanded ? 250 : minimisedWidth, height: model.expanded ? 50 : 33)
        .clipShape(Capsule())
        .shadow(radius: 2)
        .offset(.init(width: offset.width, height: offset.height + 20))
        .overlay(content: {
            Capsule()
                .stroke(model.expanded ? Color.primary.opacity(0.5) : .black)
                .offset(.init(width: offset.width, height: offset.height + 20))
        })
        .padding(.top, model.expanded ? 5 : -topPadding)
    }
    
    @ViewBuilder
    func topAligned() -> some View {
        VStack {
            dynamicToast(offset: dragoffset)
            Spacer()
        }
        .ignoresSafeArea()
    }
}


#Preview {
    JellyToastView(model: .init())
}
