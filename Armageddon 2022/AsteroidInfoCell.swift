//
//  AsteroidInfoCell.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit

class AsteroidInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var backgroundLayer: UIView!
    @IBOutlet weak var hazardColorLabel: UIImageView!
    
    @IBOutlet weak var asteroidSizeLabel: UIImageView!
    @IBOutlet weak var asteroidNameLabel: UILabel!
    
    @IBOutlet weak var asteriodDiameterLabel: UILabel!
    @IBOutlet weak var asteriodCloseApproach: UILabel!
    @IBOutlet weak var asteroisMissDistanceLabel: UILabel!
    
    @IBOutlet weak var isHazardLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }


    // MARK: Set gradient method
        func setGradientColor(_ bool: Bool,_ view: UIView) {
                let leftColorGreen = UIColor(red: 207.0/255.0, green: 243.0/255.0, blue: 125.0/255.0, alpha: 1.0).cgColor
                let rightColorGreen = UIColor(red: 125.0/255.0, green: 232.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
                
                let leftColorRed = UIColor(red: 255.0/255.0, green: 177.0/255.0, blue: 153.0/255.0, alpha: 1.0).cgColor
                let rightColorRed = UIColor(red: 255.0/255.0, green: 8.0/255.0, blue: 68.0/255.0, alpha: 1.0).cgColor
                
                let gradient = CAGradientLayer()
                
                gradient.startPoint = CGPoint(x: 0, y: 1)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                if bool {
                    gradient.colors = [leftColorRed, rightColorRed]
                    gradient.frame = view.bounds
                    view.layer.insertSublayer(gradient, at: 0)
                } else {
                    gradient.colors = [leftColorGreen, rightColorGreen]
                    gradient.frame = view.bounds
                    view.layer.insertSublayer(gradient, at: 0)

                }
            }
            
}
    

