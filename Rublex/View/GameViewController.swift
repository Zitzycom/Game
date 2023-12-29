//
//  GameViewController.swift
//  Rublex
//
//  Created by Macbook on 25.09.2023.
//

import UIKit

final class GameViewController: UIViewController {
    // MARK: -  Private properties
    
    private lazy var scorePoints: UILabel = {
        let scorePoints = UILabel(frame: CGRect(x: self.view.bounds.width - Constants.indentForScorePoint, y: .zero, width: Constants.scorePointsWidth, height: Constants.scorePointsHeight))
        scorePoints.backgroundColor = .white
        scorePoints.text = String(score)
        scorePoints.textAlignment = .center
        self.viewRoad.addSubview(scorePoints)
        return scorePoints
    }()

    private lazy var viewRoad: UIImageView = {
        let viewRoad = UIImageView()
        viewRoad.frame = CGRect(x: Constants.viewRoadIndent, y: .zero, width: self.view.bounds.width - Constants.viewRoadIndent, height: self.view.bounds.height )
        viewRoad.center = view.center
        let imageRoad = UIImage(named: ImageName.road)
        viewRoad.image = imageRoad
        self.view.addSubview(viewRoad)
        return viewRoad
    }()
    
    private lazy var myCar: UIImageView = {
        var myCar = UIImageView()
        myCar.frame = CGRect(x: view.bounds.width / .two - Constants.widthCar, y: view.bounds.height - Constants.heightCar, width: Constants.widthCar, height: Constants.heightCar)
        myCar.image = UIImage(named: ImageName.myCar)
        self.viewRoad.addSubview(myCar)
        return myCar
    }()
    
    private lazy var buttonPlay: UIButton = {
        let buttonPlay = UIButton(frame: CGRect(x: .zero, y: .zero, width: Constants.buttonSize, height: Constants.buttonSize))
        let image = UIImage(named: ImageName.button)
        buttonPlay.setBackgroundImage(image, for: .normal)
        buttonPlay.center = view.center
        view.addSubview(buttonPlay)
        return buttonPlay
    }()
    
