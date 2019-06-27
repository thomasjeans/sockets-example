//
//  HomeViewController.swift
//  sockets-example
//
//  Created by Thomas Jeans on 4/29/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Chat Server IP", message: "Enter the IP address of the socket server", preferredStyle: .alert)
        
        alert.addTextField()
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let textFields = alert.textFields else { return }
            
            if textFields[0].text != "" {
                overrideIP = textFields[0].text
            }
        }
        
        alert.addAction(doneAction)
        
        present(alert, animated: true)
    }
}
