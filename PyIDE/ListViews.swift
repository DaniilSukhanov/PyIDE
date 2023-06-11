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
    
    var count: Int {
        data.count
    }

    func append(_ value: any Hashable) {
        data.append(value)
    }

    func removeLast(_ k: Int = 1) {
        data.removeLast(k)
    }
    
    func removeAll() {
        data.removeLast(data.count)
    }
    
}
