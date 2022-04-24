//
//  AsteroidViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

private let reuseIdentifier = "myCell"

class AsteroidViewController: UICollectionViewController {
    
    let networkManager = NetworkManager()

    var dataResponse: Asteroid? = nil
    var asteroidsArray: [NearEarthObject] = []
    
    var arrayDel = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
       
        
        collectionView.register(UINib(nibName: String(describing: "AsteroidInfoCell"), bundle: nil), forCellWithReuseIdentifier: "myCell")
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asteroidsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AsteroidInfoCell
        
        
        // MARK: Asteroid name
        let name = asteroidsArray[indexPath.row].name
        cell.asteroidNameLabel.text = name.slice(from: "(", to: ")")
        
        // MARK: Asteroids hazard indicators
        let diameter = asteroidsArray[indexPath.row].estimatedDiameter.meters.estimatedDiameterMax
        cell.asteriodDiameterLabel.text = "Диаметр: \(Int(diameter)) м"
        cell.isHazardLabel.text = asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid ? "опасен" : "не опасен"
        cell.isHazardLabel.textColor = asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid ? .systemRed : .black
        DispatchQueue.main.async { [self] in
            if asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid == true {
                // подтянуть градиент
                cell.hazardColorLabel.backgroundColor = .systemRed
            } else {
                // подтянуть градиент
                cell.hazardColorLabel.backgroundColor = .systemGreen
            }
        // MARK: Asteroids image size
            if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.7 {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidHuge")
            } else if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.3 {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidBig")
            } else {
                cell.asteroidSizeLabel.image = UIImage(named: "asteroidSmall")
            }
        }
        cell.deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchDown)
        cell.layer.cornerRadius = 30
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    let viewController = AsteriodInfoViewController()
        self.navigationController?.showDetailViewController(viewController, sender: nil)
    }
    
    // MARK: Deleting cell method
    @objc func deleteButton(_ sender: UIButton!) {
        if let cell = sender.superview?.superview?.superview as? AsteroidInfoCell, let indexPath = collectionView.indexPath(for: cell) {
        
        asteroidsArray.remove(at: indexPath.row)
            //написать метод для сравнения массивов -текущего и с удаленным элементом
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
        }
    }
    // MARK: Settings methods
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    // MARK: Fetching method
    func fetchData() {
        networkManager.asteriodRequest(urlString: stringUrl) { [weak self] (result) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let response):
                    self?.dataResponse = response
                    guard let nearEarthObject = self?.dataResponse?.nearEarthObjects else {return}
                    for (_, values) in nearEarthObject {
                        self?.asteroidsArray.removeAll()
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
   
// MARK: Extensions
extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

