//
//  ToastView.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//
import SwiftUI
struct BlurToastView: View {
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
        if UIDevice.current.screenType == .none {
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
                    .fill(model.expanded ? model.color.opacity(0.25) : .black)
                Text("\(model.message)")
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .padding(.horizontal, 20)
                    .opacity(model.expanded ? 1 : 0)
                    .blur(radius: model.expanded ? 0 : 10)
            }
            .background(.thinMaterial)
            .opacity(!model.expanded ? 0 : 1)
            .blur(radius: model.expanded ? 0 : 10)
            .frame(width: model.expanded ? CGFloat.minimum((UIScreen.current?.bounds.size.width ?? 0) - 40, model.width) : minimisedWidth, height: model.expanded ? 50 : 35)
            .clipShape(Capsule())
            .shadow(radius: 2)
            .overlay(content: {
                Capsule()
                    .stroke(model.expanded ? Color.primary.opacity(0.5) : Color.clear)
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
                    .fill(model.color.opacity(0.25))
                Text("\(model.message)")
                    .foregroundStyle(.primary)
                    .opacity(model.expanded ? 1 : 0)
                Rectangle()
                    .fill(model.expanded ? .clear : .primary)
                    .colorInvert()
            }
            .background(.ultraThinMaterial)
            .opacity(!model.expanded ? 0 : 1)
            .frame(width: model.expanded ? 220 : minimisedWidth, height: model.expanded ? 50 : 25)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.5))
                    .opacity(!model.expanded ? 0 : 1)
            })
        }
        .ignoresSafeArea()
    }
}


#Preview {
    BlurToastView(model: .init())
}
