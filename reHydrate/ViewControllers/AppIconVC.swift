//
//  AppIconVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/06/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class AppIconVC: UIViewController{
    let primaryIcons = ["white-grey"   , "grey-white"   , "black-white"  ]
    let blueIcons    = ["white-blue"   , "blue-white"   , "black-blue"   ]
    let greenIcons   = ["white-green"  , "green-white"  , "black-green"  ]
    let orangeIcons  = ["white-orange" , "orange-white" , "black-orange" ]
    let pinkIcons    = ["white-pink"   , "pink-white"   , "black-pink"   ]
    let purpleIcons  = ["white-purple" , "purple-white" , "black-purple" ]
    let redIcons     = ["white-red"    , "red-white"    , "black-red"    ]
    let yellowIcons  = ["white-yellow" , "yellow-white" , "black-yellow" ]
    let rainbowIcons = ["white-rainbow", "rainbow-white", "black-rainbow"]
    var icons: [[String]] = []
    var tableView: UITableView = UITableView()
    var darkMode = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var exitButton: UIButton   = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: "xmark.circle"), for: .normal)
        }
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return .lightContent
        }
    }
    
    @objc func tap(sender: UIGestureRecognizer){
        if sender.view == exitButton{
            let transition      = CATransition()
            transition.duration = 0.6
            transition.type     = .push
            transition.subtype  = .fromBottom
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icons = [primaryIcons, redIcons, orangeIcons,
                 yellowIcons, greenIcons, blueIcons,
                 purpleIcons, pinkIcons, rainbowIcons]
        setUpUI()
    }
    
    //MARK: - Set up of UI
    
    /**
     Will set up the UI and must be called at the launche of the view.
     
     # Example #
     ```
     setUpUI()
     ```
     */
    func setUpUI(){
        self.view.addSubview(exitButton)
        self.view.addSubview(tableView)
        
        darkMode = UserDefaults.standard.bool(forKey: darkModeString)
        
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapRecognizer)
        
        setConstraints()
        changeAppearance()
        tableView.register(AppIconCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
    }
    
    /**
     Will sett the constraints for all the views in the view.
     
     # Notes: #
     1. The setUPUI must be called first and add all of the views.
     
     # Example #
     ```
     func setUpUI(){
     //Add the views
     setConstraints()
     }
     ```
     */
    func setConstraints(){
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Change appearance
    
    /**
     Changing the appearance of the app deppending on if the users prefrence for dark mode or light mode.
     
     # Notes: #
     1. This will change all the colors off this screen.
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        if darkMode {
            self.view.backgroundColor = UIColor().hexStringToUIColor("#212121")
            tableView.backgroundColor = UIColor().hexStringToUIColor("#212121")
            if #available(iOS 13, *) {
                exitButton.tintColor      = .lightGray
            } else {
                exitButton.setBackgroundImage(UIImage(named: "xmark.circle")?.colored(.gray), for: .normal)
            }
        } else{
            self.view.backgroundColor = .white
            tableView.backgroundColor = .white
            if #available(iOS 13, *) {
                exitButton.tintColor      = .black
            } else {
                exitButton.setBackgroundImage(UIImage(named: "xmark.circle")?.colored(.black), for: .normal)
            }
        }
    }
}

extension AppIconVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppIconCell
        print("section:\(indexPath.section) - row:\(indexPath.row)")
        cell.cellImage0.setImage(UIImage(named: icons[indexPath.row][0]), for: .normal)
        cell.cellImage1.setImage(UIImage(named: icons[indexPath.row][1]), for: .normal)
        cell.cellImage2.setImage(UIImage(named: icons[indexPath.row][2]), for: .normal)
        cell.cellImage0.setTitle(icons[indexPath.row][0], for: .normal)
        cell.cellImage1.setTitle(icons[indexPath.row][1], for: .normal)
        cell.cellImage2.setTitle(icons[indexPath.row][2], for: .normal)
        let selectedIcon = UIApplication.shared.alternateIconName ?? "black-white"
        switch selectedIcon {
        case cell.cellImage0.titleLabel!.text:
            cell.cellImage0.layer.borderWidth = 5
            cell.cellImage0.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
            cell.cellImage1.layer.borderWidth = 1
            cell.cellImage1.layer.borderColor = UIColor.black.cgColor
            cell.cellImage2.layer.borderWidth = 1
            cell.cellImage2.layer.borderColor = UIColor.black.cgColor
        case cell.cellImage1.titleLabel!.text:
            cell.cellImage0.layer.borderWidth = 1
            cell.cellImage0.layer.borderColor = UIColor.black.cgColor
            cell.cellImage1.layer.borderWidth = 5
            cell.cellImage1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
            cell.cellImage2.layer.borderWidth = 1
            cell.cellImage2.layer.borderColor = UIColor.black.cgColor
        case cell.cellImage2.titleLabel!.text:
            cell.cellImage0.layer.borderWidth = 1
            cell.cellImage0.layer.borderColor = UIColor.black.cgColor
            cell.cellImage1.layer.borderWidth = 1
            cell.cellImage1.layer.borderColor = UIColor.black.cgColor
            cell.cellImage2.layer.borderWidth = 5
            cell.cellImage2.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        default:
            cell.cellImage0.layer.borderWidth = 1
            cell.cellImage0.layer.borderColor = UIColor.black.cgColor
            cell.cellImage1.layer.borderWidth = 1
            cell.cellImage1.layer.borderColor = UIColor.black.cgColor
            cell.cellImage2.layer.borderWidth = 1
            cell.cellImage2.layer.borderColor = UIColor.black.cgColor
        }
        cell.setCellAppairents(darkMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
