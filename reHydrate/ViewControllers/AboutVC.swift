//
//  AboutVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var imageToturial: UIImageView!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBAction func exit(_ sender: UIButton) {
        imageToturial.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            case helpButton:
                print("help pressed")
                imageToturial.isHidden = false
            default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToturial.isHidden = true
        setUpButtons()
        // Do any additional setup after loading the view.
    }
    
    func setUpButtons(){
        helpButton.layer.borderWidth = 3
        helpButton.layer.cornerRadius = 20
        helpButton.layer.borderColor = UIColor.lightGray.cgColor
        helpButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let helpTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        helpButton.addGestureRecognizer(helpTapGesture)
        
    }
}
