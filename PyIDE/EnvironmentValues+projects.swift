//
//  EnvironmentValues+projects.swift
//  PyIDE
//
//  Created by Даниил Суханов on 29.05.2023.
//

import Foundation
import SwiftUI

private struct ProjectsEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<[Project]> = .constant([])
}

extension EnvironmentValues {
    var projects: Binding<[Project]> {
        get { self[ProjectsEnvironmentKey.self] }
        set { self[ProjectsEnvironmentKey.self] = newValue }
    }
}


