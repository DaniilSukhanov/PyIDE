//
//  Project.swift
//  PyIDE
//
//  Created by Даниил Суханов on 09.12.2022.
//

import Foundation


class Project: ObservableObject, Identifiable, Hashable {
    @Published var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
