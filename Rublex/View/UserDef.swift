//
//  UserDef.swift
//  Rublex
//
//  Created by Macbook on 19.10.2023.
//

import Foundation

class UserDef {
    
}


//Для работы с UserDefaults, вам не обязательно создавать отдельный класс, но если вы хотите, то можете сделать это следующим образом:
//
//Создайте новый Swift файл (File -> New -> File -> Swift File) и назовите его, например, UserDefaultsManager.swift.
//В этом файле создайте класс, который будет управлять UserDefaults:
//import Foundation

class UserDefaultsManager {

    // Функция для сохранения данных в UserDefaults
    static func saveData(_ data: Data, forKey key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }

    // Функция для загрузки данных из UserDefaults
    class func loadData<T>(forKey key: String, defaultValue: T?) -> T? {
        return UserDefaults.standard.object(forKey: key) as? T
    }
}
//Чтобы сохранить данные в UserDefaults, вызовите функцию saveData передав в нее данные и ключ, по которому вы хотите сохранить эти данные:
//let someData = 1
//UserDefaultsManager.saveData(someData, forKey: "someKey")

//4. Чтобы загрузить данные из UserDefaults, вызовите функцию `loadData` указав ключ, по которому хотите получить данные, и значение по умолчанию, которое будет возвращено если данные не были сохранены:
//let data = UserDefaultsManager.loadData(forKey: "someKey", defaultValue: nil)
