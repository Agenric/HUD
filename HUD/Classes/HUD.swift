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

@objcMembers
public class HUD: UIView {
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
    
    convenience fileprivate init(_ message: String, type: HUDType, posi: HUDPosition) {
        self.init(frame: .zero)
        addSubview(contentView)
        contentView.addSubview(messageLabel)
        messageLabel.text = message
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
    
    @discardableResult
    public static func show(_ message: String, in view: UIView = UIWindow.keyWindow(), position posi: HUDPosition = .center, duration interval: TimeInterval = 3, dismissed dism:(() -> ())?) -> HUD? {
        let huds = view.subviews.filter {
            return $0.isKind(of: HUD.self)
        }
        if huds.count > 0 {
            return nil
        }
        let hud = HUD.init(message, type: .toast, posi: posi)
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            hud.dismiss(dism)
        }
        return hud
    }
    
    @discardableResult
    public static func show(_ message: String) -> HUD? {
        return show(message, in: UIWindow.keyWindow(), position: .center, duration: 3, dismissed: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, position posi: HUDPosition) -> HUD? {
        return show(message, in: UIWindow.keyWindow(), position: posi, duration: 3, dismissed: nil)
    }
    
    @discardableResult
    public static func show(_ message: String, duration interval: TimeInterval) -> HUD? {
        return show(message, in: UIWindow.keyWindow(), position: .center, duration: interval, dismissed: nil)
    }
    
    @discardableResult
    public static func showLoading(_ message: String, in view: UIView = UIWindow.keyWindow(), position posi: HUDPosition = .center, showed show:((HUD) -> ())?) -> HUD? {
        let huds = view.subviews.filter {
            return $0.isKind(of: HUD.self)
        }
        if huds.count > 0 {
            return nil
        }
        let hud = HUD.init(message, type: .loading, posi: posi)
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        hud.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hud.contentView.alpha = 1
        }
        show?(hud)
        return hud
    }
    
    @discardableResult
    public static func showLoading(_ message: String) -> HUD? {
        return showLoading(message, showed: nil)
    }
    
    public static func dismiss(from view: UIView = UIWindow.keyWindow()) {
        HUD.dismiss(from: view, dism: nil)
    }
    
    public static func dismiss(from view: UIView = UIWindow.keyWindow(), dism:(() -> ())?) {
        _ = view.subviews.map {
            if let hub = $0 as? HUD {
                hub.dismiss(dism)
            }
        }
    }
    
    public func dismiss() {
        dismiss(nil)
    }
    
    public func dismiss(_ dism:(() -> ())?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            dism?()
        }
    }
}

