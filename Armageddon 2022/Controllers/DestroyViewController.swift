//
//  DestroyViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

class DestroyViewController: UITableViewController {

    var array: [NearEarthObject] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArray()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deletedAsteroids", for: indexPath) as! DeletedAsteriodsCell
        cell.deletedAsteroidName.text = array[indexPath.row].name
        cell.backgroundColor = .systemIndigo
        return cell
    }
    
    func fetchArray() {
        let vc = AsteroidViewController(nibName: "AsteroidViewController", bundle: nil)
        vc.deletedElements = array
        tableView.reloadData()
    }
}
