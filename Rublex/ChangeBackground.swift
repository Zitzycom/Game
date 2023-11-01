//
//  ChangeBackground.swift
//  Rublex
//
//  Created by Macbook on 30.09.2023.
//

import UIKit

class ChangeBackground: UIImageView {
    var newBack = UIImageView()
    func changeBack() {
        newBack.frame = CGRect(x: self.view?.bounds.x, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
}
