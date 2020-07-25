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
        button.setTitle(NSLocalizedString("Skip", comment: "Skip button in toolbar"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let nextButton: UIButton  = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "AmericanTypewriter", size: 20)
        button.setTitle(NSLocalizedString("Next", comment: "Next button in toolbar"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let dayLable: UILabel     = {
        let lable           = UILabel()
        let formatter       = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        lable.textAlignment = .center
        lable.text          = formatter.string(from: Date()).capitalized
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
        smallDrink.image        = UIImage(named: "Cup")
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
    var explanationText: [String] = [NSLocalizedString("ExplenationDay", comment: "Explenation of day"),
                                     NSLocalizedString("ExplenationSummary", comment: "Explenation of summary"),
                                     NSLocalizedString("ExplenationDrinks", comment: "Explenation of drink options"),
                                     NSLocalizedString("ExplenationSettings", comment: "Explenation of settings button"),
                                     NSLocalizedString("ExplenationCalendar", comment: "Explenation of calendar button")]
    var darkMode                  = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .darkContent
    }
    var metricUnits               = true
    
    //MARK: - Touch controll
    
    /**
     Will close the toturial view
     */
    @objc func skip(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Will go through the different stages in the toturial.
     */
    @objc func nextClick(_ sender: UIBarButtonItem){
        stage += 1
        print("Go to stage \(stage) in tutorial")
        changeAppearance()
        switch stage {
        case 1:
            explanationLabel.text = explanationText[stage]
            if darkMode {
                summaryLable.textColor = .white
            } else {
                summaryLable.textColor = .darkGray
            }
        case 2:
            let imageArray = [UIImage(named: "Cup"), UIImage(named: "Bottle"), UIImage(named: "Flask")]
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
                smallDrinkLable.textColor  = .darkGray
                mediumDrinkLable.textColor = .darkGray
                largeDrinkLable.textColor  = .darkGray
            }
            explanationLabel.text = explanationText[stage]
        case 3:
            for drink in drinkOptionStack.subviews {
                let drinkOption   = drink as! UIImageView
                drinkOption.image = drinkOption.image?.grayed
            }
            if darkMode {
                settingsButton.tintColor = .lightGray
            } else {
                settingsButton.tintColor = .darkGray
            }
            explanationLabel.text = explanationText[stage]
        case 4:
            if darkMode {
                calendarButton.tintColor = .lightGray
            } else {
                calendarButton.tintColor = .darkGray
            }
            explanationLabel.text = explanationText[stage]
            nextButton.setTitle(NSLocalizedString("Done", comment: "Done button in toolbar"), for: .normal)
        case 5:
            stage = 0
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkMode = UserDefaults.standard.bool(forKey: darkModeString)
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
        
        nextButton.setTitle(NSLocalizedString("Next", comment: "Next button in toolbar"), for: .normal)
        for drink in drinkOptionStack.subviews {
            let drinkOption    = drink as! UIImageView
            drinkOption.image  = drinkOption.image?.grayed
        }
        changeAppearance()
        if darkMode {
            dayLable.textColor = .white
        } else {
            dayLable.textColor = .darkGray
        }
        explanationLabel.text      = explanationText[stage]
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
    
    //MARK: - Change appearance
    
    /**
     Will change the appearance of this **UIViewController**
     
     # Example #
     ```
     changeAppearance()
     ```
     */
    func changeAppearance(){
        if darkMode {
            self.view.backgroundColor  = UIColor().hexStringToUIColor("#212121")
            dayLable.textColor         = UIColor().hexStringToUIColor("#404040")
            summaryLable.textColor     = UIColor().hexStringToUIColor("#404040")
            smallDrinkLable.textColor  = UIColor().hexStringToUIColor("#404040")
            mediumDrinkLable.textColor = UIColor().hexStringToUIColor("#404040")
            largeDrinkLable.textColor  = UIColor().hexStringToUIColor("#404040")
            settingsButton.tintColor   = UIColor().hexStringToUIColor("#404040")
            calendarButton.tintColor   = UIColor().hexStringToUIColor("#404040")
            nextButton.setTitleColor(.white, for: .normal)
            skipButton.setTitleColor(.white, for: .normal)
            explanationLabel.textColor = .white
        } else {
            self.view.backgroundColor  = .white
            dayLable.textColor         = UIColor().hexStringToUIColor("#c9c9c9")
            summaryLable.textColor     = UIColor().hexStringToUIColor("#c9c9c9")
            smallDrinkLable.textColor  = UIColor().hexStringToUIColor("#c9c9c9")
            mediumDrinkLable.textColor = UIColor().hexStringToUIColor("#c9c9c9")
            largeDrinkLable.textColor  = UIColor().hexStringToUIColor("#c9c9c9")
            settingsButton.tintColor   = UIColor().hexStringToUIColor("#c9c9c9")
            calendarButton.tintColor   = UIColor().hexStringToUIColor("#c9c9c9")
            toolBar.backgroundColor    = UIColor().hexStringToUIColor("#d1d1d1")
            nextButton.setTitleColor(.darkGray, for: .normal)
            skipButton.setTitleColor(.darkGray, for: .normal)
            explanationLabel.textColor = .darkGray
        }
    }
}
