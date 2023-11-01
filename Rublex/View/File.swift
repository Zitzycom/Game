//
//  File.swift
//  Rublex
//
//  Created by Macbook on 19.10.2023.
//

import UIKit

class q {
    func getAnimateBarrier(object: UIImageView, view: ViewController) {
        guard let myCar = self.myCar else {return}
        if myCar.intersectss(self.barrierCar) == false {
            UIImageView.animate(withDuration: 0.01 , delay: 0, options: [.curveLinear]) {
                object.frame.origin.y += 15
                object.image = UIImage(named: ImageName.field)
            } completion: { _ in
                self.movementBarrier(object: object, coordinateX: frameObjectX, coordinateY: frameObjectY)
                if object.frame.origin.y > 500 {
                    object.removeFromSuperview()
                    object.frame.origin.y = 0
                    self.movementBarrier(object: object, coordinateX: self.getRandomCoordinate(), coordinateY: 0)
                }
            }
        } else {
            print ("stop")
            
            object.stopAnimating()
            let allertGameOver = UIAlertController(title: nil, message: "game over", preferredStyle: .alert)
            let alertBackForMenu = UIAlertAction(title: "back menu", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            let arertReplay = UIAlertAction(title: "new game", style: .cancel) { _ in
                object.removeFromSuperview()
                print ("remove")
                object.frame.origin.y = 0
                object.startAnimating()
                self.movementBarrier(object: object, coordinateX: self.getRandomCoordinate(), coordinateY: -20)
                self.myCar?.frame.origin.x = 120
                
            }
            allertGameOver.addAction(alertBackForMenu)
            allertGameOver.addAction(arertReplay)
            self.present(allertGameOver, animated: true)
        }
        }
}
