//
//  AlertViewController.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 18/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    let soundImagesString = ["Sound_on", "Sound_off"]
    var currentImsageStringIndex = GameSettings.shared.isMusicEffectsOn ? 0 : 1
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose hint"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func getHint(_ sender: UIButton ) {

        switch sender.tag {
        case 0:
            
            self.dismiss(animated: true) {
                guard let delegate = self.delegate as? GameViewController else {
                    return
                }
                delegate.openLetter()
            }
            
        case 1:
            self.dismiss(animated: true) {
                guard let delegate = self.delegate as? GameViewController else {
                    return
                }
                delegate.openAnswer()
            }
        default:
            break
        }
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func soundButtonTapped() {
        currentImsageStringIndex = 1 - currentImsageStringIndex
        soundButton.setImage(UIImage(named: soundImagesString[currentImsageStringIndex]), for: .normal)
        GameSettings.shared.isMusicEffectsOn = !GameSettings.shared.isMusicEffectsOn
        GameSettings.shared.saveSettings()
//        guard let delegate = self.delegate as? GameViewController else {
//            return
//        }
//        if GameSettings.shared.isMusicOn == false {
//            delegate.stopMusic()
//        }
//        else {
//            delegate.playMusic()
//        }
    }
    
    var soundButton: UIButton! {
        
        didSet {
            soundButton.backgroundColor = .clear
            soundButton.setImage(UIImage(named: soundImagesString[currentImsageStringIndex]), for: .normal)
            soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
            
            soundButton.translatesAutoresizingMaskIntoConstraints = false
            soundButton.showsTouchWhenHighlighted = true
        }
    }
    
    
    var firstHintButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open letter - 50 coins", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .highlighted)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(getHint(_:)), for: .touchUpInside)
        return button
    }()
    
    var secondHintButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Answer - 100 coins", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .highlighted)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(getHint(_:)), for: .touchUpInside)
        return button
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Contact us: vsdev_feedback@mail.ru"
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.textColor = .white
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .highlighted)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.purple.cgColor ]
        }
    }

    var alertView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.5
        return view
    }()
    

    override func viewDidLayoutSubviews() {

        gradientLayer.frame = CGRect(x: self.alertView.bounds.origin.x , y: self.alertView.bounds.origin.y , width: self.alertView.bounds.size.width , height: self.alertView.bounds.size.height )
        gradientLayer.cornerRadius = 20
        
    }
    
    var delegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(alertView)

        self.gradientLayer = CAGradientLayer()
        alertView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.soundButton = UIButton()
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
       
        configureInterface()
    }

    
}

//Constraints
extension AlertViewController {
    
    func configureInterface() {
        
        alertView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        alertView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        alertView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        
        self.alertView.addSubview(headerLabel)
        self.alertView.addSubview(firstHintButton)
        self.alertView.addSubview(secondHintButton)
        self.alertView.addSubview(cancelButton)
        self.alertView.addSubview(soundButton)
        self.alertView.addSubview(emailLabel)
        
        headerLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20).isActive = true
        
        firstHintButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 50).isActive = true
        firstHintButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20).isActive = true
        firstHintButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20).isActive = true
        firstHintButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        secondHintButton.topAnchor.constraint(equalTo: firstHintButton.bottomAnchor, constant: 20).isActive = true
        secondHintButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20).isActive = true
        secondHintButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20).isActive = true
        secondHintButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: secondHintButton.bottomAnchor, constant: 20).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        
        soundButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        soundButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        soundButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        soundButton.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor).isActive = true
    }
}
