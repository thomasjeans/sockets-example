//
//  ChatMessageView.swift
//  sockets-example
//
//  Created by Thomas Jeans on 5/4/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import UIKit

class ChatMessageView: UIView {

    var icon: UIImageView?
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepare()
    }
    
    init(frame: CGRect, image: UIImage, message: String, isMyMessage: Bool = true) {
        super.init(frame: frame)
        
        icon = UIImageView()
        label = UILabel()
        
        if let icon = icon,
           let label = label {
            
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.image = image
            icon.contentMode = .scaleAspectFit
            addSubview(icon)
            
            if isMyMessage {
                icon.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                icon.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
                        
            icon.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = message
            
            label.textColor = isMyMessage ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            label.textAlignment = isMyMessage ? .left : .right
            label.font = UIFont(name: "ARCADECLASSIC", size: 20.0)
            
            addSubview(label)
            
            if isMyMessage {
                label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5.0).isActive = true
            } else {
                label.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -5.0).isActive = true
            }
            
            label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        }
    }
    
    fileprivate func prepare() {
        
    }
}
