//
//  ContentView.swift
//  MQTTClient
//
//  Created by Pyay San on 11/13/22.
//

import SwiftUI

//struct MessagesView: View {
//    // TODO: Remove singleton
//    @StateObject var mqttManager = MQTTManager.shared()
//    var body: some View {
//        NavigationView {
//            MessageView()
//        }
//        .environmentObject(mqttManager)
//    }
//}



struct MessageView: View {
    @State var topic: String = ""
    @State var message: String = ""
    @StateObject var mqttManager: MQTTManager = MQTTManager()
    var body: some View {
        NavigationView {
            VStack {
                ConnectionStatusBar(message: mqttManager.connectionStateDescription(), isConnected: mqttManager.isConnected())
                VStack {
                    HStack {
                        MQTTTextField(placeHolderMessage: "Enter a topic to subscribe", isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                        Button(action: functionFor(state: mqttManager.currentAppState.appState)) {
                            Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appState))
                                .font(.system(size: 14.0))
                        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                            .frame(width: 100)
                            .disabled(!mqttManager.isConnected() || topic.isEmpty)
                    }

                    HStack {
                        MQTTTextField(placeHolderMessage: "Enter a message", isDisabled: !mqttManager.isSubscribed(), message: $message)
                        Button(action: { send(message: message) }) {
                            Text("Send").font(.body)
                        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                            .frame(width: 80)
                            .disabled(!mqttManager.isSubscribed() || message.isEmpty)
                    }
                    MessageHistoryTextView(text: $mqttManager.currentAppState.historyMessage)
                        .frame(height: 150)
                }.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))

                Spacer()
            }
            .navigationTitle("Messages")
            .navigationBarItems(trailing: NavigationLink(
                destination: SettingsView(brokerAddress: mqttManager.getHost() ?? "", mqttManager: mqttManager),
                label: {
                    Image(systemName: "gear")
                }))

        }
    }

    private func subscribe(topic: String) {
        self.mqttManager.subscribe(topic: topic)
    }

    private func unsubscribe() {
        mqttManager.unsubscribeFromTopic()
    }

    private func send(message: String) {
        let finalMessage = "Client1 says: \(message)"
        self.mqttManager.publish(message: finalMessage)
        self.message = ""
    }

    private func titleForSubscribButtonFrom(state: MQTTConnectionState) -> String {
        switch state {
        case .isConnected, .connectedUnsubscribed, .isDisconnected, .connecting:
            return "Subscribe"
        case .connectedSubscribed:
            return "Unsubscribe"
        }
    }

    private func functionFor(state: MQTTConnectionState) -> () -> Void {
        switch state {
        case .isConnected, .connectedUnsubscribed, .isDisconnected, .connecting:
            return { subscribe(topic: topic) }
        case .connectedSubscribed:
            return { unsubscribe() }
        }
    }
}

