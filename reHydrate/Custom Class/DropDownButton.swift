//
//  DropDownButton.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 22/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import Foundation

protocol dropDownMenuProtocol {
    func dropDownOptionPressed(_ optionPressed: String)
}

class DropDownButton: UIButton, dropDownMenuProtocol {
    var dropView = DropDownMenu()
    var height = NSLayoutConstraint()
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dropView = DropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropDownOptionPressed(_ optionPressed: String) {
        self.setTitle(optionPressed, for: .normal)
        self.dismissDropDownMenu()
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 150
//            if self.dropView.tableView.contentSize.height > 150 {
//                self.height.constant = 150
//            } else {
//                self.height.constant = self.dropView.tableView.contentSize.height
//            }
            
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            dismissDropDownMenu()
        }
    }
    
    func dismissDropDownMenu() {
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        isOpen = false
    }
}

class DropDownMenu: UIView, UITableViewDelegate, UITableViewDataSource{
    var dropDownMenuOptions = [String]()
    var tableView = UITableView()
    var delegate: dropDownMenuProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.red
        self.backgroundColor = UIColor.red
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownMenuOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownOptionPressed(dropDownMenuOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

