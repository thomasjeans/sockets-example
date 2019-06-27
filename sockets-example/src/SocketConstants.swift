//
//  SocketConstants.swift
//  sockets-example
//
//  Created by Thomas Jeans on 4/13/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import Foundation

struct Constants {
    let localIP = "172.20.10.6"
    let localHost = "localhost"
    let port = 3000
}

enum SocketClient {
    case socketIO, starscream, urlSession, network
}
