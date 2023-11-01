//
//  File.swift
//  Rublex
//
//  Created by Macbook on 20.10.2023.
//

import UIKit

//MARK: USER
struct User: Codable {
    var id = UUID().uuidString
    var name: String
    var photo: String
    var score: Int
    var data: Date
    var gameSpeed: GameSpeed
    var carColor: String
    var typeFone: String
    
    init(id: String = UUID().uuidString, name: String, photo: String, score: Int, data: Date, gameSpeed: GameSpeed, carColor: String, typeFone: String) {
        self.id = id
        self.name = name
        self.photo = photo
        self.score = score
        self.data = data
        self.gameSpeed = gameSpeed
        self.carColor = carColor
        self.typeFone = typeFone
    }
}
//MARK: StorageManager
class StorageManager {
    func saveCurentUSer(user: StartMenuModel) {
        UserDefaults.standard.set(encodable: user, forKey: "curentUSer")
    }
    
    func loadCurentUser() -> StartMenuModel?{
        guard let user = UserDefaults.standard.value(StartMenuModel.self, forKey: "curentUSer") else {return nil}
        return user
    }
    
    func saveRecords (value: [String: User]) {
        UserDefaults.standard.set(encodable: value, forKey: "")
    }
}

//MARK: extension UserDefaults
extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
