//
//  ViewController.swift
//  HUD
//
//  Created by AgenricWon on 06/06/2018.
//  Copyright (c) 2018 AgenricWon. All rights reserved.
//

import UIKit
import AGHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func Toast(_ sender: Any) {
//        HUD.show("Toast-Message") {
//            print("Toast callback")
//        }
        
        HUD.show("NEW-TOAST-MESSAGE", in: view, duration: 7) {
            print("Toast callback")
        }
//        HUD.dismiss()
    }
    
    
    @IBAction func Loading(_ sender: Any) {
        
//        let hud = HUD.showLoading("Loading-Message")
        
        
        let hud = HUD.showLoading("LoadingMessageLoadingMessageLoadingMessageLoadingMeeLoadingMeeLoadingMeeLoadingMessage") { (hud) in
            print("show complete")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud?.message = "sadsada"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            hud?.hide({
                print("dismiss complete")
            })
        }
        
    }
}

