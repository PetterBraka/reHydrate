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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        
        historyButton.layer.cornerRadius = 20
        historyButton.layer.borderWidth = 3
        historyButton.layer.borderColor = UIColor.darkGray.cgColor
        historyButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderWidth = 3
        settingsButton.layer.borderColor = UIColor.darkGray.cgColor
        settingsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        currentDay.text = formatter.string(from: Date.init())
//        Thread.sleep(forTimeInterval: 0.5)
    }


}

