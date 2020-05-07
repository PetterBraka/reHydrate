//
//  SettingOptionCell.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 24/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class SettingOptionCell: UITableViewCell {
    var numberArray       = ["0", "1","2","3","4","5","6","7","8","9"]
    var componentString   = ["","",",",""]
    let picker            = UIPickerView()
    var notificationStart = Int()
    var notificationEnd   = Int()
    var setting: String? {
        didSet {
            guard let string 	= setting else {return}
            titleOption.text 	= string
        }
    }
    var textField: UITextField 			= {
        let textField 					= UITextField()
        textField.placeholder 			= "value"
        textField.layer.borderWidth 	= 2
        textField.layer.cornerRadius 	= 5
        textField.layer.borderColor 	= UIColor.lightGray.cgColor
        textField.font 					= UIFont(name: "AmericanTypewriter", size: 17)
        textField.textAlignment 		= .center
        textField.setLeftPadding(20)
        textField.setRightPadding(20)
        return textField
    }()
    let titleOption: UILabel 	= {
        let lable 				= UILabel()
        lable.text 				= "test"
        lable.font 				= UIFont(name: "AmericanTypewriter", size: 17)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        }()
    let subTitle: UILabel 		= {
        let lable 				= UILabel()
        lable.text 				= "subText"
        lable.font 				= UIFont(name: "AmericanTypewriter", size: 13)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    let activatedOption: UIButton 	= {
        let button					= UIButton()
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleOption)
        self.addSubview(activatedOption)
        setButtonConstraints()
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive	= true
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive			= true
        self.backgroundColor																= .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubTitle(_ string: String){
        subTitle.text = string
        self.addSubview(subTitle)
        self.removeConstraints(self.constraints)
        titleOption.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive	= true
        titleOption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive    		= true
        subTitle.leftAnchor.constraint(equalTo: titleOption.leftAnchor, constant: 10).isActive 		= true
        subTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive		= true
        setButtonConstraints()
    }
    
    /**
     Setting the constraints for the activate button.
     
     # Example #
     ```
     setActivatedButtonConstraints()
     ```
     */
    func setButtonConstraints() {
        activatedOption.widthAnchor.constraint(equalToConstant: 25).isActive                    	= true
        activatedOption.heightAnchor.constraint(equalToConstant: 25).isActive                   	= true
        activatedOption.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive 		= true
        activatedOption.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive 	= true
    }
    
    /**
     Changes the apparentce of the **SettingOptionCell** deppending on the users preferents.
     
     # Example #
     ```
     settCellAppairents(darkMode)
     ```
     */
    func setCellAppairents(_ dark: Bool,_ metric: Bool){
        if dark{
            activatedOption.tintColor       = .lightGray
            titleOption.textColor           = .white
            subTitle.textColor              = .white
            textField.textColor             = .white
            self.backgroundColor            = hexStringToUIColor(hex: "#212121")
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        } else {
            activatedOption.tintColor       = .black
            titleOption.textColor           = .black
            subTitle.textColor              = .black
            textField.textColor             = .black
            self.backgroundColor            = .white
            textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        }
        switch titleOption.text?.lowercased() {
            case "dark mode":
                if dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "light mode":
                if !dark{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "metric system":
                if metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "imperial system":
                if !metric{
                    activatedOption.isHidden = false
                } else {
                    activatedOption.isHidden = true
                }
            case "goal":
                activatedOption.isHidden    = true
                titleOption.text            = "Set your goal"
                setUpPickerView()
            
            default:
                activatedOption.isHidden 	= true
        }
        UserDefaults.standard.set(dark, forKey: "darkMode")
        UserDefaults.standard.set(metric, forKey: "metricUnits")
    }
    
    fileprivate func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = .current
        datePicker.addTarget(self, action: #selector(handleInput), for: .valueChanged)
        
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints                                 = false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive                     = true
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive         = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        textField.centerYAnchor.constraint(equalTo: titleOption.centerYAnchor).isActive     = true
        textField.inputView = datePicker
        
        let toolBar       = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    @objc func handleInput(_ sender: UIDatePicker ){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        textField.text = formatter.string(from: sender.date)
    }
    
    func setUpPickerView() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints 									= false
        textField.heightAnchor.constraint(equalToConstant: 35).isActive 						= true
        textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive 			= true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive 	= true
        textField.centerYAnchor.constraint(equalTo: titleOption.centerYAnchor).isActive 		= true
        
        let toolBar 		= UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.contentView.frame.width, height: 40)))
        let flexibleSpace 	= UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton 		= UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        
        picker.frame 		= CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 280)
        picker.delegate		= self
        picker.dataSource 	= self
        textField.inputView = picker
    }
    
    @objc func doneClicked(){
        textField.endEditing(true)
        if titleOption.text?.lowercased() == "set your goal" {
            var component = 0
            while component < picker.numberOfComponents {
                let value = numberArray[picker.selectedRow(inComponent: component)]
                switch component {
                    case 0, 1, 3:
                        updateTextField(String(value), component)
                    case 2:
                        updateTextField(".", component)
                    default:
                        break
                }
                component += 1
            }
            updateGoal()
        }
    }
    
    func updateGoal(){
        let days = Day.loadDay()
        let newGoal = Float(textField.text!)!
        if newGoal != 0 {
            days[days.count - 1].goalAmount.amountOfDrink = newGoal
            print(days[days.count - 1].goalAmount.amountOfDrink)
            Day.saveDay(days)
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
}

extension SettingOptionCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0, 1, 3:
                return numberArray.count
            case 2:
                return 1
            default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0, 1, 3:
                return numberArray[row]
            case 2:
                return "."
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0, 1, 3:
            updateTextField(numberArray[row], component)
            case 2:
            updateTextField(".", component)
            default:
            break
        }
    }
    
    func updateTextField(_ input: String, _ component: Int){
        textField.text = ""
        componentString[component] = input
        if componentString[0] == "0" {
            componentString[0] = ""
        }
        for number in componentString {
            textField.text = textField.text! + number
        }
            
    }
}

extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
