//
//  ViewController.swift
//  RandomColorGenerator
//
//  Created by Vlad Munteanu on 3/1/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import UIKit
//import EZSwipeController

class ColorVC: UIViewController {
    
    //main view
    let colorView = ColorView()
    //random button
    unowned var randomButton: UIButton {return colorView.randomButton}
    //save button
    unowned var saveButton: UIButton {return colorView.saveButton}
    
    public override func loadView() {
        self.view = colorView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        self.randomButton.addTarget(self, action: #selector(randomize), for: UIControl.Event.touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveColor), for: UIControl.Event.touchUpInside)
        
    }
    //Save Color
    @objc private func saveColor() {
        
    }
    //Randomize Color
    @objc private func randomize() {
        colorView.updateBackgroundColor() 
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Why are you shaking me?")
            randomize()
        }
    }

}

