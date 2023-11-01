//
//  Button.swift
//  Rublex
//
//  Created by Macbook on 29.09.2023.
//

import UIKit

class ButtonFactory {
    static func createButton (backgroundImage: String, nameForButton: String, coordinate: [CGFloat]) -> UIButton {
        let button = UIButton()
        let setBackgroundImage = UIImage(named: backgroundImage)
        button.setBackgroundImage(setBackgroundImage, for: .normal)
        button.setTitle(nameForButton, for: .normal)
        button.frame = CGRect(x: coordinate[0], y: coordinate[1], width: coordinate[2], height: coordinate[3])
        return button
    }
}
