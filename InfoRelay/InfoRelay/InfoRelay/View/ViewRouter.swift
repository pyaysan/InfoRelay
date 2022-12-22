//
//  ViewRouter.swift
//  InfoRelay
//
//  Created by Pyay San on 11/11/22.
//

import SwiftUI
import Foundation

class ViewRouter: ObservableObject {
    var currentPage: Page = .MQTT
}

enum Page {
    case BTConnection
    case MQTT
}
