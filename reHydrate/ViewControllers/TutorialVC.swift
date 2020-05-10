//
//  ToturialVC.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 07/05/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {
    let toolBar: UIView       = {
        let view             = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let skipButton: UIButton  = {
        let button              = UIButton()
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        button.setTitle("skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let nextButton: UIButton  = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        button.setTitle("next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let dayLable: UILabel     = {
        let lable           = UILabel()
        lable.textAlignment = .center
        lable.text          = "Monday - 05/10/20"
        lable.font          = UIFont(name: "AmericanTypeWriter-Bold", size: 20)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let summaryLable: UILabel = {
        let lable             = UILabel()
        lable.text            = "1.25 / 3L"
        lable.font            = UIFont(name: "AmericanTypeWriter-Bold", size: 40)
        lable.textAlignment   = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let drinkOptionStack: UIStackView = {
        let stack               = UIStackView()
        stack.axis              = .horizontal
        stack.spacing           = 15
        stack.alignment         = .bottom
        stack.distribution      = .equalSpacing
        let smallDrink          = UIImageView()
        smallDrink.image        = UIImage(named: "Glass")
        smallDrink.contentMode  = .scaleAspectFit
        let mediumDrink         = UIImageView()
        mediumDrink.image       = UIImage(named: "Bottle")
        mediumDrink.contentMode = .scaleAspectFit
        let largeDrink          = UIImageView()
        largeDrink.image        = UIImage(named: "Flask")
        largeDrink.contentMode  = .scaleAspectFit
        
        smallDrink.translatesAutoresizingMaskIntoConstraints  = false
        mediumDrink.translatesAutoresizingMaskIntoConstraints = false
        largeDrink.translatesAutoresizingMaskIntoConstraints  = false
        stack.addArrangedSubview(smallDrink)
        stack.addArrangedSubview(mediumDrink)
        stack.addArrangedSubview(largeDrink)
        smallDrink.heightAnchor.constraint(equalToConstant: 70).isActive   = true
        smallDrink.widthAnchor.constraint(equalToConstant: 50).isActive    = true
        mediumDrink.heightAnchor.constraint(equalToConstant: 120).isActive = true
        mediumDrink.widthAnchor.constraint(equalToConstant: 80).isActive   = true
        largeDrink.heightAnchor.constraint(equalToConstant: 140).isActive  = true
        largeDrink.widthAnchor.constraint(equalToConstant: 80).isActive    = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let smallDrinkLable: UILabel  = {
        let lable           = UILabel()
        lable.textAlignment = .center
        lable.text          = "300ml"
        lable.font          = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let mediumDrinkLable: UILabel = {
        let lable           = UILabel()
        lable.textAlignment = .center
        lable.text          = "500ml"
        lable.font          = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let largeDrinkLable: UILabel  = {
        let lable           = UILabel()
        lable.textAlignment = .center
        lable.text          = "750ml"
        lable.font          = UIFont(name: "AmericanTypeWriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let settingsButton: UIButton  = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints             = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    let calendarButton: UIButton  = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar.circle"), for: .normal)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints             = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive  = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    let explanationLabel: UILabel = {
        let lable                 = UILabel()
        lable.text                = "Explain whats showed"
        lable.font                = UIFont(name: "AmericanTypewriter", size: 22)
        lable.textAlignment       = .center
        lable.baselineAdjustment  = .alignCenters
        lable.numberOfLines          = 0
        lable.translatesAutoresizingMaskIntoConstraints             = false
        lable.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return lable
    }()
    var stage                     = 0
    var darkMode                  = true
    var metricUnits               = true
    
    //MARK: - Touch controll
    
    @objc func skip(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextClick(_ sender: UIBarButtonItem){
        print("Go to next view")
        stage += 1
        
        switch stage {
            case 1:
                explanationLabel.text = "This is your consumed amount and your goal for the day."
                dayLable.textColor = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    summaryLable.textColor = .white
                } else {
                    summaryLable.textColor = .black
            }
            case 2:
                summaryLable.textColor = hexStringToUIColor(hex: "#666666")
                let imageArray = [UIImage(named: "Glass"), UIImage(named: "Bottle"), UIImage(named: "Flask")]
                var position = 0
                while position < drinkOptionStack.subviews.count {
                    let drink = drinkOptionStack.subviews[position] as! UIImageView
                    drink.image = imageArray[position]
                    position += 1
                }
                if darkMode {
                    smallDrinkLable.textColor  = .white
                    mediumDrinkLable.textColor = .white
                    largeDrinkLable.textColor  = .white
                } else {
                    smallDrinkLable.textColor  = .black
                    mediumDrinkLable.textColor = .black
                    largeDrinkLable.textColor  = .black
                }
                explanationLabel.text = "This is the different drink options you can use. Tap on a drink to add it to your total amount."
            case 3:
                for drink in drinkOptionStack.subviews {
                    let drinkOption   = drink as! UIImageView
                    drinkOption.image = drinkOption.image?.grayed
                }
                smallDrinkLable.textColor    = hexStringToUIColor(hex: "#666666")
                mediumDrinkLable.textColor   = hexStringToUIColor(hex: "#666666")
                largeDrinkLable.textColor    = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    settingsButton.tintColor = .lightGray
                } else {
                    settingsButton.tintColor = .black
                }
                explanationLabel.text    = "Tap on this to go to settings."
            case 4:
                settingsButton.tintColor = hexStringToUIColor(hex: "#666666")
                if darkMode {
                    calendarButton.tintColor = .lightGray
                } else {
                    calendarButton.tintColor = .black
                }
                explanationLabel.text = "Tap on this to see your history."
                nextButton.setTitle("Done", for: .normal)
            case 5:
                self.dismiss(animated: true, completion: nil)
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        changeAppearance()
        
        self.view.addSubview(toolBar)
        self.view.addSubview(dayLable)
        self.view.addSubview(summaryLable)
        self.view.addSubview(drinkOptionStack)
        self.view.addSubview(smallDrinkLable)
        self.view.addSubview(mediumDrinkLable)
        self.view.addSubview(largeDrinkLable)
        self.view.addSubview(settingsButton)
        self.view.addSubview(calendarButton)
        self.view.addSubview(explanationLabel)
        toolBar.addSubview(skipButton)
        toolBar.addSubview(nextButton)
        
        setToolBarConstraints()
        setSummaryAndDayLableConstraints()
        setDrinkOptionsConstraints()
        setSettingsAndCalendarConstraints()
        explanationLabel.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor, constant: 40).isActive = true
        explanationLabel.bottomAnchor.constraint(lessThanOrEqualTo: settingsButton.topAnchor, constant: -40).isActive  = true
        explanationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        skipButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.skip(_:))))
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextClick(_:))))
        
        nextButton.setTitle("Next", for: .normal)
        summaryLable.textColor = hexStringToUIColor(hex: "#666666")
        for drink in drinkOptionStack.subviews {
            let drinkOption    = drink as! UIImageView
            drinkOption.image  = drinkOption.image?.grayed
        }
        smallDrinkLable.textColor  = hexStringToUIColor(hex: "#666666")
        mediumDrinkLable.textColor = hexStringToUIColor(hex: "#666666")
        largeDrinkLable.textColor  = hexStringToUIColor(hex: "#666666")
        settingsButton.tintColor   = hexStringToUIColor(hex: "#666666")
        calendarButton.tintColor   = hexStringToUIColor(hex: "#666666")
        explanationLabel.text      = "This is the current day."
        
        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Change appearance
    
    /**
     Will change the appearance of this **UIViewController**
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        if darkMode{
            self.view.backgroundColor = hexStringToUIColor(hex: "#212121")
            // Mark: Lables
            dayLable.textColor         = .white
            summaryLable.textColor     = .white
            smallDrinkLable.textColor  = .white
            mediumDrinkLable.textColor = .white
            largeDrinkLable.textColor  = .white
            explanationLabel.textColor = .white
            // Mark: Buttons
            settingsButton.tintColor   = .lightGray
            calendarButton.tintColor   = .lightGray
            // Mark: Toolbar
            toolBar.backgroundColor    = .darkGray
            nextButton.setTitleColor(.white, for: .normal)
            skipButton.setTitleColor(.white, for: .normal)
        } else {
            self.view.backgroundColor = .white
            // Mark: Lables
            dayLable.textColor         = .black
            summaryLable.textColor     = .black
            smallDrinkLable.textColor  = .black
            mediumDrinkLable.textColor = .black
            largeDrinkLable.textColor  = .black
            explanationLabel.textColor = .black
            // Mark: Buttons
            settingsButton.tintColor   = .black
            calendarButton.tintColor   = .black
            // Mark: Toolbar
            toolBar.backgroundColor    = hexStringToUIColor(hex: "#d1d1d1")
            nextButton.setTitleColor(.black, for: .normal)
            skipButton.setTitleColor(.black, for: .normal)
        }
    }
    
    /**
     Will convert an string of a hex color code to **UIColor**
     
     - parameter hex: - A **String** whit the hex color code.
     
     # Notes: #
     1. This will need an **String** in a hex coded style.
     
     # Example #
     ```
     let color: UIColor = hexStringToUIColor ("#212121")
     ```
     */
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK: - Set constraints
    
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
        skipButton.leftAnchor.constraint(equalTo: toolBar.leftAnchor, constant: 20).isActive    = true
        skipButton.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive            = true
        nextButton.rightAnchor.constraint(equalTo: toolBar.rightAnchor, constant: -20).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive            = true
    }
    
    /**
     sets the constraints for the lables displaying the day and summary.
     
     # Notes: #
     This should only be called after you have added the dayLable and the summaryLable to the view.
     
     # Example #
     ```
     toturialVC.view.addSubview(dayLable)
     toturialVC.view.addSubview(summaryLable)
     setSummaryAndDayLableConstraints()
     ```
     */
    fileprivate func setSummaryAndDayLableConstraints() {
        dayLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive             = true
        dayLable.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 40).isActive      = true
        summaryLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive         = true
        summaryLable.topAnchor.constraint(equalTo: dayLable.bottomAnchor, constant: 10).isActive = true
    }
    
    /**
     Sets the constraints for the drinkOptionsStack and the lables for the drink options.
     
     # Notes: #
     This should only be called after you haved added the stack with the drink options and all its lables.
     
     # Example #
     ```
     toturialVC.view.addSubview(drinkOptionStack)
     toturialVC.view.addSubview(smallDrinkLable)
     toturialVC.view.addSubview(mediumDrinkLable)
     toturialVC.view.addSubview(largeDrinkLable)
     setDrinkOptionsConstraints()
     ```
     */
    fileprivate func setDrinkOptionsConstraints() {
        drinkOptionStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive      = true
        drinkOptionStack.topAnchor.constraint(equalTo: summaryLable.bottomAnchor, constant: 20).isActive        = true
        smallDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[0].centerXAnchor).isActive  = true
        mediumDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[1].centerXAnchor).isActive = true
        largeDrinkLable.centerXAnchor.constraint(equalTo: drinkOptionStack.subviews[2].centerXAnchor).isActive  = true
        smallDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive                   = true
        mediumDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive                  = true
        largeDrinkLable.topAnchor.constraint(equalTo: drinkOptionStack.bottomAnchor).isActive                   = true
    }
    
    /**
     Sets the constaints for the settings and calendar buttons.
     
     # Notes: #
     This should only be called when the buttons has been added to the view.
     
     # Example #
     ```
     toturialVC.view.addSubview(settingsButton)
     toturialVC.view.addSubview(calendarButton)
     setSettingsAndCalendarConstraints()
     ```
     */
    fileprivate func setSettingsAndCalendarConstraints() {
        settingsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive      = true
        settingsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        calendarButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive   = true
        calendarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    }
}