    private lazy var buttonLeft: UIButton = {
        let buttonLeft = ButtonFactory.createButton(backgroundImage: ImageName.buttonLeft, nameForButton: "", frame: CGRect(x: view.bounds.width - Constants.indentXForButtonContror, y: view.bounds.height - Constants.indentYForButtonContror, width: view.bounds.width / Constants.screenRatioDivider, height: view.bounds.height / Constants.screenRatioDivider))
        buttonLeft.addTarget(self, action: #selector(driveInLeft), for: .touchUpInside)
        return buttonLeft
    }()
    
    private lazy var buttonRight: UIButton = {
        let buttonRight = ButtonFactory.createButton(backgroundImage: ImageName.buttonRight, nameForButton: "", frame: CGRect(x: view.bounds.width - Constants.indentXForButtonContror / .two, y: view.bounds.height - Constants.indentYForButtonContror, width: view.bounds.width / Constants.screenRatioDivider, height: view.bounds.height / Constants.screenRatioDivider))
        buttonRight.addTarget(self, action: #selector(driveInRight), for: .touchUpInside)
        return buttonRight
    }()
    
    private var score = 0 {
        didSet{
            if score > maxScore {
                self.maxScore = score
            }
        }
    }
    
    private var maxScore = 0
    private weak var timer: Timer?
    private weak var barrierCar: UIImageView?
    
    // MARK: - Other properties
    
    var model: Player = .init(name: "", score: 0, gameSpeed: .medium, barrierCarColor: .black, backFone: .forest)
    weak var gameViewDelegate: GameViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barrierCar = self.barrierCarAnimate()
        self.view.addSubview(viewRoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground(location: .zero, endLocation: view.bounds.height)
        animateBackground(location: -view.bounds.height,endLocation: .zero)
        buttonPlay.addTarget(self, action: #selector(targetForButtonPlay), for: .allEvents)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.getDelegate()
 }
    // MARK: - Private Methods
    
    private func animateBackground(location: CGFloat, endLocation: CGFloat) {
        let backgroundImageView = UIImageView(image: UIImage(named: model.backFone.value))
        backgroundImageView.frame = CGRect(x: .zero, y: location, width: view.bounds.width, height: view.bounds.height)
        view.insertSubview(backgroundImageView, at: .zero)
        UIView.animate(withDuration: Constants.speedBackgroung, delay: .zero, options: [.curveLinear, .repeat], animations: {
            backgroundImageView.frame.origin.y = endLocation
        }, completion: { _ in
            backgroundImageView.frame.origin.y = location
        })
    }
    
    @objc private func targetForButtonPlay() {
        buttonPlay.removeFromSuperview()
        self.view.addSubview(buttonLeft)
        self.view.addSubview(buttonRight)
        self.view.addSubview(scorePoints)
        startAnimate()
    }
    
    @objc private func driveInLeft() {
        UIImageView.animate(withDuration: Constants.myCarSpeedAnimate) {
            if self.myCar.frame.origin.x > self.viewRoad.frame.origin.x - Constants.viewRoadIndent / .two {
                self.myCar.frame.origin.x -= Constants.carStepSideways
            }else {
                self.myCar.stopAnimating()
            }
        }
    }
    
    @objc private func driveInRight() {
        UIImageView.animate(withDuration: Constants.myCarSpeedAnimate) {
            if self.myCar.frame.origin.x < self.viewRoad.bounds.width - Constants.widthCar{
                self.myCar.frame.origin.x += Constants.carStepSideways
            }else {
                self.myCar.stopAnimating()
            }
        }
    }
    
    private func barrierCarAnimate() -> UIImageView? {
        let barrierCar = UIImageView(frame: CGRect(x: .random(in: (Constants.viewRoadIndent / .four)...(view.bounds.width - Constants.viewRoadIndent - Constants.widthCar)), y: -Constants.heightCar, width: Constants.widthCar, height: Constants.heightCar))
              barrierCar.image = UIImage(named: model.barrierCarColor.value)
              viewRoad.addSubview(barrierCar)
        self.barrierCar = barrierCar
        return barrierCar
          }
    
    private func startAnimate() {
        timer = Timer.scheduledTimer(withTimeInterval: model.gameSpeed.value, repeats: true, block: { [weak self] _ in
            guard let self else {return}
            self.animateCar()
        })
        guard let barrierCar = barrierCar else {return}
        barrierCar.frame.origin.x = .random(in: (Constants.viewRoadIndent / .two)...(view.bounds.width - Constants.viewRoadIndent - Constants.widthCar))
    }
    
  
    private func animateCar() {
        guard let barrierCar = barrierCar else {return}
        if presentedViewController != nil {
              return
          }
        switch myCar.intersects(barrierCar) {
            case false:
                timer?.invalidate()
            UIImageView.animate(withDuration: 0.3 , delay: .zero ,options: .curveLinear) { [weak self] in
                guard let self else {return}
                barrierCar.frame.origin.y += Constants.myCarStep
                    self.resultScore()
                }
            case true:
                present(giveAlertGameOver(), animated: true)
            
            }
        if barrierCar.frame.origin.y > Constants.restartBoundary {
                stopAnimate()
                startAnimate()
            }
    }
    
    private func stopAnimate() {
        guard let barrierCar = barrierCar else {return}
        barrierCar.frame.origin.y = -Constants.heightCar
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func giveAlertGameOver() -> UIAlertController{
        let alert = UIAlertController(title: Constants.gameOver, message: "\(Constants.youLose) \(score)", preferredStyle: .alert)
        let alertButtonBackMenu = UIAlertAction(title: Constants.backMenu, style: .default) { [weak self] _ in
            guard let self else {return}
            self.getDelegate()
            self.stopAnimate()
            
            self.navigationController?.popViewController(animated: false)
        }
        let alertButtonReplay = UIAlertAction(title: Constants.newGame, style: .cancel) { [weak self] _ in
            guard let self else {return}
            self.stopAnimate()
            self.score = .zero
            self.startAnimate()
            self.myCar.frame.origin.x = self.view.bounds.width / .two - Constants.widthCar
        }
        alert.addAction(alertButtonReplay)
        alert.addAction(alertButtonBackMenu)
        return alert
    }
    
    private  func resultScore()  {
        guard let barrierCar = barrierCar else {return}
        if barrierCar.frame.origin.y == Constants.coordinateForNextScorePoint {
            score += .one
            model.score = maxScore
        }
        scorePoints.text = String(score)
    }
    
    private func getDelegate() {
        gameViewDelegate?.dateDelegate(value: Date.now)
        gameViewDelegate?.scorePointDelegate(value: maxScore)
    }
    
    private func setConstrint() {
        NSLayoutConstraint.activate([buttonRight.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50), buttonRight.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)])
    }
}
// MARK: - Extension
extension UIImageView {
    func intersects(_ her: UIImageView) -> Bool {
        let herInMyGeometry = convert(her.bounds, from: her)
        return bounds.intersects(herInMyGeometry)
    }
}
// MARK: - Delegate
protocol GameViewDelegate: AnyObject {
    func scorePointDelegate(value: Int)
    func dateDelegate(value: Date)
}

