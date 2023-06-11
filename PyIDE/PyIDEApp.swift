//
//  PyIDEApp.swift
//  PyIDE
//
//  Created by Даниил Суханов on 11.11.2022.
//

import SwiftUI
import OSLog


@main
struct PyIDEApp: App {
    @StateObject private var listViews = ListViews()
    
    init() {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "pre-start")
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var urlApp = Bundle.main.bundleURL
        urlApp.append(component: "python-stdlib")
        if (try? manager.copyItem(atPath: urlApp.path(), toPath: url.path() + "/python-stdlib")) != nil {
            logger.info("python-stdlib была скопираванна в \(url)")
        } else {
            logger.error("python-stdlib была не скопираванна в \(url)")
        }
        settingsPython(urlLib: url)
    }
    
    var body: some Scene {
        WindowGroup {
            OptionsView()
                .environmentObject(self.listViews)
        }
    }
}
