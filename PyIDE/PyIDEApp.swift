//
//  PyIDEApp.swift
//  PyIDE
//
//  Created by Даниил Суханов on 11.11.2022.
//

import SwiftUI

@main
struct PyIDEApp: App {
    @State private var stackViews = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            OptionsView().environment(\.stackViews, $stackViews)
        }
    }
}
