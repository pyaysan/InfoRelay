//
//  InfoRelayApp.swift
//  InfoRelay
//
//  Created by Pyay San on 9/3/22.
//
import SwiftUI

@main
struct InfoRelayApp: App {
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewRouter)
        }
    }
}
