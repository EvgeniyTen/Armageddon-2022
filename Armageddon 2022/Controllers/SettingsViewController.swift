//
//  SettingsViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit
let cv = AsteroidViewController()
class SettingsViewController: UIViewController {

    
    // MARK: Segment control
    @IBOutlet weak var segmentControlLabel: UISegmentedControl! {
    didSet {
        segmentControlLabel.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "unitsType")
        }
    }
    // MARK: Segment control

    @IBOutlet weak var switchControlLabel: UISwitch! {
        didSet {
            switchControlLabel.isOn = UserDefaults.standard.bool(forKey: "hazard")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "unitsType")
    }
    
    @IBAction func switchControlAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "hazard")
    }
 
    @IBAction func setSettings(_ sender: UIBarButtonItem!) {
        navigationController?.popViewController(animated: true)
        }
    

}
