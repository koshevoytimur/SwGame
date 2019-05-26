//
//  AlertView.swift
//  SwGame
//
//  Created by Тимур Кошевой on 5/26/19.
//  Copyright © 2019 Faris Sbahi. All rights reserved.
//

import UIKit

class AlertView: NSObject {
    
    func showAlert(view: UIViewController , title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
}
