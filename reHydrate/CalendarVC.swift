//
//  CalenderScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 06/04/2020.
//  Copyright © 2020 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {
    
    var drinks: [Drink] = []
    var days: [Day] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        days = Day.loadDay()
        getDay(Date.init())
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getDay(_ dateOfDay: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - dd/MM/yy"
        let day: Day = days.first(where: {formatter.string(from: $0.date) == formatter.string(from: dateOfDay)})!
        drinks.append(day.goalAmount)
        drinks.append(day.consumedAmount)
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! InfoCell
        cell.setLabels(drinks[indexPath.row], indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
