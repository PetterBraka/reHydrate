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
    @IBOutlet weak var healthAccessButton: UIButton!
    
    @IBAction func exit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clearData(_ sender: Any) {
        let clearDataAlert = UIAlertController(title: "Clearing data", message: "are you sure you want to delete all save data?", preferredStyle: .alert)
        clearDataAlert.addAction(UIAlertAction(title: "keep data", style: .cancel, handler: nil))
        clearDataAlert.addAction(UIAlertAction(title: "remove data", style: .destructive, handler: {_ in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()}))
        
        self.present(clearDataAlert, animated: true, completion: nil)
    }
    
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
            case healthAccessButton:
                HealthKitManager.init()
            default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
    }
    
    func setUpButtons(){
        helpButton.layer.borderWidth = 3
        helpButton.layer.cornerRadius = 20
        helpButton.layer.borderColor = UIColor.lightGray.cgColor
        helpButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        clearButton.layer.borderWidth = 3
        clearButton.layer.cornerRadius = 20
        clearButton.layer.borderColor = UIColor.red.cgColor
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        healthAccessButton.layer.borderWidth = 3
        healthAccessButton.layer.cornerRadius = 20
        healthAccessButton.layer.borderColor = UIColor.lightGray.cgColor
        healthAccessButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let healthTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let helpTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        healthAccessButton.addGestureRecognizer(healthTapGesture)
        helpButton.addGestureRecognizer(helpTapGesture)
        
    }
}
