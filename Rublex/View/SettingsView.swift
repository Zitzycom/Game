//
//  SettingsView.swift
//  Rublex
//
//  Created by Macbook on 16.10.2023.
//

import UIKit

final class SettingsView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: SettingsViewDelegate?
    let viewFone = UIView()
    let viewFoneGameSpeed = UIView()
    let viewFonePlayer = UIView()
    let viewFoneCar = UIView()
    let avatarView = UIImageView()
    var segmentGameDifficulty = UISegmentedControl()
    var segmentMyCarColor = UISegmentedControl()
    var segmentFoneType = UISegmentedControl()
    let arrayNameDifficulty = ["easy", "medium", "hight"]
    let arrayNameMyCarColor = ["black", "red"]
    let arrayNameTypeFone = ["forest", "field", "bushes"]
    let labelOfGameSpeed = UILabel()
    let labelMyCar = UILabel()
    let labelFoneType = UILabel()
    let myName = UITextField()

    
    var curentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFone.backgroundColor = .white
        self.view.addSubview(viewFone)
        ///
        var avatar: String? = nil ?? ImageName.defaultAvatar
        guard let avatarImage = avatar else {return}
        avatarView.image = UIImage(named: avatarImage )
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.black.cgColor
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        self.view.addSubview(avatarView)
        ///
        myName.borderStyle = .roundedRect
        myName.placeholder = "Enter you name"
        myName.tintColor = .black
        guard let playerName = myName.text else { return }
        delegate?.playerName(value: playerName)
        
        self.view.addSubview(myName)
        
        ///
        segmentGameDifficulty = UISegmentedControl(items: self.arrayNameDifficulty)
        self.view.addSubview(segmentGameDifficulty)
        self.segmentGameDifficulty.addTarget(self, action: #selector(segmentSpeedChoice(target: )), for: .valueChanged)
        segmentGameDifficulty.tintColor = .black
        ///
        labelOfGameSpeed.text = "game speed"
        labelOfGameSpeed.tintColor = .black
        labelOfGameSpeed.textAlignment = .center
        self.view.addSubview(labelOfGameSpeed)
        
        ///
        viewFoneGameSpeed.backgroundColor = .gray
        viewFoneGameSpeed.layer.cornerRadius = 30
        self.view.insertSubview(viewFoneGameSpeed, at: 2)
        ///
        viewFoneCar.backgroundColor = .gray
        viewFoneCar.layer.cornerRadius = 30
        self.view.insertSubview(viewFoneCar, at: 1)
        ///
        viewFonePlayer.backgroundColor = .gray
        viewFonePlayer.layer.cornerRadius = 30
        self.view.insertSubview(viewFonePlayer, at: 2)
        ///
        segmentMyCarColor = UISegmentedControl(items: self.arrayNameMyCarColor)
        self.view.addSubview(segmentMyCarColor)
        segmentMyCarColor.addTarget(self, action: #selector(myCarChoice(target: )), for: .valueChanged)
        segmentMyCarColor.tintColor = .black
        ///
        labelMyCar.text = "You car color"
        labelMyCar.textAlignment = .center
        labelMyCar.tintColor = .black
        self.view.addSubview(labelMyCar)
        ///
        labelFoneType.text = "Choice Fone"
        labelFoneType.textAlignment = .center
        labelFoneType.tintColor = .black
        self.view.addSubview(labelFoneType)
        ///
        let barButtonPhoto = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(shutPhoto))
        navigationItem.rightBarButtonItem = barButtonPhoto
        ///
        segmentFoneType = UISegmentedControl(items: arrayNameTypeFone)
        segmentFoneType.tintColor = .black
        self.view.addSubview(segmentFoneType)
        segmentFoneType.addTarget(self, action: #selector(segmentFoneTypeChoice(target: )), for: .valueChanged)
    }
    @objc func shutPhoto () {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .photoLibrary
        camera.allowsEditing = true
        present(camera, animated: true) {
            camera.cameraFlashMode = .auto
        }
    }
    

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                // сохраняем полученное изображение
                let imageData = editedImage.pngData()
                UserDefaults.standard.set(imageData, forKey: "savedImage")
                avatarView.image = editedImage
                dismiss(animated: true, completion: nil)
            } else {
                print("No image selected.")
            }
        }
        
    @objc func myCarChoice(target: UISegmentedControl) {
        if target == self.segmentMyCarColor {
            let Index = target.selectedSegmentIndex
            let car: [MyCarColor] = [.black, .red]
            let myCar = car[Index]
            self.delegate?.choiceMyCarDelegate(value: myCar)
        }
    }
    
    @objc func segmentSpeedChoice(target: UISegmentedControl) {
        if target == self.segmentGameDifficulty {
            let speedIndex = target.selectedSegmentIndex
            let speedArray: [GameSpeed] = [.low, .medium, .higth]
            let gameSpeeds = speedArray[speedIndex]
            self.delegate?.anitameSpeedDelegate(value: gameSpeeds)
        }
    }
    
    @objc func segmentFoneTypeChoice(target: UISegmentedControl) {
        if target == self.segmentFoneType {
            let index = target.selectedSegmentIndex
            let foneArray: [FoneType] = [.forest, .field, .bushes]
            let fone = foneArray[index]
            print (fone)
            self.delegate?.choiceFoneTypeDelegate(value: fone)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        let viewHeight = self.view.bounds.height
        let viewWidth = self.view.bounds.width
        let labelHeight: CGFloat = 50
        let labelWidth: CGFloat = 150
        let foneHeight = viewHeight
        let foneWidth = viewWidth - 150
        let heightBetween: CGFloat = 30
        
        
        viewFone.translatesAutoresizingMaskIntoConstraints = false
        [viewFone.widthAnchor.constraint(equalToConstant: viewWidth - 100 ),
         viewFone.heightAnchor.constraint(equalToConstant: viewHeight),
         viewFone.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         viewFone.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ].forEach { constraint in
            constraint.isActive = true
        }

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        [avatarView.widthAnchor.constraint(equalToConstant: viewWidth / 2.5),
         avatarView.heightAnchor.constraint(equalToConstant: viewHeight / 5),
         avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ].forEach { constraint in
            constraint.isActive = true
        }
        segmentGameDifficulty.translatesAutoresizingMaskIntoConstraints = false
        [segmentGameDifficulty.centerYAnchor.constraint(equalTo: viewFoneGameSpeed.centerYAnchor, constant: 0),
         segmentGameDifficulty.centerXAnchor.constraint(equalTo: viewFoneGameSpeed.centerXAnchor, constant: 0)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelOfGameSpeed.translatesAutoresizingMaskIntoConstraints = false
        [labelOfGameSpeed.heightAnchor.constraint(equalToConstant: labelHeight),
         labelOfGameSpeed.widthAnchor.constraint(equalToConstant: labelWidth),
         labelOfGameSpeed.centerXAnchor.constraint(equalTo: view.centerXAnchor , constant: 0 ),
         labelOfGameSpeed.centerYAnchor.constraint(equalTo: viewFoneGameSpeed.topAnchor , constant: heightBetween)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewFoneGameSpeed.translatesAutoresizingMaskIntoConstraints = false
        [viewFoneGameSpeed.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15),
         viewFoneGameSpeed.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         viewFoneGameSpeed.widthAnchor.constraint(equalToConstant: foneWidth),
         viewFoneGameSpeed.heightAnchor.constraint(equalToConstant: viewHeight / 5)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewFoneCar.translatesAutoresizingMaskIntoConstraints = false
        [viewFoneCar.topAnchor.constraint(equalTo: viewFoneGameSpeed.bottomAnchor, constant: heightBetween),
         viewFoneCar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         viewFoneCar.heightAnchor.constraint(equalToConstant: foneHeight / 2.5),
         viewFoneCar.widthAnchor.constraint(equalToConstant: foneWidth)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        viewFonePlayer.translatesAutoresizingMaskIntoConstraints = false
        [viewFonePlayer.bottomAnchor.constraint(equalTo: viewFoneGameSpeed.topAnchor, constant: -heightBetween),
         viewFonePlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         viewFonePlayer.heightAnchor.constraint(equalToConstant: foneHeight / 2.5),
         viewFonePlayer.widthAnchor.constraint(equalToConstant: foneWidth)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelMyCar.translatesAutoresizingMaskIntoConstraints = false
        [labelMyCar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         labelMyCar.centerYAnchor.constraint(equalTo: viewFoneCar.topAnchor, constant: heightBetween),
         labelMyCar.widthAnchor.constraint(equalToConstant: labelWidth),
         labelMyCar.heightAnchor.constraint(equalToConstant: labelHeight)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        segmentMyCarColor.translatesAutoresizingMaskIntoConstraints = false
        [segmentMyCarColor.centerYAnchor.constraint(equalTo: labelMyCar.bottomAnchor, constant: heightBetween),
         segmentMyCarColor.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0 )
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        labelFoneType.translatesAutoresizingMaskIntoConstraints = false
        [labelFoneType.centerYAnchor.constraint(equalTo: segmentMyCarColor.bottomAnchor, constant: heightBetween),
         labelFoneType.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         labelFoneType.widthAnchor.constraint(equalToConstant: labelWidth),
         labelFoneType.heightAnchor.constraint(equalToConstant: heightBetween)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        segmentFoneType.translatesAutoresizingMaskIntoConstraints = false
        [segmentFoneType.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         segmentFoneType.centerYAnchor.constraint(equalTo: labelFoneType.bottomAnchor, constant: heightBetween)
        ].forEach { constraint in
            constraint.isActive = true
        }
        
        myName.translatesAutoresizingMaskIntoConstraints = false
        [myName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
         myName.bottomAnchor.constraint(equalTo: viewFonePlayer.bottomAnchor, constant: -10),
         myName.widthAnchor.constraint(equalToConstant: labelWidth),
         myName.heightAnchor.constraint(equalToConstant: labelHeight)
        ].forEach { constraint in
            constraint.isActive = true
        }
    }
}

protocol SettingsViewDelegate: AnyObject {
    func anitameSpeedDelegate(value: GameSpeed)
    func choiceMyCarDelegate(value: MyCarColor)
    func choiceFoneTypeDelegate(value: FoneType)
    func playerName(value: String)
}


extension SettingsView {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myName.resignFirstResponder()
        return true
      }
}



