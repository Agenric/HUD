//
//  HUD.swift
//  HUD
//
//  Created by Agenric on 2018/6/6.
//

import UIKit
import SnapKit

public enum HUDPosition {
    case center         // 居中
    case bottom         // 沉底，默认距离底部150间距
    case custom(Int)    // 定制，HUD基于父View竖直方向的offset
}

private enum HUDType {
    case toast
    case loading
}

let DefaultInterval: TimeInterval = 3

@objcMembers
public class HUD: UIView {
    
    public var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    private let activityImageView: UIImageView = {
        let activity = UIImageView()
        let myBundle = Bundle.init(path:Bundle.init(for: HUD.self).path(forResource: "HUD", ofType: "bundle")!)!
        activity.image = UIImage.init(named: "hud_loading_routate_image@" + "\(UIScreen.main.scale > 2 ? "3x" : "2x")", in: myBundle, compatibleWith: nil)
        let spring = CABasicAnimation.init(keyPath: "transform.rotation")
        spring.byValue = NSNumber.init(value: 2 * Double.pi)
        spring.repeatCount = MAXFLOAT
        spring.duration = 1
        activity.layer.add(spring, forKey: "startrefresh")
        return activity
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color(withHex: 0x191d21, alpha: 0.85)
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.color(withHex: 0xffffff)
        label.font = .semiboldSystemFont(ofSize: 15)
        label.numberOfLines =  0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience fileprivate init(_ message_: String, type: HUDType, posi: HUDPosition) {
        self.init(frame: .zero)
        addSubview(contentView)
        contentView.addSubview(messageLabel)
        message = message_
        messageLabel.text = message_
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            switch posi {
            case .center:
                make.centerY.equalToSuperview()
            case .bottom:
                make.bottom.equalTo(-150)
            case .custom(let offset):
                make.centerY.equalToSuperview().offset(offset)
            }
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 0.7)
        }
        if type == .loading {
            contentView.addSubview(activityImageView)
            activityImageView.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            })
            
            messageLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(activityImageView.snp.right).offset(5)
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            })
        } else {
            messageLabel.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsetsMake(10, 15, 10, 15))
            })
        }
    }
    
    // Private
    private class func hasHUDDisplay(in view: UIView?) -> Bool {
        var targetView: UIView = UIWindow.keyWindow()
        if view != nil {
            targetView = view!
        }
        var flag = false
        targetView.subviews.forEach { (sub) in
            if sub.isKind(of: HUD.self) {
                flag = true
            }
        }
        return flag
    }
    
    private func show(in view: UIView?) {
        var targetView: UIView = UIWindow.keyWindow()
        if view != nil {
            targetView = view!
        }
        targetView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    // Toast
    @discardableResult
    public static func show(_ message: String) -> HUD? {
        return HUD.show(message, in: nil, position: .center, duration: DefaultInterval, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?) -> HUD? {
        return HUD.show(message, in: view, position: .center, duration: DefaultInterval, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, position: HUDPosition) -> HUD? {
        return HUD.show(message, in: nil, position: position, duration: DefaultInterval, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, duration: TimeInterval) -> HUD? {
        return HUD.show(message, in: nil, position: .center, duration: duration, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: nil, position: .center, duration: DefaultInterval, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?, position: HUDPosition) -> HUD? {
        return HUD.show(message, in: view, position: position, duration: DefaultInterval, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?, duration: TimeInterval) -> HUD? {
        return HUD.show(message, in: view, position: .center, duration: duration, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: view, position: .center, duration: DefaultInterval, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?, position: HUDPosition, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: view, position: position, duration: DefaultInterval, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, in view: UIView?, duration: TimeInterval, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: view, position: .center, duration: duration, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, position: HUDPosition, duration: TimeInterval) -> HUD? {
        return HUD.show(message, in: nil, position: position, duration: duration, completion: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, position: HUDPosition, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: nil, position: position, duration: DefaultInterval, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, position: HUDPosition, duration: TimeInterval, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: nil, position: position, duration: duration, completion: completion)
    }
    
    @discardableResult
    public static func show(_ message: String, duration: TimeInterval, completion: (() -> Void)?) -> HUD? {
        return HUD.show(message, in: nil, position: .center, duration: duration, completion: completion)
    }
    
    /// 弹出即时消息提示框
    ///
    /// - Parameters:
    ///   - message: 提示消息
    ///   - view: 将要加载到的目标View：默认加载在keyWindow上
    ///   - position: 显示的位置：默认居中显示在目标view上
    ///   - duration: 持续时间：默认3秒
    ///   - completion: 显示完成之后的回调
    /// - Returns: 如果当前有正在显示的HUD，会返回nil
    @discardableResult
    public static func show(_ message: String, in view: UIView?, position: HUDPosition, duration: TimeInterval, completion: (() -> Void)?) -> HUD? {
        if hasHUDDisplay(in: view) {
            return nil
        }
        let hud = HUD.init(message, type: .toast, posi: position)
        hud.show(in: view)
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            hud.hideCompletion(completion)
        }
        return hud
    }
    
    
    // Loading
    public static func showLoading(_ message: String) -> HUD? {
        return showLoading(message, in: nil, position: .center, ready: nil)
    }
    
    public static func showLoading(_ message: String, in view: UIView?) -> HUD? {
        return showLoading(message, in: view, position: .center, ready: nil)
    }
    
    public static func showLoading(_ message: String, position: HUDPosition) -> HUD? {
        return showLoading(message, in: nil, position: position, ready: nil)
    }
    
    public static func showLoading(_ message: String, ready: ((_ hud: HUD?) -> Void)?) -> HUD? {
        return showLoading(message, in: nil, position: .center, ready: ready)
    }
    
    public static func showLoading(_ message: String, in view: UIView?, position: HUDPosition) -> HUD? {
        return showLoading(message, in: view, position: position, ready: nil)
    }
    
    public static func showLoading(_ message: String, in view: UIView?, ready: ((_ hud: HUD?) -> Void)?) -> HUD? {
        return showLoading(message, in: view, position: .center, ready: ready)
    }
    
    public static func showLoading(_ message: String, position: HUDPosition, ready: ((_ hud: HUD?) -> Void)?) -> HUD? {
        return showLoading(message, in: nil, position: position, ready: ready)
    }
    
    /**
     弹出持续消息提示框
     
     @param message 提示消息
     @param view 将要加载到的目标View：默认加载在keyWindow上
     @param position 显示的位置：默认居中显示在目标view上
     @param ready 开始显示之后的回调
     @return self：如果当前有正在显示的HUD，会返回nil
     */
    public static func showLoading(_ message: String, in view: UIView?, position: HUDPosition, ready: ((_ hud: HUD?) -> Void)?) -> HUD? {
        if hasHUDDisplay(in: view) {
            return nil
        }
        let hud = HUD.init(message, type: .loading, posi: position)
        hud.show(in: view)
        ready?(hud)
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        return hud
    }
    
    
    // Hide
    public func hide() {
        hideForm(nil, completion: nil)
    }
    
    public func hideForm(_ view: UIView?) {
        hideForm(view, completion: nil)
    }
    
    public func hideCompletion(_ completion: (() -> Void)?) {
        hideForm(nil, completion: completion)
    }
    
    public func hideForm(_ view: UIView?, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    public static func hide() {
        hideForm(nil, completion: nil)
    }
    
    public static func hideForm(_ view: UIView?) {
        hideForm(view, completion: nil)
    }
    
    public static func hideCompletion(_ completion: (() -> Void)?) {
        hideForm(nil, completion: completion)
    }
    
    public static func hideForm(_ view: UIView?, completion: (() -> Void)?) {
        var targetView: UIView = UIWindow.keyWindow()
        if view != nil {
            targetView = view!
        }
        _ = targetView.subviews.map {
            if let hud = $0 as? HUD {
                hud.hideForm(targetView, completion: completion)
            }
        }
    }
}

