//
//  ChatViewController.swift
//  sockets-example
//
//  Created by Thomas Jeans on 3/31/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import UIKit
import AloeStackView
import ReSwift
import SocketIO

class ChatViewController: UIViewController, StoreSubscriber {

    var socketManager: SocketManager?
    var selectedCharacter: Character?
    let stackView = AloeStackView()
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var connectionStatusImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        prepareSocket(using: .socketIO)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    fileprivate func prepareViews() {
        prepareStackView()
        
        textField.textColor = .white
        textField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func prepareStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.hidesSeparatorsByDefault = true
        view.addSubview(stackView)
        
        let margins = view.layoutMarginsGuide
        
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 30.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10.0).isActive = true
    }
    
    fileprivate func prepareSocket(using client: SocketClient) {
        switch client {
        case .socketIO:
            let ip: String = overrideIP != nil ? overrideIP! : Constants().localIP
            
            print("Chat Server IP: \(ip)")
            
            socketManager = SocketManager(socketURL: URL(string: "http://\(ip):\(Constants().port)/")!, config: [.log(true), .compress])
            
            if let socketManager = socketManager {
                prepareSocketIO(with: socketManager)
            }
            
        case .starscream, .urlSession, .network:
            // TODO: -
            return
        }
    }
    
    func newState(state: AppState) {
        connectionStatusLabel.text = state.connected ? "CONNECTED" : "NOT CONNECTED"
        connectionStatusLabel.alpha = state.connected ? 1.0 : 0.5
        connectionStatusImage.image = state.connected ? #imageLiteral(resourceName: "mog-connected") : #imageLiteral(resourceName: "mog-not-connected")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            textFieldBottomConstraint.constant = keyboardFrame.cgRectValue.height + 20.0
            buttonBottomConstraint.constant = keyboardFrame.cgRectValue.height + 20.0
        }
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        if textField.text != "" {
            emit(string: textField.text!)
            textField.text = ""
        }
    }
}

// MARK: - SocketIO

extension ChatViewController {
    
    fileprivate func prepareSocketIO(with manager: SocketManager) {
        let socket = manager.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            store.dispatch(DidConnect())
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
            store.dispatch(DidDisconnect())
        }
        
        socket.on(clientEvent: .statusChange) {data, ack in
            if socket.status == .connected {
                store.dispatch(DidConnect())
            } else {
                store.dispatch(DidDisconnect())
            }
        }
        
        socket.on("chat message") {data, ack in
            
            guard let socketDict = data[0] as? NSDictionary else {
                return
            }
            
            let socketMessage = socketDict["message"] as! String
            let socketSessionID = socketDict["sessionID"] as! String
            let characterName = socketDict["characterName"] as! String
            
            let isMyMessage = socketSessionID == sessionID
                        
            let chatMessageView = ChatMessageView(frame: .zero, image: UIImage(named: "\(characterName.lowercased())-battle")!, message: socketMessage, isMyMessage: isMyMessage)

            self.stackView.addRow(chatMessageView)
            
            if self.stackView.getAllRows().count > 6 {
                self.stackView.removeRow(self.stackView.getAllRows()[0])
            }

            chatMessageView.translatesAutoresizingMaskIntoConstraints = false
            chatMessageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        }
    }
    
    func emit(string: String) {
        if let socketManager = socketManager {
            let socket = socketManager.defaultSocket
            let chatMessage = ChatMessage(sessionID: sessionID, message: string, characterName: characters[store.state.selectedCharacterIndex].name)
            socket.emit("chat message", chatMessage)
        }
    }
}

struct ChatMessage: SocketData, Codable {
    let sessionID: String
    let message: String
    let characterName: String

    func socketRepresentation() -> SocketData {
        return ["sessionID": sessionID, "message": message, "characterName": characterName]
    }
}
