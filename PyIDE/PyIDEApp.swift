//
//  PyIDEApp.swift
//  PyIDE
//
//  Created by Даниил Суханов on 11.11.2022.
//

import SwiftUI


@main
struct PyIDEApp: App {
    @StateObject private var listViews = ListViews()
    @State private var projects = [Project]()
    
    var body: some Scene {
        WindowGroup {
            OptionsView()
                .environmentObject(self.listViews)
        }
    }
}
