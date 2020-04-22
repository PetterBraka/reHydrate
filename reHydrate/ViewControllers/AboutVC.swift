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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitButton: UIButton!
    
    enum settingsOptions: String {
        case darkMode = "dark mode"
        case howToUse = "how to use"
        case unitSystem = "unit"
        case changeGoal = "change goal"
        case removeData = "remove old data"
    }
    
    var settings:[String] = [settingsOptions.darkMode.rawValue,
                             settingsOptions.unitSystem.rawValue,
                             settingsOptions.changeGoal.rawValue,
                             settingsOptions.howToUse.rawValue,
                             settingsOptions.removeData.rawValue
    ]
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            //            case helpButton:
            //                print("help pressed")
            //                let helpImage = UIImageView.init(image: UIImage.init(named: "toturial-1"))
            //                self.view.addSubview(helpImage)
            //
            //                helpImage.translatesAutoresizingMaskIntoConstraints = false
            //                helpImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            //                helpImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            //                helpImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor).isActive = true
            //                helpImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            //                helpImage.contentMode = .scaleAspectFit
            //                helpButton.isHidden = true
            //                clearButton.isHidden = true
            //                healthButton.isHidden = true
            //            case healthButton:
            //                UIApplication.shared.open(URL(string: "x-apple-health://")!)
            case exitButton:
                self.dismiss(animated: true, completion: nil)
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapGesture)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AboutVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingsCell
        cell.setLabels(settings[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case settings.firstIndex(of: settingsOptions.howToUse.rawValue):
                print("help pressed")
                let helpImage = UIImageView.init(image: UIImage.init(named: "toturial-1"))
                self.view.addSubview(helpImage)
                
                helpImage.translatesAutoresizingMaskIntoConstraints = false
                helpImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                helpImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                helpImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor).isActive = true
                helpImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                helpImage.contentMode = .scaleAspectFit
                tableView.isHidden = true
            
            case settings.firstIndex(of: settingsOptions.removeData.rawValue):
                // Will clear all the saved data from past days.
                
                let clearDataAlert = UIAlertController(title: "Clearing data", message: "are you sure you want to delete all save data?", preferredStyle: .alert)
                clearDataAlert.addAction(UIAlertAction(title: "keep data", style: .cancel, handler: nil))
                clearDataAlert.addAction(UIAlertAction(title: "REMOVE DATA", style: .destructive, handler: {_ in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()}))
                
                self.present(clearDataAlert, animated: true, completion: nil)
            default:
                break
        }
    }
}
