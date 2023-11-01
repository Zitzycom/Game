//
//  Barrier.swift
//  Rublex
//
//  Created by Macbook on 29.09.2023.
//

import UIKit

class CarFactory {
    
    static func createCar(backgroundImage: String ,coordinate: [CGFloat]) -> UIImageView {
        let car = UIImageView()
        car.image = UIImage(named: backgroundImage)
        car.frame = CGRect(x: coordinate[0], y: coordinate[1], width: Constants.widthCar, height: Constants.heightCar)
        return car
        
    }
    
    
}
