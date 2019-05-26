//
//  TopScoresViewController.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import RealmSwift

class TopScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "topScoresCell"
    let realm = try! Realm()

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView.delegate = self
        _tableView.dataSource = self
        
        setUpOutlets()
    }
    
    func setUpOutlets() {
        _backButton.layer.cornerRadius = 5
        _backButton.layer.borderWidth = 0.5
        _backButton.layer.borderColor = UIColor.gray.cgColor
        
        _tableView.layer.cornerRadius = 5
        _tableView.layer.borderWidth = 0.5
        _tableView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let topScoresResults = realm.objects(TopScores.self)
        
        return topScoresResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = _tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let topScoresResults = realm.objects(TopScores.self).sorted(byKeyPath: "score", ascending: false)
        
        cell.textLabel?.text = topScoresResults[indexPath.row].userName
        cell.detailTextLabel?.text = topScoresResults[indexPath.row].score
        
        return cell
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
    }
    

}
