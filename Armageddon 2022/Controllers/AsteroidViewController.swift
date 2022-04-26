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
    var deletedElements: [NearEarthObject] = []
    var missDistance: [MissDistance] = []
    var closeApproach: [String] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: String(describing: "AsteroidInfoCell"), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
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
        let hazard = asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid
        
        // MARK: Gradients
        cell.setGradientColor(hazard, cell.hazardColorLabel)
        cell.isHazardLabel.textColor = hazard ? .systemRed : .systemGreen
        cell.isHazardLabel.text = hazard ? "опасен" : "не опасен"
        
        
        // MARK: Asteroids image size
        if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.7 {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidHuge")
        } else if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.3 {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidBig")
        } else {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidSmall")
        }
        
        
        
        // MARK: Asteroid close approach date
        
        let date = closeApproach[indexPath.row]
        print("info 1: \(asteroidsArray[indexPath.row].isPotentiallyHazardousAsteroid)")
        let convertedDate = date.toDateTime()
        let dateFormated = formateDate(date: convertedDate)
        cell.asteriodCloseApproach.text = "Подлет: \(dateFormated)"
        
        
        
        
        // MARK: Asteroid miss distance
        
        let distanceObj = missDistance[indexPath.item]
        let distanceByKM = distanceObj.kilometers
        //let distanceByLunar = distanceObj.lunar
        
        guard let distanceDouble = Double(distanceByKM) else {return cell }
        let distanceInt = Int(distanceDouble)
        let distance = distanceInt.formattedWithSeparator
        cell.asteroisMissDistanceLabel.text = "на расстояние \(distance) км"
        
        
        
        
        cell.deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchDown)
        cell.layer.cornerRadius = 30
        cell.backgroundColor = UIColor(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1.0)
        cell.clipsToBounds = true
        // требуется создание нижнего слоя для ячейки, что бы создать тень
        //        cell.layer.shadowRadius = 4.0
        //        cell.layer.shadowOpacity = 0.5
        //        cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
 
    
    // MARK: Deleting cell method
    @objc func deleteButton(_ sender: UIButton!) {
        if let cell = sender.superview?.superview?.superview as? AsteroidInfoCell, let indexPath = collectionView.indexPath(for: cell) {
            let removedValue = asteroidsArray.remove(at: indexPath.row)
            deletedElements.append(removedValue)
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadData()
        }
    }
    // MARK: Date formatter method
    
    func formateDate(date: NSDate) -> String {
        let a = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let c = dateFormatter.string(from: a as Date)
        return c
    }
    
    
    
    // MARK: Settings methods
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    
    // MARK: Fetching method
    func fetchData() {
        networkManager.asteriodRequest(urlString: stringUrl) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.dataResponse = response
                guard let nearEarthObject = self?.dataResponse?.nearEarthObjects else {return}
                
                //Получаем массив астероидов
                
                for (_, values) in nearEarthObject {
                    self?.asteroidsArray = values
                    
                    //Получаем объект "Возле земли" и доступ к свойствам
                    
                    for nearObject in self!.asteroidsArray {
                        let dates = nearObject.closeApproachData
                        for closeApproachDatum in dates {
                            
                            //Загоняем даты в массив
                            
                            let date = closeApproachDatum.closeApproachDate
                            self?.closeApproach.append(date)
                            //Загоняем дистанцию в массив
                            
                            let distance = closeApproachDatum.missDistance
                            self?.missDistance.append(distance)
                        }
                    }
                }
            case .failure(let error):
                print("Decode error: \(error.localizedDescription)")
            }
            self?.collectionView.reloadData()
        }
    }
}


// MARK: Extensions



extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension String {
    
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: self)! as NSDate
        return dateFromString
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

