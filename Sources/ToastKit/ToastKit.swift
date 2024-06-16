//
//  ToastWindow.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import Foundation
import SwiftUI
import UIKit

public enum ToastType: Equatable {
    case liquid
    case solid(centred: Bool)
    case glass(centred: Bool)
    case drop
}

public class ToastKit {
    private static let shared = ToastKit()
    private static var window: UIWindow? = getWindow()
    private var liquidHostingController: UIHostingController<LiquidToastView>?
    private var standardHostingController: UIHostingController<ToastView>?
    private var blurHostingController: UIHostingController<BlurToastView>?
    private var jellyHostingController: UIHostingController<JellyToastView>?
    private var model = ToastModel()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOrientationView), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    /// Configures ToastKit and prepares the views needed to overlay the toasts.
    /// - Parameter type: Type of toast to be presented. Default value is ``ToastType.glass``
    public static func configure(type: ToastType = .glass(centred: false), width: CGFloat = 250.0) {
        guard let window = ToastKit.window else { return }
        shared.model.width = width
        if type == .liquid && UIDevice.current.screenType == .dynamicIsland {
            shared.prepareLiquidToast(window: window)
        } else if type == .drop && UIDevice.current.screenType != .none {
            shared.prepareJellyToast(window: window)
        } else {
            switch type {
            case .solid(let centred):
                shared.prepareSolidToast(window: window, centered: centred)
            case .glass(let centred):
                shared.prepareBlurToast(window: window, centered: centred)
            default:
                shared.prepareBlurToast(window: window)
            }
        }
    }
    
    public static func disable() {
        ToastKit.window?.isHidden = true
        ToastKit.window = nil
        shared.jellyHostingController = nil
        shared.liquidHostingController = nil
        shared.blurHostingController = nil
        shared.standardHostingController = nil
    }
    
    /// Presents a toast overlay in the configured style.
    /// - Parameters:
    ///   - message: A text stting that should be presented.
    ///   - color: Background tint of the toast. This is only applicable when presenting Glass or Solid toasts.
    public static func present(message: String, symbol: Image? = nil, color: Color = .blue) {
        Task { @MainActor in
            guard !shared.model.expanded else { return }
            shared.model.message = message
            shared.model.symbol = symbol
            shared.model.color = color
            withAnimation(.spring) {
                shared.model.expanded = true
            }
            shared.dismissToast()
        }
    }
    
    @MainActor
    private func dismissToast() {
        Task { [weak self] in
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds in nanoseconds
            await MainActor.run {
                withAnimation {
                    self?.model.expanded = false
                }
            }
        }
    }
}

extension ToastKit {
    
    private static func getWindow() -> UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene
        guard let windowScene = windowScene else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = false
        window.isHidden = false
        return window
    }
    
    private func prepareLiquidToast(window: UIWindow) {
        let overlayView = LiquidToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.liquidHostingController = hostingController
        window.rootViewController = hostingController
        model.toastType = .liquid
    }
    
    private func prepareJellyToast(window: UIWindow) {
        let overlayView = JellyToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.jellyHostingController = hostingController
        window.rootViewController = hostingController
        model.toastType = .drop
    }
    
    private func prepareBlurToast(window: UIWindow, centered: Bool = false) {
        let overlayView = BlurToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.blurHostingController = hostingController
        window.rootViewController = hostingController
        model.toastType = .glass(centred: centered)
    }
    
    private func prepareSolidToast(window: UIWindow, centered: Bool = false) {
        let overlayView = ToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.standardHostingController = hostingController
        window.rootViewController = hostingController
        model.toastType = .solid(centred: centered)
    }
}

extension ToastKit {
    @objc private func refreshOrientationView() {
        let currentOrientation = UIDevice.current.orientation
        if model.toastType == .drop || model.toastType == .liquid {
            ToastKit.window?.isHidden = !currentOrientation.isPortrait
        } else {
            ToastKit.window?.isHidden = false
        }
        Task { dismissToast }
    }
}
