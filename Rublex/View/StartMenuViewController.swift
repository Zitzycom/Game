//
//  StartMenuViewController.swift
//  Rublex
//
//  Created by Macbook on 06.10.2023.
//

import UIKit

final class StartMenuViewController: UIViewController {
    
    // MARK: -  Properties

    private weak var buttonStart: UIButton?
    private weak var buttonRecords: UIButton?
    private weak var buttonOptions: UIButton?
    var model = Player()
    private let gameManager = GameManager()

    // MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = gameManager.load(key: model.name ?? "") ?? model
        cteateButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameManager.save(player: model, key: model.name ?? "")
    }
    
    // MARK: - Private Methods

    private func cteateButton() {
        let buttonStart = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: LocalConstants.start, frame: CGRect(x: .zero, y: .zero, width: LocalConstants.buttonWidth, height: LocalConstants.buttonHeight))
        buttonStart.center = CGPoint(x: self.view.bounds.width / .two, y: self.view.bounds.height / .four)
        buttonStart.setTitleColor(.black, for: .normal)
        self.view.addSubview(buttonStart)
        buttonStart.addTarget(self, action: #selector(getToGameView), for: .touchDown)
        self.buttonStart = buttonStart
        
        let buttonRecords = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: LocalConstants.records,frame: CGRect(x: .zero, y: .zero, width: LocalConstants.buttonWidth, height: LocalConstants.buttonHeight))
        buttonRecords.setTitleColor(.black, for: .normal)
        buttonRecords.center = self.view.center
        self.view.addSubview(buttonRecords)
        buttonRecords.addTarget(self, action: #selector(getToRecordsView), for: .touchDown)
        self.buttonRecords = buttonRecords
        
        let buttonOptions = ButtonFactory.createButton(backgroundImage: ImageName.buttonForMenu, nameForButton: LocalConstants.options, frame: CGRect(x: .zero, y: .zero, width: LocalConstants.buttonWidth, height: LocalConstants.buttonHeight))
        buttonOptions.setTitleColor(.black, for: .normal)
        buttonOptions.center = CGPoint(x: self.view.bounds.width / .two, y: self.view.bounds.height * .pointSevenFive)
        self.view.addSubview(buttonOptions)
        buttonOptions.addTarget(self, action: #selector(getToSettingsView), for: .touchDown)
        self.buttonOptions = buttonOptions
    }
    
    @objc private func getToSettingsView() {
        let settingView = SettingsViewController()
        settingView.settingsViewDelegate = self
        settingView.model = self.model
        navigationController?.pushViewController(settingView, animated: false)
    }
    
    @objc private func getToGameView() {
        let gameView = GameViewController()
        gameView.gameViewDelegate = self
        gameView.model = .init(name: model.name ,score: model.score, gameSpeed: model.gameSpeed, barrierCarColor: model.barrierCarColor, backFone: model.backFone, photo: model.photo, date: nil)
        navigationController?.pushViewController(gameView, animated: false)
    }
    
    @objc private func getToRecordsView() {
        let recordsView = RecordsViewController()
        navigationController?.pushViewController(recordsView, animated: false)
    }
}

//MARK: - Delegate

extension StartMenuViewController: SettingsViewDelegate {
    func settingsViewModel(model: Player) {
        self.model = model
    }
}

extension StartMenuViewController: GameViewDelegate {
    func scorePointDelegate(value: Int) {
        self.model.score = value
    }
    func dateDelegate(value: Date) {
        self.model.date = value
    }
}

//MARK: - Local constants
extension StartMenuViewController {
    private enum LocalConstants {
        static var buttonWidth: CGFloat {300}
        static var buttonHeight: CGFloat {150}
        static var start: String {"Start"}
        static var records: String {"Records"}
        static var options: String {"Options"}
    }
}
