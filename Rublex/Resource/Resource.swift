//
//  Model.swift
//  Rublex
//
//  Created by Macbook on 04.10.2023.
//

import Foundation


enum ImageName {
    static var barrier: String {"Barrier"}
    static var bushes: String {"Bushes"}
    static var button: String {"Button"}
    static var field: String {"Field"}
    static var forest: String {"Forest"}
    static var road: String {"Road"}
    static var error: String {"Error"}
    static var buttonLeft: String {"ButtonLeft"}
    static var buttonRight: String {"ButtonRight"}
    static var myCar: String {"MyCar"}
    static var buttonForMenu: String {"ButtonMenu"}
    static var defaultAvatar : String? {"DefaultAvatar"}
}

enum GameSpeed: Codable {
    case low
    case medium
    case higth
    var value: Double {
        switch self {
        case .low: return 2.0
        case .medium: return 1.0
        case .higth: return 0.01
        }
    }
}

enum MyCarColor: Codable {
    case red
    case black
    var value: String {
        switch self {
        case .black: return "black"
        case .red: return "red"
        }
    }
}

enum FoneType: Codable {
    case bushes
    case forest
    case field
    var value: String {
        switch self {
        case .bushes: return "Bushes"
        case .field: return "Field"
        case .forest: return "Forest"
        }
    }
}

enum Constants {
    static var widthCar: CGFloat {80}
    static var heightCar: CGFloat {120}
    static var scorePointsWidth: CGFloat {50}
    static var scorePointsHeight: CGFloat {50}
    static var zero: CGFloat {0}
    static var indentForScorePoint: CGFloat {100}
    static var buttonSize: CGFloat {150}
    static var indentBarrierCar: CGFloat {100}
    static var coordinateForNextScorePoint: CGFloat {860}
}
