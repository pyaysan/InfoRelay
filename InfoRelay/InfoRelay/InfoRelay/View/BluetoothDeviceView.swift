//
//  BluetoothDeviceView.swift
//  InfoRelay
//
//  Created by Pyay San on 11/11/22.
//

import SwiftUI

struct BluetoothDeviceView: View {
    //@ObservedObject var manager.bt: BluetoothManager
    @ObservedObject var manager: Managers
    @State private var toggle = false
    
    var body: some View {
        NavigationView{
                   List(manager.bt.discoveredPeripherals, id: \.self){ peripheral in
                       HStack {
                           Text(peripheral.name ?? "unknown name")
                           
                           Spacer()
                           
                           Image(systemName: "checkmark")
                               .foregroundColor(.white)
                               .opacity(manager.bt.isConnected ? 1 : 0)
                               
                       }
                       .onTapGesture {
                           manager.bt.connect(peripheral: peripheral)
   
                       }
                   }
                   .navigationTitle("Peripherals")
               }
        HStack {
            Button("Disconnect", action: {
                manager.bt.disconnect()
            })
            
            Spacer()
            
            Toggle("", isOn: $toggle)
                .onChange(of: toggle){ value in
                    print(value)
                    if value == false{
                        manager.bt.sendMessage(messageToSend: "0")
                    }
                    else if value == true{
                        manager.bt.sendMessage(messageToSend: "1")
                    }
    
                }
        }
        .padding()
    }
}

//struct BluetoothDeviceView_Previews: PreviewProvider {
//    static var previews: some View {
//        let BTDevice = BluetoothManager()
//        BluetoothDeviceView(bluetoothManager: $BTDevice)
//    }
//}
