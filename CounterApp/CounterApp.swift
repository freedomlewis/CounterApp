//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/6.
//

import SwiftUI

@main
struct CounterApp: App {    
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}
