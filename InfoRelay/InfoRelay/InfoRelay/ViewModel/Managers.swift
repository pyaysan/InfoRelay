//
//  Managers.swift
//  InfoRelay
//
//  Created by Pyay San on 11/16/22.
//

import Foundation
import Combine

class Managers: ObservableObject {
    @Published var mqtt = MQTTManager.shared()
    @Published var bt: BluetoothManager!
    
    private var anyCancellable1: AnyCancellable?
    private var anyCancellable2: AnyCancellable?
    
    init() {
        bt = BluetoothManager(getMQTT: mqtt)
        
        anyCancellable1 = bt.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        
        anyCancellable2 = mqtt.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
