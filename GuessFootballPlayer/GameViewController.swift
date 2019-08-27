//
//  ViewController.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 10/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController  {
    
    private var buttons = [UIButton]()
    
    var audioPlayer = AVAudioPlayer()

    var backgroundAudioPlayer: AVAudioPlayer?

    lazy var coins: Int = Game.getNumberOfCoins()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var coinsLabel: UILabel! {
        didSet {
            coinsLabel.layer.shadowOffset = CGSize(width: 5, height: 5)
            coinsLabel.layer.shadowColor = UIColor.black.cgColor
            coinsLabel.layer.shadowOpacity = 0.5
            coinsLabel.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var levelLabel: UILabel! {
        didSet {
            levelLabel.layer.shadowOffset = CGSize(width: 5, height: 5)
            levelLabel.layer.shadowColor = UIColor.black.cgColor
            levelLabel.layer.shadowOpacity = 0.5
            levelLabel.layer.shadowRadius = 5
        }
    }
    

    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor ,UIColor.yellow.cgColor]
        }
    }
    
    private var gameCollectionView = GameCollectionView()
    
    private func resetButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        for button in removedButtons {
            button.removeFromSuperview()
        }
        self.removedButtons.removeAll()
        self.buttons.removeAll()
        self.setButtons()
    }
    
    private func checkAnswer() {
        let questionNumber = Game.getQuestionNumber()
        let answer: [String] = gameCollectionView.getAnswer()
        let answerIsTrue = Game.checkAnswer(answer: answer)
        
        self.gameCollectionView.reloadData()
        
        if answerIsTrue {
            playMusicEffect(withName: "correctAnswer")
            
            gameCollectionView.isUserInteractionEnabled = false
            
            gameCollectionView.needToChangeColor = true
            gameCollectionView.reloadData()
            
            
            if questionNumber == 99 {
                self.performSegue(withIdentifier: "win", sender: self)
                
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                
                
                
                self.step = -1
                self.resetButtons()
               
                self.imageView.image = Game.getImage()
                
                self.gameCollectionView.resetArrays()
                
                self.gameCollectionView.needToChangeColor = false
                
                self.gameCollectionView.reloadData()
                
                self.updateTitle()
                
                self.gameCollectionView.isUserInteractionEnabled = true
                
            }
        }
    }
    
    
    
    private func playMusicEffect(withName name: String) {
        
        guard GameSettings.shared.isMusicEffectsOn else {
            return
        }
        
        let musicEffectURL = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: musicEffectURL)
        }
        catch {
            print(error.localizedDescription)
        }
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
    }
    
    @objc func clicked(_ sender: UIButton) {
        
        playMusicEffect(withName: "buttonClick")
        
        guard gameCollectionView.getAnswer().contains("") || gameCollectionView.getAnswer().count < Game.numberOfLetters() else {
            return
        }
        
        sender.isHidden = true
        
        gameCollectionView.updateAnswer(withLetter: sender.titleLabel?.text ?? " ", fromSender: sender)
        
        checkAnswer()
   
    }
    
    @objc func hintButtonTapped(_ sender: UIButton) {

        let alert = AlertViewController()
        alert.delegate = self

        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
        
        

    }
    
    private func configureImage() {
        imageView.backgroundColor = .blue
        if let image = Game.getImage() {
            imageView.image = image
        }
        
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func stopMusic() {
        if backgroundAudioPlayer!.isPlaying {
            backgroundAudioPlayer!.setVolume(0, fadeDuration: 0)
        }
    }
    
//    func playMusic() {
//
//        guard GameSettings.shared.isMusicOn else {
//            print(GameSettings.shared.isMusicOn)
//            return
//        }
//
//        if backgroundAudioPlayer != nil, backgroundAudioPlayer!.isPlaying {
//            backgroundAudioPlayer!.setVolume(0.5, fadeDuration: 0)
//            return
//        }
//
//
//        let musicUrl = URL.init(fileURLWithPath: Bundle.main.path(forResource: "korni", ofType: "mp3")!)
//        do {
//            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: musicUrl)
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//        backgroundAudioPlayer!.prepareToPlay()
//        backgroundAudioPlayer!.setVolume(0.5, fadeDuration: 0)
//        backgroundAudioPlayer!.play()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error.localizedDescription)
        }
        
