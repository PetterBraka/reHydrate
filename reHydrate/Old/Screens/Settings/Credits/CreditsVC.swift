////
////  CreditsVC.swift
////  reHydrate
////
////  Created by Petter vang Brakalsvålet on 06/12/2020.
////  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
////
//
//import UIKit
//import SwiftyUserDefaults
//
//
//struct credit {
//    var name:  String
//    var webpage: String
//    var language: String
//}
//
//class CreditsVC: UIViewController {
//    let toolBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = .opaqueSeparator
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    let exitButton: UIButton  = {
//        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
//        button.contentMode = .scaleAspectFit
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    var darkMode = true {
//        didSet {
//            self.overrideUserInterfaceStyle = darkMode ? .dark : .light
//            self.setNeedsStatusBarAppearanceUpdate()
//        }
//    }
//    var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return darkMode ? .lightContent : .darkContent
//    }
//    
//    let creator =
//        [credit(name: "Petter Vang Braklsvålet", webpage: "https://petterbraka.github.io/LinkTree/", language: "🌐 🇳🇴")]
//    let translators =
//        [credit(name: "Leo Mehing", webpage: "https://structured.today", language: "🌐 🇩🇪"),
//         credit(name: "Sævar Ingi Siggason", webpage: "", language: "🇮🇸"),
////         credit(name: "Preben Vangberg", webpage: "", language: "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
//        ]
//    let openSource =
//        [credit(name: "WenchaoD/FSCalendar", webpage: "https://github.com/WenchaoD/FSCalendar", language: "🌐"),
//         credit(name: "HeroTransitions/Hero", webpage: "https://github.com/HeroTransitions/Hero", language: "🌐")
//        ]
//    
//    // MARK: - Touch controll
//    
//    /**
//     Will close the  view
//     */
//    @objc func exit(_ sender: UIBarButtonItem){
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        darkMode = Defaults[\.darkMode]
//        setUpUI()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    // MARK: - Set up of UI
//    
//    /**
//     Will set up the UI and must be called at the launche of the view.
//     
//     # Example #
//     ```
//     setUpUI()
//     ```
//     */
//    func setUpUI(){
//        self.view.addSubview(toolBar)
//        self.view.addSubview(tableView)
//        toolBar.addSubview(exitButton)
//        
//        setToolBarConstraints()
//        setConstraints()
//        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.exit(_:))))
//        
//        tableView.register(CreditsHeder.self, forHeaderFooterViewReuseIdentifier: "header")
//        tableView.register(CreditsCell.self, forCellReuseIdentifier: "creditsCell")
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        setAppearance()
//    }
//    
//    // MARK: - Set constraints
//    
//    /**
//     sets all the constraints for the toolBar and all the buttons in it.
//     
//     # Note #
//     This should only be called after the buttons and the toolbar is added to the view
//     
//     # Example #
//     ```
//     toturialVC.view.addSubview(toolBar)
//     toolBar.addSubview(skipButton)
//     toolBar.addSubview(nextButton)
//     
//     setToolBarConstraints()
//     ```
//     */
//    fileprivate func setToolBarConstraints() {
//        toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        toolBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        exitButton.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
//        exitButton.leftAnchor.constraint(equalTo: toolBar.leftAnchor, constant: 20).isActive = true
//    }
//    
//    fileprivate func setConstraints(){
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: exitButton.bottomAnchor,constant: 8).isActive = true
//    }
//    
//    // MARK: - Change appearance
//    
//    /**
//     Will change the appearance of this **UIViewController**
//     
//     # Example #
//     ```
//     setAppearance()
//     ```
//     */
//    func setAppearance(){
//        tableView.separatorStyle = .none
//        self.view.backgroundColor  = UIColor.tableViewBackground
//        exitButton.tintColor = darkMode ? .lightGray : .black
//        toolBar.backgroundColor = UIColor.tableViewBackground
//        tableView.backgroundColor = UIColor.tableViewBackground
//    }
//}
//
//extension CreditsVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return creator.count
//        case 1:
//            return translators.count
//        case 2:
//            return openSource.count
//        default:
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "creditsCell") as! CreditsCell
//        cell.selectionStyle = .none
//        cell.setCellAppairents(darkMode)
//        switch indexPath.section {
//        case 0:
//            cell.titleOption.text = creator[indexPath.row].name
//            cell.languageImage.setTitle(creator[indexPath.row].language, for: .normal)
//            cell.url = creator[indexPath.row].webpage
//        case 1:
//            cell.titleOption.text = translators[indexPath.row].name
//            cell.languageImage.setTitle(translators[indexPath.row].language, for: .normal)
//            cell.url = translators[indexPath.row].webpage
//        case 2:
//            cell.titleOption.text = openSource[indexPath.row].name
//            cell.languageImage.setTitle(openSource[indexPath.row].language, for: .normal)
//            cell.url = openSource[indexPath.row].webpage
//        default:
//            cell.titleOption.text = creator[indexPath.row].name
//            cell.languageImage.setTitle(creator[indexPath.row].language, for: .normal)
//            cell.url = creator[indexPath.row].webpage
//        }
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        3
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CreditsHeder
//        switch section {
//        case 0:
//            cell.title.text = NSLocalizedString("Dev&Design", comment: "title for header")
//        case 1:
//            cell.title.text = NSLocalizedString("Translation", comment: "title for header")
//        case 2:
//            cell.title.text = NSLocalizedString("Open-source", comment: "title for header")
//        default:
//            cell.title.text = ""
//        }
//        cell.setAppairents(darkMode)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! CreditsCell
//        if let url = URL(string: cell.url) {
//            UIApplication.shared.open(url)
//        }
//    }
//}
