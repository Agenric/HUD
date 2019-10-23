//
//  HUDExtension.swift
//  HUD
//
//  Created by Agenric on 2018/6/6.
//

import UIKit
import Foundation

extension UIFont {
    class func semiboldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        }
        else {
            return UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
}

extension UIColor {
    class func color(withHex hex: Int) -> UIColor {
        return self.color(withHex: hex, alpha: 1.0)
    }
    
    class func color(withHex hex: Int, alpha: CGFloat) -> UIColor {
        let r: Int = (hex >> 16) & 255
        let g: Int = (hex >> 8) & 255
        let b: Int = hex & 255
        let rf = Float(r) / 255.0
        let gf = Float(g) / 255.0
        let bf = Float(b) / 255.0
        return UIColor(red: CGFloat(rf), green: CGFloat(gf), blue: CGFloat(bf), alpha: alpha)
    }
}

public extension UIWindow {
    class func keyWindow() -> UIWindow {
        var keyWindow: UIWindow?
        let frontToBackWindows = UIApplication.shared.windows
        for window: UIWindow in frontToBackWindows {
            let windowOnMainScreen: Bool = window.screen == UIScreen.main
            let windowIsVisible: Bool = !window.isHidden && window.alpha > 0
            let windowLevelNormal: Bool = window.windowLevel == UIWindow.Level.normal
            if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                keyWindow = window
                break
            }
        }
        return keyWindow ?? UIWindow()
    }
}
