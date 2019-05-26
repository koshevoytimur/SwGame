//
//  MainMenuViewController.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var _playGameButton: UIButton!
    @IBOutlet weak var _topScoresButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOutlets()
        // Do any additional setup after loading the view.
    }
    
    // Save authorize state.
    func saveLoggedState() {
        let def = UserDefaults.standard
        def.set(false, forKey: "isLoggedIn")
        def.set("", forKey: "currentUser")
        def.synchronize()
    }
    
    @IBAction func playGameAction(_ sender: Any) {
    }
    
    @IBAction func topScoresAction(_ sender: Any) {
        performSegue(withIdentifier: "menu_to_topScores", sender: self)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        saveLoggedState()
        performSegue(withIdentifier: "menu_to_login", sender: self)
    }
    
    
    func setUpOutlets() {
        _playGameButton.layer.cornerRadius = 5
        _playGameButton.layer.borderWidth = 0.5
        _playGameButton.layer.borderColor = UIColor.gray.cgColor
        
        _topScoresButton.layer.cornerRadius = 5
        _topScoresButton.layer.borderWidth = 0.5
        _topScoresButton.layer.borderColor = UIColor.gray.cgColor
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
