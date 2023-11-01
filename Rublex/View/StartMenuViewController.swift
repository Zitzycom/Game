//
//  StartMenuViewController.swift
//  Rublex
//
//  Created by Macbook on 06.10.2023.
//

import UIKit

class StartMenuViewController: UIViewController {
    weak var buttonStart: UIButton?
    weak var buttonRecords: UIButton?
    weak var buttonOptions: UIButton?
    var model = StartMenuModel(name: "", gameSpeed: .medium, myCar: .black, backFone: .bushes, photo: "", date: .now)
    let manager = StorageManager()

    var dictionary: [String: User] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let load = manager.loadCurentUser() else { return }
        model = load
        
        let buttonStart = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: "Start", coordinate: [0, 0, 300, 150])
        buttonStart.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 4) 
        buttonStart.setTitleColor(.black, for: .normal)
        self.view.addSubview(buttonStart)
        self.buttonStart = buttonStart
        
        let buttonRecords = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: "Records", coordinate: [0, 0, 300, 150])
        buttonRecords.setTitleColor(.black, for: .normal)
        buttonRecords.center = self.view.center
        self.view.addSubview(buttonRecords)
        self.buttonRecords = buttonRecords
        
        let buttonOptions = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: "Options", coordinate: [0, 0, 300, 150])
        buttonOptions.setTitleColor(.black, for: .normal)
        buttonOptions.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height * 0.75)
        self.view.addSubview(buttonOptions)
        self.buttonOptions = buttonOptions
        
        self.buttonStart?.addTarget(self, action: #selector(getToGameView), for: .touchDown)
        self.buttonOptions?.addTarget(self, action: #selector(getToSettingsView), for: .touchDown)
        self.buttonRecords?.addTarget(self, action: #selector(getToRecordsView), for: .touchDown)

    }
    
    
    
    @objc func getToSettingsView() {
        let settingView = SettingsView()
        settingView.delegate = self
        navigationController?.pushViewController(settingView, animated: false)
    }
    @objc func getToGameView() {
        print(model)
        let gameView = GameViewController()
        gameView.model = .init(name: model.name, gameSpeed: model.gameSpeed, myCar: model.myCar, backFone: model.backFone, photo: model.photo, date: Date.now)
        navigationController?.pushViewController(gameView, animated: true)
    }
    @objc func getToRecordsView() {
        let recordsView = RecordsViewController()
        let cell = RecordsTableViewCell()
        cell.label.text = model.backFone.value
        navigationController?.pushViewController(recordsView, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        manager.saveCurentUSer(user: model)
    }
}



struct StartMenuModel: Codable {
    var id = UUID().uuidString
    var name: String
    var gameSpeed: GameSpeed
    var myCar: MyCarColor
    var backFone: FoneType
    var photo: String
    var date: Date
}
//MARK: Delegate
extension StartMenuViewController: SettingsViewDelegate {
    func choiceMyCarDelegate(value: MyCarColor) {
        self.model.myCar = value
    }
    func anitameSpeedDelegate(value: GameSpeed) {
        self.model.gameSpeed = value
    }
    func choiceFoneTypeDelegate(value: FoneType) {
        self.model.backFone = value
    }
    func playerName(value: String) {
        self.model.name = value
    }
}
