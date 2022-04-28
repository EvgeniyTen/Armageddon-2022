//
//  DestroyViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

class DestroyViewController: UITableViewController {
    
    
    private let networkManager = NetworkManager()
    
    
    static var array = [NearEarthObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return DestroyViewController.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deletedAsteroids", for: indexPath) as! DeletedAsteriodsCell
        let array = DestroyViewController.array
        let hazard = array[indexPath.row].isPotentiallyHazardousAsteroid
        cell.backgroundColor = hazard ? .systemRed : .systemGreen
        cell.deletedAsteroidName.text = array[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
