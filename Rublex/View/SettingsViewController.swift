//
//  SettingsViewController.swift
//  Rublex
//
//  Created by Macbook on 16.10.2023.
//

import UIKit

final class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: -  Private properties
    private let viewBackground: UIView = {
        let viewBackground = UIView()
        viewBackground.backgroundColor = .white
        return viewBackground
    }()
    
    private let viewGameSpeedBackground: UIView = {
        let viewGameSpeedBackground = UIView()
        viewGameSpeedBackground.backgroundColor = .gray
        viewGameSpeedBackground.layer.cornerRadius = LocalConstants.viewCornerRadius
        return viewGameSpeedBackground
    }()
    
    private let viewPlayerBackground: UIView = {
        let viewPlayerBackground = UIView()
        viewPlayerBackground.backgroundColor = .gray
        viewPlayerBackground.layer.cornerRadius = LocalConstants.viewCornerRadius
        return viewPlayerBackground
    }()
    
    private let viewCarBackground: UIView = {
        let viewCarBackground = UIView()
        viewCarBackground.backgroundColor = .gray
        viewCarBackground.layer.cornerRadius = LocalConstants.viewCornerRadius
        return viewCarBackground
    }()
    
    private let labelOfGameSpeed: UILabel = {
        let labelOfGameSpeed = UILabel()
        labelOfGameSpeed.text = LocalConstants.gameSpeed
        labelOfGameSpeed.tintColor = .black
        labelOfGameSpeed.textAlignment = .center
        return labelOfGameSpeed
    }()
    
    private let labelMyCar: UILabel = {
        let labelMyCar = UILabel()
        labelMyCar.text = LocalConstants.barrerCarColor
        labelMyCar.textAlignment = .center
        labelMyCar.tintColor = .black
        return labelMyCar
    }()

    private let labelBackgroundType: UILabel = {
        let labelBackgroundType = UILabel()
        labelBackgroundType.text = LocalConstants.choiceFone
        labelBackgroundType.textAlignment = .center
        labelBackgroundType.tintColor = .black
        return labelBackgroundType
    }()

    private lazy var myName: UITextField = {
        let myName = UITextField()
        myName.borderStyle = .roundedRect
        myName.placeholder = LocalConstants.enterYouName
        myName.tintColor = .black
        myName.text = model.name
        myName.delegate = self
        return myName
    }()
    
    private lazy var segmentSpeedDifficulty: UISegmentedControl = {
        let segmentSpeedDifficulty = UISegmentedControl(items: [LocalConstants.easy, LocalConstants.medium, LocalConstants.hight])
        segmentSpeedDifficulty.addTarget(self, action: #selector(segmentSpeedChoice(target: )), for: .valueChanged)
        segmentSpeedDifficulty.tintColor = .black
        return segmentSpeedDifficulty
    }()

    private lazy var segmentBarrierCarColor: UISegmentedControl = {
        let segmentBarrierCarColor = UISegmentedControl(items: [LocalConstants.black, LocalConstants.red])
        segmentBarrierCarColor.addTarget(self, action: #selector(barrierCarChoice(target: )), for: .valueChanged)
        segmentBarrierCarColor.tintColor = .black
        return segmentBarrierCarColor
    }()

    private lazy var segmentBackgroundType: UISegmentedControl = {
        let segmentBackgroundType = UISegmentedControl(items: [LocalConstants.forest, LocalConstants.field, LocalConstants.bushes])
        segmentBackgroundType.tintColor = .black
        segmentBackgroundType.addTarget(self, action: #selector(segmentFoneTypeChoice(target: )), for: .valueChanged)
        return segmentBackgroundType
    }()
    
    private lazy var labelNamePlayer: UILabel = {
        let labelNamePlayer = UILabel()
        labelNamePlayer.backgroundColor = .white
        labelNamePlayer.tintColor = .black
        labelNamePlayer.textAlignment = .center
        return labelNamePlayer
    }()
    
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFit
        avatarView.backgroundColor = .lightGray
        avatarView.layer.borderWidth = .one
        avatarView.layer.borderColor = UIColor.black.cgColor
        avatarView.layer.masksToBounds = true
        avatarView.clipsToBounds = true
        return avatarView
    }()
    
    private var gameManager = GameManager()

    // MARK:  - Other properties
    weak var settingsViewDelegate: SettingsViewDelegate?
    var model = Player()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
        createBackAndSaveButton()
        updateVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.settingsViewDelegate?.settingsViewModel(model: model)
        guard let name = model.name, let image = avatarView.image else {return}
        gameManager.save(player: model, key: name)
        if let imageURL = gameManager.saveImage(image: image, fileName: name) {
            gameManager.saveImagePathToUserDefaults(imagePath: imageURL, key: name)
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addSubviews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraint()
        self.avatarView.layoutIfNeeded()
        self.avatarView.layer.cornerRadius = min(avatarView.frame.size.width, avatarView.frame.size.height) / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Private Methods
    private func createBarButtonItems() {
        let barButtonPhoto = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(makePhoto))
        let barButtonCreateOrLoadPlayer = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createOrLoadPlayer))
        navigationItem.rightBarButtonItems = [barButtonCreateOrLoadPlayer, barButtonPhoto]
    }
    
    @objc private func createOrLoadPlayer() {
        let alert = UIAlertController(title: "Create or load player", message: nil, preferredStyle: .actionSheet)
        let alertNewPlayer = UIAlertAction(title: "Create new player", style: .default) {  [weak self] _ in
            guard let self else {return}
            self.alertWorkPlayer(titleAlert: "Create new player", self.callAlertNameTaken(text:))
        }
        let alertLoadPlayer = UIAlertAction(title: "Load player", style: .default) { [weak self] _ in
            guard let self else {return}
            self.alertWorkPlayer(titleAlert: "Load player", self.callAlertLoadPlayer(text:))
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(alertNewPlayer)
        alert.addAction(alertCancel)
        alert.addAction(alertLoadPlayer)
        self.present(alert, animated: false)
    }

    private func alertWorkPlayer(titleAlert: String, _ getChoice: @escaping (String) -> Void) {
        let alert = UIAlertController(title: titleAlert, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter name"
        }
        let actionOk = UIAlertAction(title: "Ok", style: .default) {[weak self] _ in
            guard let self = self else {return}
            if let text = alert.textFields?.first?.text {
                getChoice(text)
                self.updateVC()
            }
        }
        alert.addAction(actionOk)
        self.present(alert, animated: false)
    }
    
    private func updateVC() {
        self.myName.text = self.model.name
        self.labelNamePlayer.text = "Hi \(model.name ?? "")"
        self.choiceValueBackground()
        self.choiceValueGameSpeed()
        self.choiceValueBarrierCarColor()
        let image = gameManager.getImageFromUserDefaults(key: model.name ?? "")
        self.avatarView.image = image
    }
    
    private func choiceValueGameSpeed() {
        switch model.gameSpeed.value {
        case 0.03 : segmentSpeedDifficulty.selectedSegmentIndex = .zero
        case 0.015 : segmentSpeedDifficulty.selectedSegmentIndex = .one
        case 0.008 : segmentSpeedDifficulty.selectedSegmentIndex = .two
        default: break
        }
    }
    
    private func choiceValueBarrierCarColor() {
        if model.barrierCarColor.value == LocalConstants.black {
            segmentBarrierCarColor.selectedSegmentIndex = .zero
        }else{
            segmentBarrierCarColor.selectedSegmentIndex = .one
        }
    }
    
    private func choiceValueBackground() {
        switch model.backFone.value {
        case LocalConstants.forest: segmentBackgroundType.selectedSegmentIndex = .zero
        case LocalConstants.field: segmentBackgroundType.selectedSegmentIndex = .one
        case LocalConstants.bushes: segmentBackgroundType.selectedSegmentIndex = .two
        default: break
        }
    }
    
    private func createBackAndSaveButton() {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAndSave))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = button
    }
    
    @objc private func backAndSave() {
        guard let name = model.name else {return}
        gameManager.save(player: model, key: name)
        navigationController?.popViewController(animated: false)
    }
    
    private func callAlertLoadPlayer(text: String) {
        if UserDefaults.standard.value(Player.self, forKey: text) == nil {
            let alert = UIAlertController(title: "Error", message: "no such player exists", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(alertOk)
            self.present(alert, animated: false)
        }else{
            self.model = UserDefaults.standard.value(Player.self, forKey: text ) ?? Player(name: text)
        }
    }
    
    private func callAlertNameTaken(text: String) {
        if UserDefaults.standard.value(Player.self, forKey: text) != nil {
            let alert = UIAlertController(title: "Error", message: "this name already exists, enter another one", preferredStyle: .alert)

            let alertOk = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(alertOk)
            self.present(alert, animated: false)
        }else{
            self.model = Player(name: text)
            gameManager.save(player: model, key: model.name ?? "")
        }
    }
    
    @objc private func makePhoto () {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .photoLibrary
        camera.allowsEditing = true
        present(camera, animated: true) {
        }
    }
    
    @objc private func barrierCarChoice(target: UISegmentedControl) {
        if target == self.segmentBarrierCarColor {
            let index = target.selectedSegmentIndex
            let car: [BarrierCarColor] = [.black, .red]
            let barrierCar = car[index]
            model.barrierCarColor = barrierCar
        }
    }
    
    @objc private func segmentSpeedChoice(target: UISegmentedControl) {
        if target == self.segmentSpeedDifficulty {
            let index = target.selectedSegmentIndex
            let speedArray: [GameSpeed] = [.low, .medium, .higth]
            let gameSpeeds = speedArray[index]
            model.gameSpeed = gameSpeeds
        }
    }
    
    @objc private func segmentFoneTypeChoice(target: UISegmentedControl) {
        if target == self.segmentBackgroundType {
            let index = target.selectedSegmentIndex
            let foneArray: [FoneType] = [.forest, .field, .bushes]
            let fone = foneArray[index]
            model.backFone = fone
        }
    }
    
    private func addSubviews() {
        [viewBackground, viewCarBackground, viewGameSpeedBackground, viewPlayerBackground, labelNamePlayer, myName, labelOfGameSpeed, segmentBarrierCarColor, labelMyCar, labelBackgroundType, segmentSpeedDifficulty, segmentBackgroundType, avatarView ].forEach { [weak self] in
            guard let self else {return}
            self.view.addSubview($0)
        }
    }

    private func addConstraint() {
        let viewHeight = self.view.bounds.height
        let viewWidth = self.view.bounds.width
        let foneHeight = viewHeight / 2.5
        let foneWidth = viewWidth - 150
        
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        [viewBackground.widthAnchor.constraint(equalToConstant: viewWidth - LocalConstants.indentationForViewBackground),
         viewBackground.heightAnchor.constraint(equalToConstant: viewHeight),
         viewBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         viewBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: .zero)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewPlayerBackground.translatesAutoresizingMaskIntoConstraints = false
        [viewPlayerBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: -LocalConstants.spaceBetweenObjects),
         viewPlayerBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         viewPlayerBackground.heightAnchor.constraint(equalToConstant: foneHeight),
         viewPlayerBackground.widthAnchor.constraint(equalToConstant: foneWidth)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        [avatarView.widthAnchor.constraint(equalToConstant: LocalConstants.avatarViewSize),
         avatarView.heightAnchor.constraint(equalToConstant: LocalConstants.avatarViewSize),
         avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: LocalConstants.indentationForAvatarView)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelNamePlayer.translatesAutoresizingMaskIntoConstraints = false
        [labelNamePlayer.widthAnchor.constraint(equalToConstant: LocalConstants.labelWidth),
         labelNamePlayer.heightAnchor.constraint(equalToConstant: LocalConstants.labelHeight / .two),
         labelNamePlayer.bottomAnchor.constraint(equalTo: myName.topAnchor,constant: .zero), labelNamePlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach { constraint in
            constraint.isActive = true
        }
        
        myName.translatesAutoresizingMaskIntoConstraints = false
        [myName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         myName.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: LocalConstants.spaceBetweenObjects),
         myName.widthAnchor.constraint(equalToConstant: LocalConstants.labelWidth),
         myName.heightAnchor.constraint(equalToConstant: LocalConstants.labelHeight)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewGameSpeedBackground.translatesAutoresizingMaskIntoConstraints = false
        [viewGameSpeedBackground.topAnchor.constraint(equalTo: viewPlayerBackground.bottomAnchor, constant: LocalConstants.spaceBetweenObjects),
         viewGameSpeedBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         viewGameSpeedBackground.widthAnchor.constraint(equalToConstant: foneWidth),
         viewGameSpeedBackground.heightAnchor.constraint(equalToConstant: viewHeight / .five)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelOfGameSpeed.translatesAutoresizingMaskIntoConstraints = false
        [labelOfGameSpeed.heightAnchor.constraint(equalToConstant: LocalConstants.labelHeight),
         labelOfGameSpeed.widthAnchor.constraint(equalToConstant: LocalConstants.labelWidth),
         labelOfGameSpeed.centerXAnchor.constraint(equalTo: view.centerXAnchor , constant: .zero ),
         labelOfGameSpeed.topAnchor.constraint(equalTo: viewGameSpeedBackground.topAnchor , constant: LocalConstants.spaceBetweenObjects / .two)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        segmentSpeedDifficulty.translatesAutoresizingMaskIntoConstraints = false
        [segmentSpeedDifficulty.topAnchor.constraint(equalTo: labelOfGameSpeed.bottomAnchor, constant: LocalConstants.spaceBetweenObjects / .two),
         segmentSpeedDifficulty.centerXAnchor.constraint(equalTo: viewGameSpeedBackground.centerXAnchor, constant: .zero)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewCarBackground.translatesAutoresizingMaskIntoConstraints = false
        [viewCarBackground.topAnchor.constraint(equalTo: viewGameSpeedBackground.bottomAnchor, constant: LocalConstants.spaceBetweenObjects),
         viewCarBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         viewCarBackground.heightAnchor.constraint(equalToConstant: foneHeight),
         viewCarBackground.widthAnchor.constraint(equalToConstant: foneWidth)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelMyCar.translatesAutoresizingMaskIntoConstraints = false
        [labelMyCar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         labelMyCar.topAnchor.constraint(equalTo: viewCarBackground.topAnchor, constant: LocalConstants.spaceBetweenObjects / .two),
         labelMyCar.widthAnchor.constraint(equalToConstant: LocalConstants.labelWidth),
         labelMyCar.heightAnchor.constraint(equalToConstant: LocalConstants.labelHeight)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        segmentBarrierCarColor.translatesAutoresizingMaskIntoConstraints = false
        [segmentBarrierCarColor.topAnchor.constraint(equalTo: labelMyCar.bottomAnchor, constant: LocalConstants.spaceBetweenObjects / .two),
         segmentBarrierCarColor.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero )
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelBackgroundType.translatesAutoresizingMaskIntoConstraints = false
        [labelBackgroundType.topAnchor.constraint(equalTo: segmentBarrierCarColor.bottomAnchor, constant: LocalConstants.spaceBetweenObjects / .two),
         labelBackgroundType.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         labelBackgroundType.widthAnchor.constraint(equalToConstant: LocalConstants.labelWidth),
         labelBackgroundType.heightAnchor.constraint(equalToConstant: LocalConstants.labelHeight)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        segmentBackgroundType.translatesAutoresizingMaskIntoConstraints = false
        [segmentBackgroundType.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero),
         segmentBackgroundType.topAnchor.constraint(equalTo: labelBackgroundType.bottomAnchor, constant: LocalConstants.spaceBetweenObjects / .two)
        ].forEach { constraint in
            constraint.isActive = true
        }
    }
    
    //MARK: - Image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            guard let name = model.name else {return}
            if let imageURL = gameManager.saveImage(image: editedImage, fileName: name) {
                gameManager.saveImagePathToUserDefaults(imagePath: imageURL, key: name)
            }
            self.model.photo = editedImage
            avatarView.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - extension

protocol SettingsViewDelegate: AnyObject {
    func settingsViewModel(model: Player)
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text, let odlText = labelNamePlayer.text else {return false}
        UserDefaults.standard.removeObject(forKey: odlText )
        self.labelNamePlayer.text = "Hi \(text)"
        self.callAlertNameTaken(text: text)
        return true
      }
}

extension SettingsViewController {
    private enum LocalConstants {
        static var gameSpeed: String {"game speed"}
        static var barrerCarColor: String {"Barrier car color"}
        static var choiceFone: String {"Choice Fone"}
        static var enterYouName: String {"Enter you name"}
        static var viewCornerRadius: CGFloat {30}
        static var easy: String {"easy"}
        static var medium: String {"medium"}
        static var hight: String {"hight"}
        static var black: String {"black"}
        static var red: String {"red"}
        static var forest: String {"forest"}
        static var field: String {"field"}
        static var bushes: String {"bushes"}
        static var indentationForViewBackground: CGFloat {100}
        static var labelHeight: CGFloat {50}
        static var labelWidth: CGFloat {150}
        static var indentationForAvatarView: CGFloat {20}
        static var avatarViewSize: CGFloat {130}
        static var spaceBetweenObjects: CGFloat {30}
    }
}
