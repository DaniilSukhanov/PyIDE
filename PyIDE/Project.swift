//
//  Project.swift
//  PyIDE
//
//  Created by Даниил Суханов on 09.12.2022.
//

import Foundation

class Project: ObservableObject, Identifiable, Hashable {
    private enum ProjectError: Error {
        case failedInitialize(Error)
    }
    
    @Published var name: String
    @Published var virtualFileSystem: VirtualFileSystem?
    
    init(name: String) throws {
        self.name = name
        do {
            self.virtualFileSystem = try VirtualFileSystem(project: self)
        } catch {
            throw ProjectError.failedInitialize(error)
        }
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
