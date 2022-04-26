////
////  FetchData.swift
////  Armageddon 2022
////
////  Created by Евгений Тимофеев on 25.04.2022.
////
//
//import Foundation
//
//let networkManager = NetworkManager()
//var dataResponse: Asteroid? = nil
//var asteroidsArray: [NearEarthObject] = []
//var missDistance: [MissDistance] = []
//var closeApproach: [String] = []
//
//func fetchData() {
//    networkManager.asteriodRequest(urlString: stringUrl) { (result) in
//        switch result {
//        case .success(let response):
//            dataResponse = response
//            guard let nearEarthObject = dataResponse?.nearEarthObjects else {return}
//            
//                        //Получаем массив астероидов
//            
//            for (_, values) in nearEarthObject {
//               asteroidsArray = values
//                
//                        //Получаем объект "Возле земли" и доступ к свойствам
//                
//                for nearObject in asteroidsArray {
//                    let dates = nearObject.closeApproachData
//                    for closeApproachDatum in dates {
//                        
//                        //Загоняем даты в массив
//                        
//                        let date = closeApproachDatum.closeApproachDate
//                        closeApproach.append(date)
//                        //Загоняем дистанцию в массив
//                        
//                        let distance = closeApproachDatum.missDistance
//                        missDistance.append(distance)
//                    }
//                }
//            }
//        case .failure(let error):
//            print("Decode error: \(error.localizedDescription)")
//        }
//    }
//}
