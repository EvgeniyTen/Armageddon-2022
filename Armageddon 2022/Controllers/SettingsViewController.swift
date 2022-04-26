//
//  SettingsViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit
let cv = AsteroidViewController()
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
 
    @IBAction func setSettings(_ sender: UIButton) {
        dismiss(animated: true)

    }
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
