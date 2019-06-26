//
//  CharacterSelectViewController.swift
//  sockets-example
//
//  Created by Thomas Jeans on 4/29/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import UIKit
import ReSwift

class CharacterSelectViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var characterStackView: UIStackView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        
        backButton.isEnabled = state.selectedCharacterIndex != 0
        forwardButton.isEnabled = state.selectedCharacterIndex != characters.count - 1
        
        characterImageView.image = characters[state.selectedCharacterIndex].sprites.0
        characterLabel.text = characters[state.selectedCharacterIndex].name
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        store.dispatch(DecrementCharacter())
    }
    
    @IBAction func forwardButtonTouched(_ sender: Any) {
        store.dispatch(IncrementCharacter())
    }
}
