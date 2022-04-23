//
//  AsteroidViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

private let reuseIdentifier = "myCell"

class AsteroidViewController: UICollectionViewController {
    var dataResponse: Asteroid? = nil
    let networkManager = NetworkManager()
    var asteroidsArray: [NearEarthObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
       
        
        collectionView.register(UINib(nibName: String(describing: "AsteroidInfoCell"), bundle: nil), forCellWithReuseIdentifier: "myCell")
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        guard let asteroidsArray = asteroidsArray else { return 0 }
        return asteroidsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AsteroidInfoCell
        
        
        cell.isHazardLabel.text = asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid ? "Оценка: опасен" : "Оценка: не опасен"
        cell.asteroidNameLabel.text = asteroidsArray[indexPath.row].name
        
        DispatchQueue.main.async { [self] in
            if asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid == true {
                cell.hazardColorLabel.backgroundColor = .systemRed
            } else {
                cell.hazardColorLabel.backgroundColor = .systemGreen
                
            }
            if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.7 {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidHuge")
            } else if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.3 {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidBig")
                
            } else {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidSmall")
                
            }
        }
        
        cell.layer.cornerRadius = 30
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
    }
    
    func fetchData() {
        networkManager.request(urlString: stringUrl) { [weak self] (result) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let response):
                    self?.dataResponse = response
                    guard let someValue = self?.dataResponse?.nearEarthObjects else {return}
                    for (_, values) in someValue {
                        self?.asteroidsArray = values
                    }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Decode error: \(error.localizedDescription)")
                }
            }
        }
    }
   
}



