//
//  WinViewController.swift
//  GuessFootballPlayer
//
//  Created by Виталий Субботин on 30/07/2019.
//  Copyright © 2019 Виталий Субботин. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
    
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WinViewController did load")
    }
    

}
