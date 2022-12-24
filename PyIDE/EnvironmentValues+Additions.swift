//
//  EnvironmentValues+Additions.swift
//  PyIDE
//
//  Created by Даниил Суханов on 23.12.2022.
//

import SwiftUI

struct StackViewsKey: EnvironmentKey {
    static let defaultValue: Binding<NavigationPath> = .constant(NavigationPath())
}

extension EnvironmentValues {
    var stackViews: Binding<NavigationPath> {
        get { self[StackViewsKey.self] }
        set { self[StackViewsKey.self] = newValue}
    }
}

