//
//  ToastWindow.swift
//  Feast
//
//  Created by Usman Nazir on 06/06/2024.
//

import Foundation
import SwiftUI
import UIKit

public enum ToastType {
    case liquid
    case solid
    case glass
    case drop
}

public class ToastKit {
    public static let shared = ToastKit()
    private static var window: UIWindow? = getWindow()
    private var liquidHostingController: UIHostingController<LiquidToastView>?
    private var standardHostingController: UIHostingController<ToastView>?
    private var blurHostingController: UIHostingController<BlurToastView>?
    private var jellyHostingController: UIHostingController<JellyToastView>?
    private var model = ToastModel()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        deviceOrientationDidChange()
    }
    
    public func configure(type: ToastType = .liquid) {
        guard let window = ToastKit.window else { return }
        if type == .liquid && UIDevice.current.screenType == .dynamicIsland {
            prepareLiquidToast(window: window)
        } else if type == .drop && UIDevice.current.screenType == .dynamicIsland {
            prepareJellyToast(window: window)
        } else {
            if type == .glass {
                prepareBlurToast(window: window)
            } else {
                prepareSolidToast(window: window)
            }
        }
    }
    
    public func disable() {
        ToastKit.window?.isHidden = true
        ToastKit.window = nil
        jellyHostingController = nil
        liquidHostingController = nil
        blurHostingController = nil
        standardHostingController = nil
    }
    
    @MainActor
    public func presentToast(message: String, color: Color = .blue) {
        guard !model.expanded else { return }
        model.message = message
        model.color = color
        withAnimation(.spring) {
            model.expanded = true
        }
        dismissToast()
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
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
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
    }
    
    private func prepareJellyToast(window: UIWindow) {
        let overlayView = JellyToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.jellyHostingController = hostingController
        window.rootViewController = hostingController
    }
    
    private func prepareBlurToast(window: UIWindow) {
        let overlayView = BlurToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.blurHostingController = hostingController
        window.rootViewController = hostingController
    }
    
    private func prepareSolidToast(window: UIWindow) {
        let overlayView = ToastView(model: model)
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        self.standardHostingController = hostingController
        window.rootViewController = hostingController
    }
}

extension ToastKit {
    @objc private func deviceOrientationDidChange() {
        let currentOrientation = UIDevice.current.orientation
        if (blurHostingController != nil) || (standardHostingController != nil) {
            ToastKit.window?.isHidden = false
        } else {
            ToastKit.window?.isHidden = !currentOrientation.isPortrait
        }
        Task { dismissToast }
    }
}