//        playMusic()
        
        gradientLayer = CAGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        Game.loadGame()
        
        configureImage()

        view.addSubview(gameCollectionView)
        
        setConstraints()
        
        setButtons()
        
        configureHintButton()
        
        setTitle()
    }

    private func setConstraints() {
        
        gameCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        gameCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        gameCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        gameCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    private func setTitle() {
        levelLabel.text = "Level \(Game.getQuestionNumber() + 1)"
        coinsLabel.text = "\(self.coins)"
    }
    
    func updateTitle() {
   
        levelLabel.text = "Level \(Game.getQuestionNumber() + 1)"
        
        func animateLabel() {
            UIView.animate(withDuration: 0.15, animations: {
                self.coinsLabel.alpha = 0
                self.coins += 2
                self.coinsLabel.text = "\(self.coins)"
                self.coinsLabel.alpha = 1
                
            })
            
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (timer) in
            animateLabel()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            timer.invalidate()
        }
    }
    
    private var removedButtons: [UIButton] = []
    private var step = -1
    func openLetter() {
        
        if Game.getNumberOfCoins() < 50 {
            return
        }
        
        self.coins = Game.getNumberOfCoins()
        self.coinsLabel.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.coinsLabel.alpha = 1
        }
        self.coinsLabel.text = "\(self.coins)"
        
        step += 1
        
        guard let letter = Game.openLetter(withIndex: step) else {
            return
        }

        
        for (index, button) in buttons.enumerated() {
            if button.titleLabel?.text == letter {
                
                gameCollectionView.open(letter: letter, withIndex: step, sender: button)
                
                let removedButton = buttons.remove(at: index)
                removedButtons.append(removedButton)
                break
            }
        }
        
        checkAnswer()
    }
    
    func openAnswer() {
        
        if Game.getNumberOfCoins() < 100 {
            return
        }
        
        let answer = Game.openAnswer()
        
        self.coins = Game.getNumberOfCoins()
        self.coinsLabel.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.coinsLabel.alpha = 1
        }
        self.coinsLabel.text = "\(self.coins)"
        
        gameCollectionView.resetArrays()
        for letter in answer {
            if letter != "_" {
                gameCollectionView.updateAnswer(withLetter: letter, fromSender: UIButton())
            }
        }
        checkAnswer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}


// Configure all buttons
extension GameViewController {
    
    private func setButtons() {
        
        let buttonWidth: CGFloat = (view.frame.width - 40 - 30) / 7
        
        for i in 0...13 {
            let button = UIButton()
            button.backgroundColor = .yellow
            button.tag = i
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            switch i {
            case 0:
                button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true //-110
                
            case 1...6:
                button.leadingAnchor.constraint(equalTo: buttons[i-1].trailingAnchor, constant: 5).isActive = true
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true //-110
                
            case 7:
                button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true //-30
                
            case 8...13:
                button.leadingAnchor.constraint(equalTo: buttons[i-1].trailingAnchor, constant: 5).isActive = true
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50 ).isActive = true  //-30
                
            default:
                break
            }
            buttons.append(button)
        }
        
        buttons[6].trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        buttons[13].trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        setButtonsTitles()
    }
    
    private func setButtonsTitles() {
        
        guard var letters = Game.getLetters() else {
            return
        }
        
        letters.shuffle()
        
        for (index, button) in buttons.enumerated() {
            
            button.setTitle(letters[index], for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            button.isHidden = false
            
            button.layer.cornerRadius = 5
            
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            
            button.layer.shadowOffset = CGSize(width: 5, height: 5)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            
        }
        
    }
    
    private func configureHintButton() {
        
        let hintButton = UIButton()
        hintButton.backgroundColor = #colorLiteral(red: 1, green: 0.3126964867, blue: 0.01739151776, alpha: 1)
        hintButton.layer.borderColor = UIColor.black.cgColor
        hintButton.layer.borderWidth = 2
        hintButton.layer.cornerRadius = 5
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintButton)
        hintButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        hintButton.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor).isActive = true
        hintButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        hintButton.trailingAnchor.constraint(equalTo: levelLabel.leadingAnchor, constant: -50).isActive = true
        hintButton.setTitle("?", for: .normal)
        hintButton.addTarget(self, action: #selector(hintButtonTapped(_:)), for: .touchUpInside)
    }
}



