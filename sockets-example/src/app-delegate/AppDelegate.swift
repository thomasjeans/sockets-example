//
//  AppDelegate.swift
//  sockets-example
//
//  Created by Thomas Jeans on 3/31/19.
//  Copyright © 2019 Thomas Jeans. All rights reserved.
//

import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}

let sessionID = UUID().uuidString

struct Character {
    let name: String
    let sprites: (UIImage, UIImage)
}

let characters = [Character(name: "Dark Knight Cecil", sprites: (#imageLiteral(resourceName: "dark knight cecil-menu"), #imageLiteral(resourceName: "dark knight cecil-battle"))),
                  Character(name: "Paladin Cecil", sprites: (#imageLiteral(resourceName: "paladin cecil-menu"), #imageLiteral(resourceName: "paladin cecil-battle"))),
                  Character(name: "Rydia", sprites: (#imageLiteral(resourceName: "rydia-menu"), #imageLiteral(resourceName: "rydia-battle"))),
                  Character(name: "Kain", sprites: (#imageLiteral(resourceName: "kain-menu"), #imageLiteral(resourceName: "kain-battle"))),
                  Character(name: "Tellah", sprites: (#imageLiteral(resourceName: "tellah-menu"), #imageLiteral(resourceName: "tellah-battle"))),
                  Character(name: "Edward", sprites: (#imageLiteral(resourceName: "edward-menu"), #imageLiteral(resourceName: "edward-battle"))),
                  Character(name: "Rosa", sprites: (#imageLiteral(resourceName: "rosa-menu"), #imageLiteral(resourceName: "rosa-battle"))),
                  Character(name: "Cid", sprites: (#imageLiteral(resourceName: "cid-menu"), #imageLiteral(resourceName: "cid-battle"))),
                  Character(name: "Yang", sprites: (#imageLiteral(resourceName: "yang-menu"), #imageLiteral(resourceName: "yang-battle"))),
                  Character(name: "Edge", sprites: (#imageLiteral(resourceName: "edge-menu"), #imageLiteral(resourceName: "edge-battle"))),
                  Character(name: "FuSoYa", sprites: (#imageLiteral(resourceName: "fusoya-menu"), #imageLiteral(resourceName: "fusoya-battle")))]

// ReSwift

struct AppState: StateType {
    var selectedCharacterIndex: Int = 0
    var connected: Bool = false
}

struct IncrementCharacter: Action { }
struct DecrementCharacter: Action { }
struct DidConnect: Action { }
struct DidDisconnect: Action { }

func appStateReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState(selectedCharacterIndex: 0, connected: false)
    
    switch action {
    case _ as DecrementCharacter:
        if state.selectedCharacterIndex > 0 {
            state.selectedCharacterIndex -= 1
        }
    case _ as IncrementCharacter:
        if state.selectedCharacterIndex < characters.count - 1 {
            state.selectedCharacterIndex += 1
        }
    case _ as DidConnect:
        state.connected = true
    case _ as DidDisconnect:
        state.connected = false
    default:
        break
    }
    
    return state
}

let store = Store(
    reducer: appStateReducer,
    state: AppState(),
    middleware: [])
