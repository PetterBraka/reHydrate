//
//  AppIconCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/06/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit


class AppIconCell: UITableViewCell {
    let imageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis         = .horizontal
        stack.spacing      = 40
        stack.alignment    = .center
        stack.contentMode  = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let cellImage0: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let cellImage1: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let cellImage2: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageStack.addArrangedSubview(cellImage0)
        imageStack.addArrangedSubview(cellImage1)
        imageStack.addArrangedSubview(cellImage2)
        self.contentView.addSubview(imageStack)
        setButtonConstraints()
        setImageStackConstraints()
        setTapReqognitions()
        self.backgroundColor = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTapReqognitions(){
        let image0TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let image1TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        let image2TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        cellImage0.addGestureRecognizer(image0TapRecognizer)
        cellImage1.addGestureRecognizer(image1TapRecognizer)
        cellImage2.addGestureRecognizer(image2TapRecognizer)
    }
    
    @objc func tap(_ sender: UIGestureRecognizer){
        if UIApplication.shared.supportsAlternateIcons {
            switch sender.view {
            case cellImage0:
                print("\(cellImage0.title(for: .normal) ?? "")")
                UIApplication.shared.setAlternateIconName("\(cellImage0.title(for: .normal) ?? "black-white")") { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Selected icon is \(self.cellImage0.title(for: .normal) ?? "black-white")")
                    }
                }
            case cellImage1:
                UIApplication.shared.setAlternateIconName("\(cellImage1.title(for: .normal) ?? "black-white")") { [self] (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Selected icon is \(self.cellImage1.title(for: .normal) ?? "black-white")")
                    }
                }
            case cellImage2:
                UIApplication.shared.setAlternateIconName("\(cellImage2.title(for: .normal) ?? "black-white")") { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Selected icon is \(self.cellImage2.title(for: .normal) ?? "black-white")")
                    }
                }
            default:
                UIApplication.shared.setAlternateIconName("black-white") { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Selected icon is black-white")
                    }
                }
            }
        } else {
            print("App does not support alternate icons")
        }
    }
    
    func setCellAppairents(_ dark: Bool){
        if dark{
            cellImage0.tintColor = .lightGray
            cellImage1.tintColor = .lightGray
            cellImage2.tintColor = .lightGray
            self.backgroundColor   = UIColor().hexStringToUIColor("#212121")
        } else {
            cellImage0.tintColor = .black
            cellImage1.tintColor = .black
            cellImage2.tintColor = .black
            self.backgroundColor = .white
        }
    }
    
    /**
     Setting the constrains for a *UIStackView*

     # Example #
     ```
     setImageStackConstraints()
     ```
     */
    func setImageStackConstraints(){
        imageStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive        = true
        imageStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        imageStack.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
    
    /**
     Setting the constraints for the *UIbuttons* in cell.

     # Example #
     ```
     setButtonConstraints()
     ```
     */
    func setButtonConstraints() {
        cellImage0.widthAnchor.constraint(equalToConstant: 80).isActive   = true
        cellImage0.heightAnchor.constraint(equalToConstant: 80).isActive  = true

        cellImage1.widthAnchor.constraint(equalToConstant: 80).isActive   = true
        cellImage1.heightAnchor.constraint(equalToConstant: 80).isActive  = true

        cellImage2.widthAnchor.constraint(equalToConstant: 80).isActive   = true
        cellImage2.heightAnchor.constraint(equalToConstant: 80).isActive  = true
    }
}
