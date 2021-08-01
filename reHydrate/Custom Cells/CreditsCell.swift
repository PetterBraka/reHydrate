//
//  CreditsCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 07/12/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class CreditsCell: UITableViewCell {
    enum cellPosition {
        case none
        case top
        case mid
        case bot
    }
    var roundedCell: UIView      = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleOption: UILabel     = {
        let lable   = UILabel()
        lable.text  = "test"
        lable.font  = UIFont(name: "AmericanTypewriter", size: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    var languageImage: UIButton = {
        let button = UIButton()
        button.setTitle("🇬🇧", for: .normal)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: ""), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(named: ""), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var url: String = ""
    var position: cellPosition = .none
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(roundedCell)
        roundedCell.addSubview(titleOption)
        roundedCell.addSubview(languageImage)
        setConstraints()
        separatorInset.right = 20
        separatorInset.left  = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup UI
    
    /// Settes background constraints and rounds the corners depening on the position of the cell.
    func setBackgroundConstraints(){
        self.subviews.forEach({$0.removeConstraints($0.constraints)})
        roundedCell.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive       = true
        roundedCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        roundedCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive    = true
        roundedCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    /// Setting constraints for the background, tilte *UILable* and the button.
    func setConstraints(){
        setBackgroundConstraints()
        titleOption.leftAnchor.constraint(equalTo: roundedCell.leftAnchor, constant: 20).isActive        = true
        titleOption.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive                = true
        languageImage.rightAnchor.constraint(equalTo: roundedCell.rightAnchor, constant: -20).isActive   = true
        languageImage.centerYAnchor.constraint(equalTo: roundedCell.centerYAnchor).isActive              = true
        languageImage.heightAnchor.constraint(equalToConstant: 25).isActive                              = true
    }
    
    /**
     Changes the apparentce of a **SettingOptionCell** deppending on the users preferents.
     
     # Example #
     ```
     settCellAppairents(darkMode)
     ```
     */
    func setCellAppairents(_ dark: Bool){
        if dark{
            titleOption.textColor           = .white
            roundedCell.backgroundColor     = UIColor().hexStringToUIColor("#303030")
            self.backgroundColor            = UIColor().hexStringToUIColor("#212121")
        } else {
            titleOption.textColor           = .black
            roundedCell.backgroundColor     = .white
            self.backgroundColor            = UIColor().hexStringToUIColor("ebebeb")
        }
    }
    
}
