//
//  AsteroidInfoCell.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 20.04.2022.
//

import UIKit


class AsteroidInfoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hazardColorLabel: UIView!
    
    @IBOutlet weak var asteroidSizeLabel: UIImageView!
    @IBOutlet weak var asteroidNameLabel: UILabel!
    
    @IBOutlet weak var asteriodDiameterLabel: UILabel!
    @IBOutlet weak var asteriodCloseApproach: UILabel!
    @IBOutlet weak var asteroisMissDistanceLabel: UILabel!
    
    @IBOutlet weak var isHazardLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    
}
    

