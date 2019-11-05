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

public let DefaultInterval: TimeInterval = 3

@objcMembers
public class HUD: UIView {
    
    public var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    private var loadingImage: UIImage?
    
    private let contentView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .dark {
                    return .color(withHex: 0xffffff, alpha: 0.85)
                } else {
                    return .color(withHex: 0x191d21, alpha: 0.85)
                }
            }
        } else {
            view.backgroundColor = .color(withHex: 0x191d21)
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .dark {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            label.textColor = .white
        }
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
    
    convenience fileprivate init(_ message_: String, image: UIImage?, type: HUDType, posi: HUDPosition) {
        self.init(frame: .zero)
        addSubview(contentView)
        contentView.addSubview(messageLabel)
        loadingImage = image
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
            let activity = generalActivityView()
            contentView.addSubview(activity.0)
            activity.0.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
                make.size.equalTo(activity.1)
                make.top.greaterThanOrEqualToSuperview().offset(10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            })
            
            messageLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(activity.0.snp.right).offset(5)
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(10)
                make.bottom.lessThanOrEqualToSuperview().offset(-10)
            })
        } else {
            messageLabel.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 15))
            })
        }
    }
    
    //MARK: Private
    private class func hasHUDDisplaying(in view: UIView) -> Bool {
        var flag = false
        view.subviews.forEach { (sub) in
            if sub.isKind(of: HUD.self) {
                flag = true
            }
        }
        return flag
    }
    
    private func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func generalActivityView() -> (UIView, CGSize) {
        if let loadingImage = loadingImage {
            let activity = UIImageView(image: loadingImage)
            let spring = CABasicAnimation.init(keyPath: "transform.rotation")
            spring.byValue = NSNumber.init(value: 2 * Double.pi)
            spring.repeatCount = MAXFLOAT
            spring.duration = 1
            activity.layer.add(spring, forKey: "startrefresh")
            return (activity, loadingImage.size)
        } else {
            let activity = UIActivityIndicatorView()
            if #available(iOS 13.0, *) {
                activity.style = .medium
                activity.color = UIColor { (trainCollection) -> UIColor in
                    if trainCollection.userInterfaceStyle == .dark {
                        return .black
                    } else {
                        return .white
                    }
                }
            } else {
                activity.style = .white
                activity.color = .white
            }
            activity.startAnimating()
            return (activity, CGSize(width: 30,height: 30))
        }
    }
    
    
    //MARK: Toast
    
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
    public static func show(_ message: String, in view: UIView = UIWindow.keyWindow(), position: HUDPosition = .center , duration: TimeInterval = DefaultInterval, completion: (() -> Void)?) -> HUD? {
        if hasHUDDisplaying(in: view) {
            return nil
        }
        let hud = HUD.init(message, image: nil, type: .toast, posi: position)
        hud.show(in: view)
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            hud.hide(completion)
        }
        return hud
    }
    
    
    //MARK: Loading
    
    /// 弹出持续消息提示框
    ///
    /// - Parameters:
    ///   - message: 提示消息
    ///   - view: 将要加载到的目标View：默认加载在keyWindow上
    ///   - position: 显示的位置：默认居中显示在目标view上
    ///   - ready: 开始显示之后的回调
    /// - Returns: 如果当前有正在显示的HUD，会返回nil
    public static func showLoading(_ message: String, image: UIImage? = nil, in view: UIView = UIWindow.keyWindow(), position: HUDPosition = .center, ready: ((_ hud: HUD?) -> Void)?) -> HUD? {
        if hasHUDDisplaying(in: view) {
            return nil
        }
        let hud = HUD.init(message, image: image, type: .loading, posi: position)
        hud.show(in: view)
        ready?(hud)
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        return hud
    }
    
    
    //MARK: Hide
    public func hide(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    public static func hide(_ fromView: UIView = UIWindow.keyWindow(), completion: (() -> Void)?) {
        _ = fromView.subviews.map {
            if let hud = $0 as? HUD {
                hud.hide(completion)
            }
        }
    }
}

