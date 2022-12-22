//
//  MQTTState.swift
//  MQTTClient
//
//  Created by Pyay San on 11/15/22.
//

import Foundation

enum MQTTConnectionState {
    case connecting
    case isConnected
    case isDisconnected
    case connectedSubscribed
    case connectedUnsubscribed
    
    var description: String {
        switch self {
        case .connecting:
            return "Trying to connect"
        case .isConnected:
            return "Connected"
        case .isDisconnected:
            return "Disconnected"
        case .connectedSubscribed:
            return "Connected; subscribed to topic(s)"
        case .connectedUnsubscribed:
            return "Connected; unsubscribed to topic"
        }
    }
    
    var isConnected: Bool {
        switch self {
        case .isConnected, .connectedSubscribed, .connectedUnsubscribed:
            return true
        case .isDisconnected, .connecting:
            return false
        }
    }
    
    var isSubscribed: Bool {
        switch self {
        case .connectedSubscribed:
            return true
        case .isConnected, .isDisconnected, .connectedUnsubscribed, .connecting:
            return false
        }
    }
}


class MQTTAppState:ObservableObject {
    @Published var appState: MQTTConnectionState = .isDisconnected
    @Published var historyMessage: String = ""
    private var receivedMessage: String!
    
    func receivedMessage(msg: String) {
        receivedMessage = msg
        historyMessage = historyMessage + "\n" + receivedMessage
    }
    
    func clearData() {
        receivedMessage = ""
        historyMessage = ""
    }
    
    func setConnectionState(state: MQTTConnectionState) {
        appState = state
    }
}
