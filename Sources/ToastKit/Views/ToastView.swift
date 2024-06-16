//
//  ToastView.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//
import SwiftUI

struct ToastView: View {
    @ObservedObject var model: ToastModel
    
    var topPadding: CGFloat {
        switch UIDevice.current.screenType {
        case .dynamicIsland:
            return 11
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
        if UIDevice.current.screenType == .none || model.isCentered {
            centerAligned()
        } else {
            topAligned()
        }
    }

    @ViewBuilder
    func topAligned() -> some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(model.expanded ? model.color : .black)
                HStack {
                    model.symbol
                        .foregroundStyle(model.color == .black ? .white : model.tint)
                    Text("\(model.message)")
                        .foregroundStyle(model.color == .black ? .white : model.tint)
                        .lineLimit(1)
//                        .opacity(model.expanded ? 1 : 0)
                }
                .blur(radius: model.expanded ? 0 : 10)
                .padding(.horizontal, 20)
            }
            .opacity(!model.expanded ? 0 : 1)
            .blur(radius: model.expanded ? 0 : 10)
            .frame(width: model.expanded ? CGFloat.minimum((UIScreen.current?.bounds.size.width ?? 0) - 40, model.width) : minimisedWidth, height: model.expanded ? 50 : 35)
            .clipShape(Capsule())
            .shadow(radius: 2)
            .overlay(content: {
                Capsule()
                    .stroke(model.expanded ? model.tint.opacity(0.5) : Color.clear)
            })
            .padding(.top, model.expanded ? topPadding + 50 : topPadding)
            Spacer()
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func centerAligned() -> some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(model.color)
                HStack {
                    model.symbol
                        .foregroundStyle(model.color == .black ? .white : model.tint)
                    Text("\(model.message)")
                        .foregroundStyle(model.color == .black ? .white : model.tint)
                        .lineLimit(1)
                        .opacity(model.expanded ? 1 : 0)
                }
            }
            .blur(radius: model.expanded ? 0 : 8)
            .opacity(!model.expanded ? 0 : 1)
            .frame(width: CGFloat.minimum((UIScreen.current?.bounds.size.width ?? 0) - 40, model.width) - (model.expanded ? 0 : 20), height: model.expanded ? 50 : 40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.15), radius: 4)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(model.tint.opacity(0.5))
                    .opacity(!model.expanded ? 0 : 1)
            })
        }
        .blur(radius: model.expanded ? 0 : 5)
        .ignoresSafeArea()
    }
}


#Preview {
    ToastView(model: .init())
}
