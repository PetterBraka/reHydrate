//
//  CreditsVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/12/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class CreditsVC: UIViewController {
    let toolBar: UIView       = {
        let view             = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .opaqueSeparator
        } else {
            view.backgroundColor = .lightGray
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let exitButton: UIButton  = {
        let button              = UIButton()
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        button.setTitle(NSLocalizedString("Back", comment: "Back button in toolbar"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var darkMode = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return .default
        }
    }
    
    // MARK: - Touch controll
    
    /**
     Will close the toturial view
     */
    @objc func exit(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkMode = UserDefaults.standard.bool(forKey: darkModeString)
        setUpUI()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Set up of UI
    
    /**
     Will set up the UI and must be called at the launche of the view.
     
     # Example #
     ```
     setUpUI()
     ```
     */
    func setUpUI(){
        self.view.addSubview(toolBar)
        toolBar.addSubview(exitButton)
        
        setToolBarConstraints()
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.exit(_:))))
        
        changeAppearance()
    }
    
    // MARK: - Set constraints
    
    /**
     sets all the constraints for the toolBar and all the buttons in it.
     
     # Note #
     This should only be called after the buttons and the toolbar is added to the view
     
     # Example #
     ```
     toturialVC.view.addSubview(toolBar)
     toolBar.addSubview(skipButton)
     toolBar.addSubview(nextButton)
     
     setToolBarConstraints()
     ```
     */
    fileprivate func setToolBarConstraints() {
        toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive      = true
        toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive    = true
        toolBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive                           = true
        exitButton.leftAnchor.constraint(equalTo: toolBar.leftAnchor, constant: 20).isActive    = true
        exitButton.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive            = true
    }
    
    // MARK: - Change appearance
    
    /**
     Will change the appearance of this **UIViewController**
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        if darkMode {
            self.view.backgroundColor  = UIColor().hexStringToUIColor("#212121")
            exitButton.setTitleColor(.white, for: .normal)
            toolBar.backgroundColor    = .darkGray
        } else {
            self.view.backgroundColor  = .white
            exitButton.setTitleColor(.black, for: .normal)
            toolBar.backgroundColor    = UIColor().hexStringToUIColor("#d1d1d1")
        }
    }
}
