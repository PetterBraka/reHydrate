//
//  AboutVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    
    /**
     Will clear all the saved data from past days.
     
     - parameter sender: - **view** that called the function.
     
     # Notes: #
     1. will remove all the saved data.
     
     */
    @IBAction func clearData(_ sender: Any) {
        let clearDataAlert = UIAlertController(title: "Clearing data", message: "are you sure you want to delete all save data?", preferredStyle: .alert)
        clearDataAlert.addAction(UIAlertAction(title: "keep data", style: .cancel, handler: nil))
        clearDataAlert.addAction(UIAlertAction(title: "remove data", style: .destructive, handler: {_ in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()}))
        
        self.present(clearDataAlert, animated: true, completion: nil)
    }
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            case helpButton:
                print("help pressed")
                let helpImage = UIImageView.init(image: UIImage.init(named: "toturial-1"))
                self.view.addSubview(helpImage)
                
                helpImage.translatesAutoresizingMaskIntoConstraints = false
                helpImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                helpImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                helpImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor).isActive = true
                helpImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                helpImage.contentMode = .scaleAspectFit
                helpButton.isHidden = true
                clearButton.isHidden = true
                healthButton.isHidden = true
            case healthButton:
                UIApplication.shared.open(URL(string: "x-apple-health://")!)
            case exitButton:
                self.dismiss(animated: true, completion: nil)
            default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
    }
    
    /**
     Setting upp the listeners and aperients of the buttons.
     
     # Example #
     ```
     override func viewDidLoad() {
     super.viewDidLoad()
     setUpButtons()
     }
     ```
     */
    func setUpButtons(){
        helpButton.layer.borderWidth = 3
        helpButton.layer.cornerRadius = 20
        helpButton.layer.borderColor = UIColor.lightGray.cgColor
        helpButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        clearButton.layer.borderWidth = 3
        clearButton.layer.cornerRadius = 20
        clearButton.layer.borderColor = UIColor.red.cgColor
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        healthButton.layer.borderWidth = 3
        healthButton.layer.cornerRadius = 20
        healthButton.layer.borderColor = UIColor.lightGray.cgColor
        healthButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let healthTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let helpTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapGesture)
        healthButton.addGestureRecognizer(healthTapGesture)
        helpButton.addGestureRecognizer(helpTapGesture)
        
    }
}
