//
//  ViewController.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import FSCalendar

class StartView: UIViewController {

    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var optionsStack: UIStackView!
    @IBOutlet weak var smallStack: UIStackView!
    @IBOutlet weak var mediumStack: UIStackView!
    @IBOutlet weak var largeStack: UIStackView!
    @IBOutlet weak var sumaryAndGoal: UIStackView!
    @IBOutlet weak var smallOption: UIButton!
    @IBOutlet weak var mediumOption: UIButton!
    @IBOutlet weak var largeOption: UIButton!
    
    @IBAction func settings(_ sender: Any) {
        let alert = UIAlertController(title: "error", message: "This option is not implemented yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func history(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarScreen = storyboard.instantiateViewController(withIdentifier: "calendar")
        calendarScreen.modalPresentationStyle = .fullScreen
        self.present(calendarScreen, animated: true, completion: nil)
    }
    
    @objc func tap(_ sender: UIGestureRecognizer){
        switch sender.view {
        case smallOption:
            print("small short-press")
        case mediumOption:
            print("medium short-press")
        case largeOption:
            print("large short-press")
        default:
            break
        }
    }
    @objc func long(_ sender: UIGestureRecognizer){
        switch sender.view {
        case smallOption:
            print("small short-press")
        case mediumOption:
            print("medium short-press")
        case largeOption:
            print("large short-press")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        currentDay.text = formatter.string(from: Date.init())
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    func setUpButtons(){
        //setting up an gesture recognizer for each button.
        let smallOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let smallOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        smallOptionLongGesture.minimumPressDuration = 0.5

        let mediumOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let mediumOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        mediumOptionLongGesture.minimumPressDuration = 0.5

        let largeOptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let largeOptionLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        largeOptionLongGesture.minimumPressDuration = 0.5
        
        //adding the gesture recognizer for each option.
        smallOption.addGestureRecognizer(smallOptionTapGesture)
        mediumOption.addGestureRecognizer(mediumOptionTapGesture)
        largeOption.addGestureRecognizer(largeOptionTapGesture)

        smallOption.addGestureRecognizer(smallOptionLongGesture)
        mediumOption.addGestureRecognizer(mediumOptionLongGesture)
        largeOption.addGestureRecognizer(largeOptionLongGesture)
        
        //giving the buttons the aperients
        historyButton.layer.cornerRadius = 20
        historyButton.layer.borderWidth = 3
        historyButton.layer.borderColor = UIColor.darkGray.cgColor
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 3
        settingsButton.layer.borderColor = UIColor.darkGray.cgColor
        settingsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

