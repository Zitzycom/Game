//
//  ViewController.swift
//  Rublex
//
//  Created by Macbook on 25.09.2023.
//

import UIKit



class GameViewController: UIViewController {
    
    var model: StartMenuModel = .init(name: "", gameSpeed: .medium, myCar: .black, backFone: .forest, photo: "", date: .now)
    let scorePoints = UILabel()
    var score = 0
    let layerBackground = UIImageView()
    let layerBackgroundFirst = UIImageView()
    let viewRoad = UIImageView()
    let barrierCar = UIImageView()
    weak var buttonPlay: UIButton?
    weak var myCar : UIImageView?
    weak var buttonLeft: UIButton?
    weak var buttonRight: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: create objects
        //create barrierCar
        barrierCar.frame = CGRect(x: getRandomCoordinate(), y: -Constants.indentBarrierCar, width: Constants.widthCar, height: Constants.heightCar)
        barrierCar.image = UIImage(named: self.model.myCar.value)
        self.viewRoad.addSubview(barrierCar)
        //create scorePoints
        scorePoints.frame = CGRect(x: self.view.bounds.width - Constants.indentForScorePoint, y: Constants.zero, width: Constants.scorePointsWidth, height: Constants.scorePointsHeight)
        scorePoints.backgroundColor = .white
        scorePoints.text = String(0)
        scorePoints.textAlignment = .center
        self.viewRoad.addSubview(scorePoints)
        //create my car
        let myCar = CarFactory.createCar(backgroundImage: ImageName.myCar, coordinate: [(self.view.bounds.width - 100) / 2 - 40, self.view.bounds.height - 120 ])
        self.viewRoad.addSubview(myCar)
        myCar.image = UIImage(named: ImageName.myCar)
        self.myCar = myCar
        //create viewRoad
        viewRoad.frame = CGRect(x: 100, y: 0, width: view.bounds.width - 100, height: view.bounds.height )
        viewRoad.center = view.center
        let imageRoad = UIImage(named: ImageName.road)
        viewRoad.image = imageRoad
        self.view.addSubview(viewRoad)
        //create buttonPlay
        let buttonPlay = ButtonFactory.createButton(backgroundImage: ImageName.button, nameForButton: "", coordinate: [Constants.zero, Constants.zero, Constants.buttonSize, Constants.buttonSize])
        buttonPlay.center = self.view.center
        self.view.addSubview(buttonPlay)
        self.buttonPlay = buttonPlay
        //create buttonLeft
        let buttonLeft = ButtonFactory.createButton(backgroundImage: ImageName.buttonLeft, nameForButton: "", coordinate: [(self.view.bounds.width) - 300, (self.view.bounds.height) - 250, (self.view.bounds.width) / 5, (self.view.bounds.height) / 5])
        self.view.addSubview(buttonLeft)
        self.buttonLeft = buttonLeft
        buttonLeft.addTarget(self, action: #selector(driveInLeft), for: .touchUpInside)
        //create buttonRight
        let buttonRight = ButtonFactory.createButton(backgroundImage: ImageName.buttonRight, nameForButton: "", coordinate: [(self.view.bounds.width) - 150, (self.view.bounds.height) - 250, (self.view.bounds.width) / 5, (self.view.bounds.height) / 5])
        self.view.addSubview(buttonRight)
        self.buttonRight = buttonRight
        buttonRight.addTarget(self, action: #selector(driveInRight), for: .touchUpInside)
        //MARK: call funcs
        buttonPlay.addTarget(self, action: #selector(targetForButtonPlay), for: .allEvents)
        movementBackground(object: layerBackground, coordinateX: -view.frame.origin.x, coordinateY: -view.frame.origin.y)
        movementBackground(object: layerBackgroundFirst, coordinateX: Constants.zero, coordinateY: -self.view.bounds.height)
        
    }
    
    //MARK: create funcs
    //create movemont background
    @objc func movementBackground (object: UIImageView, coordinateX: CGFloat, coordinateY: CGFloat) {
        object.frame = CGRect(x: coordinateX, y: coordinateY, width: view.bounds.width, height: view.bounds.height)
        object.image = UIImage(named: self.model.backFone.value)
        self.view.insertSubview(object, at: 0)
        UIImageView.animate(withDuration: 10, delay: 0, options: [.curveLinear ]) {
            object.frame.origin.y += self.view.bounds.height
        } completion: { _ in
            object.removeFromSuperview()
            self.movementBackground(object: object, coordinateX: coordinateX, coordinateY: coordinateY)
        }
    }
    
    //create target for button play
    @objc func targetForButtonPlay() {
        buttonPlay?.removeFromSuperview()
        movementBarrier(object: barrierCar, coordinateX: getRandomCoordinate(), coordinateY: -Constants.indentBarrierCar, animateSpeed: Double(self.model.gameSpeed.value))
    }
    
    //create movement barrier
    func movementBarrier (object: UIImageView, coordinateX: CGFloat, coordinateY: CGFloat, animateSpeed: Double) {
        if object.frame.origin.y == 0 {
            object.frame.origin.x = coordinateX
            object.frame.origin.y = coordinateY
        }
        guard let myCar = myCar else {return}
        self.scorePoints.text = self.resultScore(car: myCar, barrier: object, label: self.scorePoints)

        let frameObjectY = object.frame.origin.y
        let frameObjectX = object.frame.origin.x
        object.frame = CGRect(x: frameObjectX, y: frameObjectY, width: 60, height: 90)
        object.image = UIImage(named: self.model.myCar.value)
        self.view.addSubview(object)
        let getAnimateBarrier = { (object: UIImageView) in
            guard let myCar = self.myCar else {return}
            if myCar.intersectss(self.barrierCar) == false {
                UIImageView.animate(withDuration: animateSpeed , delay: 0, options: [.curveLinear]) {
                    object.frame.origin.y += 15
                } completion: { _ in
                    self.movementBarrier(object: object, coordinateX: frameObjectX, coordinateY: frameObjectY,animateSpeed: animateSpeed)
                    if object.frame.origin.y > myCar.frame.origin.y + myCar.bounds.height + 200 {
                        object.removeFromSuperview()
                        object.frame.origin.y = 0
                        self.movementBarrier(object: object, coordinateX: self.getRandomCoordinate(), coordinateY: 0, animateSpeed: animateSpeed)
                    }
                }
            } else {
                        object.stopAnimating()
                let allertGameOver = UIAlertController(title: "game over", message: "You score \(self.score)", preferredStyle: .alert)
                let alertBackForMenu = UIAlertAction(title: "back menu", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                let arertReplay = UIAlertAction(title: "new game", style: .cancel) { _ in
                     object.removeFromSuperview()
                        object.frame.origin.y = 0
                        object.startAnimating()
                        self.movementBarrier(object: object, coordinateX: self.getRandomCoordinate(), coordinateY: -20,animateSpeed: animateSpeed)
                        self.myCar?.frame.origin.x = (self.view.bounds.width - 100) / 2 - 40

                }
                allertGameOver.addAction(alertBackForMenu)
                allertGameOver.addAction(arertReplay)
                self.present(allertGameOver, animated: true)
            }
        }
        getAnimateBarrier(object)
    }

    //create drive my car in left
    @objc func driveInLeft() {
        UIImageView.animate(withDuration: 0.3) {
            let coordinateXCar = self.myCar?.frame.origin.x
            guard let xCarOrigin = coordinateXCar else {return}
            if xCarOrigin > self.viewRoad.frame.origin.x - 50{
                self.myCar?.frame.origin.x -= 7
            }else {
                self.myCar?.stopAnimating()
            }
        }
    }

    //create drive my car in right
    @objc func driveInRight() {
        UIImageView.animate(withDuration: 0.3) {
            let coordinateXCar = self.myCar?.frame.origin.x
            guard let xCarOrigin = coordinateXCar else {return}
            if xCarOrigin < self.viewRoad.bounds.width - 75{
                self.myCar?.frame.origin.x += 7
            }else {
                self.myCar?.stopAnimating()
            }
        }
    }
    // get random coordinate to coordinate x for barrier car
    func getRandomCoordinate() -> CGFloat {
        let coordinateArray = (50...265)
        guard let randomElement = coordinateArray.randomElement() else {return 0}
        let result = randomElement
        return CGFloat(result)
    }
}
//MARK: extensions
extension UIImageView {
    func intersectss(_ her: UIImageView) -> Bool {
        let herInMyGeometry = convert(her.bounds, from: her)
        return bounds.intersects(herInMyGeometry)
    }
}



extension GameViewController {
    struct GameViewModel {
        var model: StartMenuModel = .init(name: "", gameSpeed: .medium, myCar: .black, backFone: .forest, photo: "", date: .now)
    }
    
    func resultScore(car: UIImageView, barrier: UIImageView, label: UILabel ) -> String? {
        var labelText = "\(score)"
        if barrier.frame.origin.y >= Constants.coordinateForNextScorePoint {
            score += 1
            print (barrier.frame.origin.y)
            labelText = "\(score)"
            print(labelText)
        }
        return labelText
    }
}

