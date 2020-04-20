//
//  AboutVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
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
                
            default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        // Do any additional setup after loading the view.
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
        
        let helpTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        helpButton.addGestureRecognizer(helpTapGesture)
        
    }
}
