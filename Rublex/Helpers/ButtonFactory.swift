//
//  ButtonFactory.swift
//  Rublex
//
//  Created by Macbook on 29.09.2023.
//

import UIKit

final class ButtonFactory {
    static func createButton (backgroundImage: String, nameForButton: String, frame: CGRect) -> UIButton {
        let button = UIButton()
        let setBackgroundImage = UIImage(named: backgroundImage)
        button.setBackgroundImage(setBackgroundImage, for: .normal)
        button.setTitle(nameForButton, for: .normal)
        button.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        return button
    }
}
