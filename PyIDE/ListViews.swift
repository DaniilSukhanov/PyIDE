//
//  ListViews.swift
//  PyIDE
//
//  Created by Даниил Суханов on 30.12.2022.
//

import Foundation
import SwiftUI

class ListViews: ObservableObject {
    @Published var data = NavigationPath()
    
    func append(_ value: any Hashable) {
        data.append(value)
    }
    
    func removeLast() {
        data.removeLast()
    }
}
