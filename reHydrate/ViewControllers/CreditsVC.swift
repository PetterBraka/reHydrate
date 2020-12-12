//
//  CreditsVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/12/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit


struct credit {
    var name:  String
    var webpage: String
    var language: String
}

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
    var tableView: UITableView     = UITableView()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return darkMode ? .lightContent : .darkContent
        } else {
            return .default
        }
    }
    
    let credits: [credit] =
        [credit(name: "Petter Vang Braklsvålet", webpage: "https://petterbraka.github.io/LinkTree/", language: "🌐 🇳🇴"),
         credit(name: "Leo Mehing", webpage: "https://petterbraka.github.io/LinkTree/", language: "🌐 🇩🇪"),
         credit(name: "Preben Vangberg", webpage: "", language: "🏴󠁧󠁢󠁷󠁬󠁳󠁿"),
         credit(name: "Sævar Ingi Siggason", webpage: "https://petterbraka.github.io/LinkTree/", language: "🇮🇸"),
         credit(name: "WenchaoD/FSCalendar", webpage: "https://github.com/WenchaoD/FSCalendar", language: "🌐"),
         credit(name: "HeroTransitions/Hero", webpage: "https://github.com/HeroTransitions/Hero", language: "🌐")]
    
    // MARK: - Touch controll
    
    /**
     Will close the  view
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
        self.view.addSubview(tableView)
        toolBar.addSubview(exitButton)
        
        setToolBarConstraints()
        setConstraints()
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.exit(_:))))
        
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(CreditsCell.self, forCellReuseIdentifier: "creditsCell")
        
        tableView.dataSource = self
        tableView.delegate   = self
        
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
    
    fileprivate func setConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: exitButton.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
        tableView.separatorStyle = .none
        if darkMode {
            self.view.backgroundColor  = UIColor().hexStringToUIColor("#212121")
            exitButton.setTitleColor(.white, for: .normal)
            toolBar.backgroundColor    = UIColor().hexStringToUIColor("212121")
            tableView.backgroundColor  = UIColor().hexStringToUIColor("#212121")
        } else {
            self.view.backgroundColor  = .white
            exitButton.setTitleColor(.black, for: .normal)
            toolBar.backgroundColor    = .white
            tableView.backgroundColor  = UIColor().hexStringToUIColor("ebebeb")
        }
    }
}

extension CreditsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditsCell") as! CreditsCell
        cell.selectionStyle = .none
        cell.setCellAppairents(darkMode)
        cell.titleOption.text = credits[indexPath.row + indexPath.section].name
        cell.languageImage.setTitle(credits[indexPath.row + indexPath.section].language, for: .normal)
        switch indexPath {
        case IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2):
            cell.position = .top
        case IndexPath(row: 1, section: 1):
            cell.position = .mid
        case IndexPath(row: 2, section: 1), IndexPath(row: 1, section: 2):
            cell.position = .bot
        default:
            cell.position = .none
        }
        cell.setConstraints()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingsHeader
        cell.setHeaderAppairents(darkMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
