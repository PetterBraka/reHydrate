//
//  AppIconCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/06/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class AppIconCell: UITableViewCell {
    
    let title: UILabel     = {
        let lable   = UILabel()
        lable.text  = ""
        lable.font  = UIFont(name: "AmericanTypewriter", size: 20)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let imageForCell: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(title)
        self.addSubview(imageForCell)
        setTitleConstraints()
        setButtonConstraints()
        self.backgroundColor = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .default
        let darkMode = UserDefaults.standard.bool(forKey: darkModeString)
        if selected {
            if darkMode {
                let selectedView = UIView()
                selectedView.backgroundColor = .darkGray
                self.selectedBackgroundView =  selectedView
            } else {
                let selectedView = UIView()
                selectedView.backgroundColor = UIColor().hexStringToUIColor("cccccc")
                self.selectedBackgroundView =  selectedView
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellAppairents(_ dark: Bool){
        if dark{
            imageForCell.tintColor = .lightGray
            title.textColor        = .white
            self.backgroundColor   = UIColor().hexStringToUIColor("#212121")
        } else {
            imageForCell.tintColor = .black
            title.textColor        = .black
            self.backgroundColor   = .white
        }
    }
    
    /**
     Setting constraints for the tilte lable.
     
     # Example #
     ```
     setTitleConstraints()
     ```
     */
    func setTitleConstraints(){
        self.removeConstraints(self.constraints)
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                     = true
    }
    
    
    
    /**
     Setting the constraints for the activate button.
     
     # Example #
     ```
     setActivatedButtonConstraints()
     ```
     */
    func setButtonConstraints() {
        imageForCell.widthAnchor.constraint(equalToConstant: 60).isActive                                    = true
        imageForCell.heightAnchor.constraint(equalToConstant: 60).isActive                                   = true
        imageForCell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive        = true
        imageForCell.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive   = true
        imageForCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
}
