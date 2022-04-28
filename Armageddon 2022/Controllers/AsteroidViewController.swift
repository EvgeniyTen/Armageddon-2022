//
//  AsteroidViewController.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

private let reuseIdentifier = "myCell"



class AsteroidViewController: UICollectionViewController {
    
    private let networkManager = NetworkManager()
    
    private var dataResponse: Asteroid? = nil
    private var asteroidsArray: [NearEarthObject] = []
    private var filteredArray: [NearEarthObject]?
    
    private var missDistance: [MissDistance] = []
    private var closeApproach: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: String(describing: "AsteroidInfoCell"), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        
    }
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredArray = asteroidsArray
        guard var data = filteredArray else {return 0}
        if UserDefaults.standard.bool(forKey: "hazard") {
            data = asteroidsArray.filter{$0.isPotentiallyHazardousAsteroid}
        }
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AsteroidInfoCell
        guard var data = filteredArray else {return cell}
        if UserDefaults.standard.bool(forKey: "hazard") {
            data = asteroidsArray.filter{$0.isPotentiallyHazardousAsteroid}
        }
        
        
        
        
        // MARK: Asteroid name
        let name = data[indexPath.row].name
        cell.asteroidNameLabel.text = name.slice(from: "(", to: ")")
        
        // MARK: Asteroids hazard indicators
        let diameter = data[indexPath.row].estimatedDiameter.meters.estimatedDiameterMax
        let hazard = data[indexPath.row].isPotentiallyHazardousAsteroid
        cell.asteriodDiameterLabel.text = "Диаметр: \(Int(diameter)) м"
        cell.hazardColorLabel.image = hazard ? UIImage(named: "red") : UIImage(named: "green")
        cell.isHazardLabel.textColor = hazard ? .systemRed : .systemGreen
        cell.isHazardLabel.text = hazard ? "опасен" : "не опасен"
        
        
        // MARK: Asteroids image size
        if data[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.7 {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidHuge")
        } else if asteroidsArray[indexPath.row].estimatedDiameter.kilometers.estimatedDiameterMax > 0.3 {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidBig")
        } else {
            cell.asteroidSizeLabel.image = UIImage(named: "asteroidSmall")
        }
        
        
        
        
        // MARK: Asteroid close approach date
        
        let date = closeApproach[indexPath.row]
        let convertedDate = date.toDateTime()
        let dateFormated = formateDate(date: convertedDate)
        cell.asteriodCloseApproach.text = "Подлет: \(dateFormated)"
        
        
        
        
        // MARK: Asteroid miss distance
        
        let distanceObj = missDistance[indexPath.item]
        let distanceByKM = distanceObj.kilometers
        let distanceByLunar = distanceObj.lunar
        
        guard let distanceKMDouble = Double(distanceByKM) else {return cell }
        guard let distanceLNDouble = Double(distanceByLunar) else {return cell }
        
        let distanceKMInt = Int(distanceKMDouble)
        let distanceLunInt = Int(distanceLNDouble)
        
        let distanceKMString = distanceKMInt.formattedWithSeparator
        
        if UserDefaults.standard.integer(forKey: "unitsType") == 0 {
            cell.asteroisMissDistanceLabel.text = "на расстояние \(distanceKMString) км"
        } else {
            cell.asteroisMissDistanceLabel.text = "на расстояние \(distanceLunInt) лунных орбит"
        }
        
        
        cell.deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchDown)
        //        cell.backgroundColor = .clear
        
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        cell.backgroundLayer.layer.cornerRadius = 25
        cell.backgroundLayer.clipsToBounds = true
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    
    // MARK: Deleting cell method
    @objc func deleteButton(_ sender: UIButton!) {
        if let cell = sender.superview?.superview?.superview?.superview as? AsteroidInfoCell, let indexPath = collectionView.indexPath(for: cell) {
            let removedValue = asteroidsArray.remove(at: indexPath.row)
            DestroyViewController.array.append(removedValue)
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadData()
            
        }
    }
    // MARK: Date formatter method
    
    private  func formateDate(date: NSDate) -> String {
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
    private    func fetchData() {
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

