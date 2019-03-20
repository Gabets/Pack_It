//
//  TimerPopupVC.swift
//  BackPacker
//
//  Created by Alex Gabets on 17.02.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import UIKit

class TimerPopupVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var timerCallback : ((Date?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale.current
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        timerCallback!(nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickOK(_ sender: UIButton) {
        timerCallback!(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
   
}
