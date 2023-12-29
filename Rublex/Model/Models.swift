//
//  Models.swift
//  Rublex
//
//  Created by Macbook on 30.11.2023.
//

import UIKit

// MARK: - Struct Player
struct Player: Codable {
    var name: String? = ""
    var score: Int = 0
    var gameSpeed: GameSpeed = .medium
    var barrierCarColor: BarrierCarColor = .black
    var backFone: FoneType = .forest
    var photo: UIImage?
    var date: Date?

    enum CodingKeys: String, CodingKey {
          case  name, score, gameSpeed, barrierCarColor, backFone,  date
      }
}

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
    static var defaultAvatar : String {"DefaultAvatar"}
}

enum GameSpeed: Codable {
    case low
    case medium
    case higth
    var value: Double {
        switch self {
        case .low: return 0.03
        case .medium: return 0.015
        case .higth: return 0.008
        }
    }
}

enum BarrierCarColor: Codable {
    case red
    case black
    var value: String {
        switch self {
        case .red: return "red"
        case .black: return "black"
        }
    }
}

enum FoneType: Codable {
    case forest
    case field
    case bushes
    var value: String {
        switch self {
        case .forest: return "forest"
        case .field: return "field"
        case .bushes: return "bushes"

        }
    }
}
