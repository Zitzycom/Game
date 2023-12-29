//
//  GameManager.swift
//  Rublex
//
//  Created by Macbook on 30.11.2023.
//

import UIKit

//MARK: - GameManger
final class GameManager {
    var keyPlayer: [String] = []
    
    init() {
        loadKeyPlayer()
    }
    
    func save(player: Player, key: String) {
        UserDefaults.standard.set(encodable: player, forKey: key)
        if !keyPlayer.contains(key) {
               keyPlayer.append(key)
           }
        UserDefaults.standard.set(encodable: keyPlayer, forKey: "key")
    }
    
    func load(key: String) -> Player? {
        loadKeyPlayer()
        return UserDefaults.standard.value(Player.self, forKey: key)
    }
    
    func loadKeyPlayer() {
        keyPlayer = UserDefaults.standard.value([String].self, forKey: "key") ?? []
    }
    
    func saveImage(image: UIImage, fileName: String) -> URL? {
        if let data = image.jpegData(compressionQuality: 1) {
            let URLData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("image_\(fileName).jpg")
            do{
                try data.write(to: URLData)
                return URLData
            }catch{
                print ("Error, ", error)
                return nil
            }
        }
        return nil
    }
    
    func saveImagePathToUserDefaults(imagePath: URL, key: String) {
        UserDefaults.standard.set(imagePath, forKey: "image_\(key)")
    }
    
    func getImageFromUserDefaults(key: String) -> UIImage? {
        if let imagePath = UserDefaults.standard.url(forKey: "image_\(key)") {
            do {
                let imageData = try Data(contentsOf: imagePath)
                return UIImage(data: imageData)
            }catch{
                print ("error, ", error)
                return nil
            }
        }
        return nil
    }
}

//MARK: - Extension UserDefaults
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

