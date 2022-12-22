//
//  BluetoothManager.swift
//  InfoRelay
//
//  Created by Pyay San on 9/3/22.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    private var centralManager: CBCentralManager!
    @Published private(set) var discoveredPeripherals = [CBPeripheral]()
    @Published var isConnected: Bool = false
    var data: String = ""
    private var connectedDevice: CBPeripheral!
    private var deviceServiceCBUUID = CBUUID(string: "FFE0")
    private var deviceCharacteristic: CBCharacteristic!
    private var deviceCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    var mqtt: MQTTManager!
    
    init(getMQTT: MQTTManager){
        mqtt = getMQTT
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    //MARK: - Central manager delegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                print("central.state is poweredOn")
                startScan()
            case .resetting:
                print("central.state is resetting")
            case .unsupported:
                print("central.state is unsupported")
            case .unauthorized:
                print("central.state is unauthorized")
            case .poweredOff:
                print("central.state is poweredOff")
            case .unknown:
                print("central.state is unknown")
            
        default:
            print("Unknown state is provided.")
        }
    }
    
    func startScan() {
        centralManager.scanForPeripherals(withServices: [deviceServiceCBUUID], options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral){
            self.discoveredPeripherals.append(peripheral)
        }
        
    }
    
    func connect(peripheral: CBPeripheral){
        if connectedDevice != nil {
            centralManager.cancelPeripheralConnection(connectedDevice)
        }
        
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        if connectedDevice != nil {
            centralManager.cancelPeripheralConnection(connectedDevice)
        }
        isConnected = false
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedDevice = peripheral
        connectedDevice.delegate = self
        isConnected = true
        print("connected!")
        peripheral.discoverServices([deviceServiceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error{
            isConnected = false
            print("Could not connect!")
            print(error)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error{
            print(error)
            return
        }
        isConnected = false
        print("Sucessfully disconnected!")
    }
    
    //MARK: - Peripheral delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services?.first(where: {$0.uuid == deviceServiceCBUUID}){
            peripheral.discoverCharacteristics([deviceCharacteristicCBUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                deviceCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        var characteristicASCIIValue = NSString()

        guard characteristic == deviceCharacteristic,

        let characteristicValue = characteristic.value,
        let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

        characteristicASCIIValue = ASCIIstring
        data = characteristicASCIIValue as String
        let finalMessage = "Original sends: \(data)"

        mqtt.publish(with: finalMessage)
        print("Received from Bluetooth: \((data))")

    }
    
    func sendMessage(messageToSend: String){
        connectedDevice?.writeValue(messageToSend.data(using: .utf8) ?? Data(), for: deviceCharacteristic, type: .withoutResponse)
        print(messageToSend)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print(error)
            return
        }
    }
    
    func readMessage(characteristic: CBCharacteristic){
        connectedDevice?.readValue(for: characteristic)
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        if let error = error {
//            print(error)
//            return
//        }
//
//    }
    
//    func readMessage()
//    func sendStruct(messageToSend: MessageStruct){
//        let packet = withUnsafeBytes(of: messageToSend) { Data($0) }
//        if connectedDevice != nil{
//            connectedDevice.writeValue(packet, for: deviceCharacteristic, type: .withoutResponse)
//        }
//    }
}
