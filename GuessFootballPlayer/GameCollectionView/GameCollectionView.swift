//
//  GameCollectionView.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 10/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit

class GameCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var letters = [String]()
    
    private var senders = [UIButton?]()
    private let layout = UICollectionViewFlowLayout()
    
    init() {
        
        layout.minimumInteritemSpacing = 10
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        
        register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.reuseID)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAnswer(withLetter letter: String, fromSender sender: UIButton) {
        if Game.numberOfLetters() >= letters.count {
            
            guard let ind = letters.firstIndex(of: "") else {
                letters.append(letter)
                senders.append(sender)
                let indOfSpace = Game.getIndexOfSpace()
                if indOfSpace > 0, letters.count == indOfSpace {
                    print("ok")
                    letters.append("_")
                    senders.append(nil)
                }
                self.reloadData()
                return
            }
            letters[ind] = letter
            senders[ind] = sender
            self.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        let cell = dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.reuseID, for: indexPath) as! GameCollectionViewCell

        if indexPath.row >= senders.count {
            return
        }
        
        if senders[indexPath.row] != nil {
            cell.letterLabel.text = " "
            letters[indexPath.row] = ""
            senders[indexPath.row]?.isHidden = false
        }
        
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.numberOfLetters()
    }
    
    func answerIsWrong() -> Bool {
        if letters.count == Game.numberOfLetters() {
            for letter in letters {
                if letter == "" {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    var needToChangeColor: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.reuseID, for: indexPath) as! GameCollectionViewCell
        
        if answerIsWrong(), needToChangeColor == false {
            cell.wrongColor()
            
        }
        else {
            cell.changeColor(needToChangeColor)
        }
        
        if letters.count > indexPath.row {
            cell.letterLabel.text = letters[indexPath.row]
            if senders[indexPath.row] == nil, letters[indexPath.row] != "" {
                cell.backgroundColor = .green
            }
        }
        else {
            cell.letterLabel.text = " "
            
        }
        
        switch Game.numberOfLetters() {
        case 13...14:
            cell.setLabelFontSize(withSize: 13)
        case 10...12:
            cell.setLabelFontSize(withSize: 19)
        case 8...9:
            cell.setLabelFontSize(withSize: 22)
        default:
            cell.setLabelFontSize(withSize: 30)
            break
        }
        
        
        if indexPath.row == Game.getIndexOfSpace() {
            cell.alpha = 0
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let a: CGFloat = Game.numberOfLetters() <= 8  ?  1 : 8 / CGFloat(Game.numberOfLetters())
        layout.sectionInset.top = (self.bounds.height - 50 * a) / 2
        return CGSize(width: (self.bounds.width - 10 * (CGFloat(Game.numberOfLetters()) - 1)) / CGFloat(Game.numberOfLetters()), height: 50 * a )
    }
    

    func resetArrays() {
        letters = []
        senders = []
    }
    
    func getAnswer() -> [String] {
        return letters
    }
    
    func open(letter: String, withIndex ind: Int, sender: UIButton) {
        if senders.count > 0 {
            for i in 0..<senders.count {
                
                if senders[i]?.titleLabel?.text == letter {
                    letters[i] = ""
                    senders[i]?.isHidden = false
                    senders.remove(at: i)
                    senders.insert(nil, at: i)
                    break
                }

            }
        }
        
        if letters.count <= ind {
            letters.append(letter)
            senders.append(nil)
        }
      
        if letters[ind] == "" {
            letters[ind] = letter
        }
        
        if letters[ind] != letter, letters[ind] != "" {
            letters[ind] = letter
            senders[ind]?.isHidden = false
            sender.isHidden = true
        }
        sender.isHidden = true
        senders[ind] = nil
        
        reloadData()
    }
    
}
