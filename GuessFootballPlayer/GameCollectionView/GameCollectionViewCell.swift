//
//  GameCollectionViewCell.swift
//  TryToGuess
//
//  Created by Виталий Субботин on 10/03/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "Cell"
    
    func setColor() {
        self.letterLabel.textColor = .green
    }
    
    var letterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "MarkerFelt-Thin", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setLabelFontSize(withSize size: Int) {
        letterLabel.font = UIFont(name: "MarkerFelt-Thin", size: CGFloat(size))
    }
    
    override func layoutSubviews() {

        self.layer.cornerRadius = 5
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(letterLabel)
        
        letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        letterLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        letterLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
    }
    
    func changeColor(_ needToChange:Bool) {
        if needToChange {
            UIView.animate(withDuration: 1) {
                self.backgroundColor = .green
            }
            UIView.animate(withDuration: 1) {
                self.backgroundColor = .white
            }
        }
        else {
            self.backgroundColor = .white
        }
    }
    
    func wrongColor() {
        UIView.animate(withDuration: 1) {
            self.backgroundColor = .red
        }
        UIView.animate(withDuration: 1) {
            self.backgroundColor = .white
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
