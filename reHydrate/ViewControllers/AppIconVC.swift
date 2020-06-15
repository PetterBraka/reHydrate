//
//  AppIconVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/06/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class AppIconVC: UIViewController{
    let icons = ["Black",
                 "White",
                 "BlueBlack",   "BlueWhite",
                 "GreenBlack",  "GreenWhite",
                 "OrangeBlack", "OrangeWhite",
                 "PinkBlack",   "PinkWhite",
                 "PurpleBlack", "PurpleWhite",
                 "RedBlack",    "RedWhite",
                 "YellowBlack", "YellowWhite"]
    let iconNames = ["Black", "White", "Blue", "Green", "Orange", "Pink", "Purple", "Red", "Yellow"]
    var tableView: UITableView = UITableView()
    var exitButton: UIButton   = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .darkContent
    }
    var darkMode = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
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
        
        let selectedIcon = UIApplication.shared.alternateIconName
        tableView.selectRow(at: IndexPath(row: icons.firstIndex(of: selectedIcon!) ?? 0, section: 0), animated: false, scrollPosition: .none)
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
        if !darkMode {
            self.view.backgroundColor = .white
            tableView.backgroundColor = .white
            exitButton.tintColor      = .black
        } else{
            self.view.backgroundColor = UIColor().hexStringToUIColor("#212121")
            tableView.backgroundColor = UIColor().hexStringToUIColor("#212121")
            exitButton.tintColor      = .lightGray
        }
    }
}

extension AppIconVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppIconCell
        switch indexPath.row {
            case 0:
                cell.title.text = iconNames[0]
            case 1:
                cell.title.text = iconNames[1]
            case 2, 3:
                cell.title.text = iconNames[2]
            case 4, 5:
                cell.title.text = iconNames[3]
            case 6, 7:
                cell.title.text = iconNames[4]
            case 8, 9:
                cell.title.text = iconNames[5]
            case 10, 11:
                cell.title.text = iconNames[6]
            case 12, 13:
                cell.title.text = iconNames[7]
            case 14, 15:
                cell.title.text = iconNames[8]
            default:
            break
        }
        cell.imageForCell.setBackgroundImage(UIImage(named: icons[indexPath.row]), for: .normal)
        if darkMode {
            cell.textLabel?.textColor = .white
            cell.backgroundColor = UIColor().hexStringToUIColor("#212121")
        } else {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName("\(icons[indexPath.row])") { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("selected icon is \(self.icons[indexPath.row])")
                }
            }
        } else {
            print("App does not support alternate icons")
        }
    }
    
}
