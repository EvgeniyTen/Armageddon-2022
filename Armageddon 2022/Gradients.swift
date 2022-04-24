//
//  Gradients.swift
//  Armageddon 2022
//
//  Created by Евгений Тимофеев on 23.04.2022.
//

import UIKit


class Gradients {
    
//    let colorLeftGreen = UIColor(red: 207.0 / 255.0, green: 243.0 / 255.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0).cgColor
//    let colorRigthGreen = UIColor(red: 125.0 / 255.0, green: 232.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0).cgColor
//
//    let colorLeftRed = UIColor(red: 255.0 / 255.0, green: 177.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
//    let colorRigthRed = UIColor(red: 255.0 / 255.0, green: 8.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0).cgColor

    
    let colorLeftGreen = UIColor.green.cgColor
    let colorRigthGreen = UIColor.blue.cgColor
    
    let colorLeftRed = UIColor.red.cgColor
    let colorRigthRed = UIColor.blue.cgColor
    
    let greenLayer: CAGradientLayer
    let redLayer: CAGradientLayer
    
    init() {
        greenLayer = CAGradientLayer()
        redLayer = CAGradientLayer()
        
        greenLayer.colors = [colorLeftGreen, colorRigthGreen]
        greenLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        greenLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        redLayer.colors = [colorLeftRed, colorRigthRed]
        redLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        redLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
