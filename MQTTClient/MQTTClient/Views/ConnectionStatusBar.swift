//
//  ConnectionStatusBar.swift
//  MQTTClient
//
//  Created by Pyay San on 11/13/22.
//

import SwiftUI

struct ConnectionStatusBar: View {
    var message: String
    var isConnected: Bool
    var body: some View {
        HStack {
            Text(message)
                .font(.footnote)
                .foregroundColor(.white)
        }.frame(maxWidth: .infinity)
        .background(isConnected ? Color.green : Color.red)
        
    }
}

struct ConnectionStatusBar_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusBar(message: "Hello", isConnected: true)
    }
}
