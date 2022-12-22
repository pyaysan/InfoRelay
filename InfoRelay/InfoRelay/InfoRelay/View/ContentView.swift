//
//  ContentView.swift
//  InfoRelay
//
//  Created by Pyay San on 9/3/22.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var manager: Managers = Managers()
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var menuOpened = false
    
    var body: some View {
        ZStack {
            if menuOpened{
                SideMenu(menuOpened: $menuOpened).environmentObject(viewRouter)
            }
            ZStack {
                Color(.white)
                
                VStack {
                    HStack {
                        HomeView(menuOpened: $menuOpened)
                        
                        Spacer()
                    }
                    
                    VStack {
                        switch viewRouter.currentPage {
                        case .BTConnection:
                            BluetoothDeviceView(manager: manager)
                        case .MQTT:
                            MessagesView()
                                .environmentObject(manager.mqtt)
                        }
                    }
                    
                    Spacer()
                }
            }
            .cornerRadius(menuOpened ? 20 : 10)
            .offset(x: menuOpened ? 300 : 0, y: menuOpened ? 40 : 0)
            .scaleEffect(menuOpened ? 0.8 : 1)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
                
            Spacer()
        }
        .onAppear{
            menuOpened = false
        }
        
        Spacer()
    }

    
}

struct HomeView: View {
    @Binding var menuOpened: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(.white)
            Button(action: {
                withAnimation(.spring()){
                    menuOpened.toggle()
                    
                }
            }, label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.black)
            })
            .padding()
            
            

        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, minHeight: 50,maxHeight: 50, alignment: .center)
        .layoutPriority(1)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(ViewRouter())
//    }
//}



