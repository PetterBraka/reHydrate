//
//  AboutVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import HealthKit


struct settingOptions {
    var isOpened: 	Bool
    var setting: 	String
    var options: 	[String]
}

class AboutVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitButton: UIButton!
    
    
    let helpImage 					= UIImageView.init(image: UIImage.init(named: "toturial-1"))
    var selectedRow: IndexPath 		= IndexPath()
    var settings: [settingOptions] 	= [
        settingOptions(isOpened: false, setting: "appearance", options: ["light mode", "dark mode"]),
        settingOptions(isOpened: false, setting: "unit system", options: ["liters & milli liters", "ounzes"]),
        settingOptions(isOpened: false, setting: "change goal", options: ["goal"]),
        settingOptions(isOpened: false, setting: "how to use", options: []),
        settingOptions(isOpened: false, setting: "remove data", options: [])]
    
    
    /**
     Will check which **view** that called this function.
     
     - parameter sender: - **view** that called the function.
     
     */
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
            case exitButton:
                self.dismiss(animated: true, completion: nil)
            case helpImage:
                helpImage.removeFromSuperview()
                tableView.isHidden = false
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exitTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let helpTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        exitButton.addGestureRecognizer(exitTapRecognizer)
        helpImage.addGestureRecognizer(helpTapRecognizer)
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: "settingCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func expandOrCollapsSection(_ sender: UIGestureRecognizer){
        guard let section = sender.view?.tag else { return }
        switch section {
            case settings.firstIndex(where: {$0.setting == "how to use"}):
                print("help pressed")
                self.view.addSubview(helpImage)
                
                helpImage.translatesAutoresizingMaskIntoConstraints 								= false
                helpImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive 		= true
                helpImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive 	= true
                helpImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor).isActive 		= true
                helpImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive 		= true
                helpImage.isUserInteractionEnabled 													= true
                helpImage.contentMode 																= .scaleAspectFit
                tableView.isHidden 																	= true
            
            case settings.firstIndex(where: {$0.setting == "remove data"}):
                // This will clear all the saved data from past days.
                let clearDataAlert = UIAlertController(title: "Clearing data", message: "are you sure you want to delete all save data?", preferredStyle: .alert)
                clearDataAlert.addAction(UIAlertAction(title: "keep data", style: .cancel, handler: nil))
                clearDataAlert.addAction(UIAlertAction(title: "REMOVE DATA", style: .destructive, handler: {_ in
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()}))
                
                self.present(clearDataAlert, animated: true, completion: nil)
            default:
                var indexPaths 				= [IndexPath]()
                for row in settings[section].options.indices {
                    let indexPath 			= IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                let ioOpend 				= settings[section].isOpened
                settings[section].isOpened 	= !ioOpend
                if ioOpend {
                    tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    tableView.insertRows(at: indexPaths, with: .fade)
            }
        }
    }
}

extension AboutVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell 		= tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingOptionCell
        cell.setting 	= settings[indexPath.section].options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].isOpened ? settings[section].options.count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell 			= tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingsHeader
        cell.setting 		= settings[section]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrCollapsSection)))
        cell.tag 			= section
        switch cell.title.text?.uppercased() {
            case String("remove data").uppercased():
                cell.title.textColor = .systemRed
            default:
            break
        }
        if settings[section].options.isEmpty{
            cell.button.removeFromSuperview()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView 					= UIView()
        let separatorView 				= UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        separatorView.backgroundColor 	= UIColor.lightGray
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

