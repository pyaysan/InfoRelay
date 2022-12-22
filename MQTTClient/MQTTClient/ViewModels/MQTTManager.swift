//
//  MQTTController.swift
//  MQTTClient
//
//  Created by Pyay San on 11/14/22.
//

import Foundation
import CocoaMQTT
import Combine

class MQTTManager: ObservableObject, CocoaMQTTDelegate {

    
    private var mqttManager: CocoaMQTT?
    private var id: String!
    private var host: String!
    private var topic: String!
    private var username: String?
    private var password: String?
    
    @Published var currentAppState: MQTTAppState = MQTTAppState()
    
    private var anyCancellable: AnyCancellable? = nil
        
    init() {
        anyCancellable = currentAppState.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    
    func initialize(host: String, id: String, username: String? = nil, password: String? = nil){
        // Clears any existing connection
        if mqttManager != nil {
            mqttManager = nil
        }
        
        self.id = id
        self.host = host
        self.username = username
        self.password = password
        let clientID = "CocoaMQTT-\(id)-" + String(ProcessInfo().processIdentifier)
        
        mqttManager = CocoaMQTT(clientID: clientID, host: self.host, port: 1883)
        // username and password has values and not nil
        if let hasUsername = self.username, let hasPassword = self.password {
            mqttManager?.username = hasUsername
            mqttManager?.password = hasPassword
        }
        
        mqttManager?.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqttManager?.keepAlive = 60
        mqttManager?.delegate = self
    }
    
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            currentAppState.setConnectionState(state: .isConnected)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
        print("here")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
        
        currentAppState.receivedMessage(msg: message.string.description)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        TRACE("subscribed: \(success), failed: \(failed)")
        
        currentAppState.setConnectionState(state: .connectedSubscribed)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        TRACE("topic: \(topics)")
        
        currentAppState.setConnectionState(state: .connectedUnsubscribed)
        currentAppState.clearData()
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.description)")
        
        currentAppState.setConnectionState(state: .isDisconnected)
    }
    
    // MARK: User Intent
    func connect() {
        if mqttManager?.connect() == true {
            currentAppState.setConnectionState(state: .connecting)
        } else {
            currentAppState.setConnectionState(state: .isDisconnected)
        }
    }
    
    func subscribe(topic: String) {
        self.topic = topic
        mqttManager?.subscribe(topic, qos: .qos1)
    }
    
    func publish(message: String) {
        mqttManager?.publish(topic, withString: message, qos: .qos1)
    }
    
    func disconnect() {
        mqttManager?.disconnect()
    }
    
    func unsubscribeFromTopic() {
        mqttManager?.unsubscribe(topic)
    }
    
    func getHost() -> String? {
        return host
    }
    
    func isSubscribed() -> Bool {
        return currentAppState.appState.isSubscribed
    }
    
    func isConnected() -> Bool {
        return currentAppState.appState.isConnected
    }
    
    func connectionStateDescription() -> String {
        return currentAppState.appState.description
    }
}

extension MQTTManager {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 2 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconnect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
}

extension Optional {
    // Unwrap optional value for printing log only
    var description: String {
        if let self = self {
            return "\(self)"
        }
        return ""
    }
}
