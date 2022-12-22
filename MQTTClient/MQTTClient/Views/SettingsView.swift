//
//  SettingsView.swift
//  MQTTClient
//
//  Created by Pyay San on 11/13/22.
//

import SwiftUI

struct SettingsView: View {
    @State var brokerAddress: String = ""
    @ObservedObject var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateDescription(), isConnected: mqttManager.isConnected())
            MQTTTextField(placeHolderMessage: "Enter broker Address", isDisabled: mqttManager.currentAppState.appState != .isDisconnected, message: $brokerAddress)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
                Text("Connect")
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appState != .isDisconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Disconnect")
        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .red))
        .disabled(mqttManager.currentAppState.appState == .isDisconnected)
    }
    private func configureAndConnect() {
        // Initialize the MQTT Manager
        mqttManager.initialize(host: brokerAddress, id: UUID().uuidString)
        // Connect
        mqttManager.connect()
    }

    private func disconnect() {
        mqttManager.disconnect()
    }
}
