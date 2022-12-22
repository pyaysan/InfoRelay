//
//  SideMenu.swift
//  InfoRelay
//
//  Created by Pyay San on 11/11/22.
//

import Foundation
import SwiftUI

enum MenuItems: Int, CaseIterable {
    case BTConnection
    case MQTT
    
    var title: String {
        switch self{
        case .BTConnection: return "Bluetooth Connection"
        case .MQTT: return "MQTT"
        }
    }
    
    var imageName: String {
        switch self {
        case .BTConnection: return "wave.3.forward"
        case .MQTT: return "message.and.waveform"
        }
    }
    
    var page: Page {
        switch self {
        case .BTConnection: return .BTConnection
        case .MQTT: return .MQTT
        }
    }

}

struct SideMenuItem: View {
    let item: MenuItems
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.imageName)
                .frame(width: 24, height: 24)
            
            Text(item.title)
                .font(.system(size: 15, weight: .semibold))
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
    }
}

struct SideMenu: View {
    @Binding var menuOpened: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black,Color.gray]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                ForEach(MenuItems.allCases, id: \.self) { item in
                    SideMenuItem(item: item)
                        .onTapGesture {
                            viewRouter.currentPage = item.page
                            menuOpened.toggle()
                        }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func checkDestination(){
        
    }
}
