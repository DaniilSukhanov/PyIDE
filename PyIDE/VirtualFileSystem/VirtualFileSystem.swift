//
//  VirtualFileSystem.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import Foundation

class VirtualFileSystem: ObservableObject {
    private(set) var project: Project
    var rootDirectory: VFSDirectory

    init(project: Project) throws {
        self.project = project
        let manage = FileManager.default
        guard let url = manage.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw VFSError.pathNotFound("Путь не найден")
        }
        print(url.path)
        rootDirectory = VFSDirectory(project.name, url: url)
        updateStoredComponents()
    }
    
    private func updateStoredComponents() {
        var stackDirectory = [rootDirectory], fileNames: [String], manager = FileManager.default,
            isDirectory: ObjCBool = false, component: VFSComponent, url: URL
        while !stackDirectory.isEmpty {
            guard var currentDirectory = stackDirectory.popLast() else {
                continue
            }
            fileNames = try! manager.contentsOfDirectory(atPath: currentDirectory.url.path())
            for fileName in fileNames {
                if fileName == ".DS_Store" {
                    continue
                }
                url = currentDirectory.url.appendingPathComponent(fileName)
                guard manager.fileExists(atPath: url.path(), isDirectory: &isDirectory) else {
                    print("\(fileName) не найден")
                    continue
                }
                if isDirectory.boolValue {
                    component = VFSDirectory(fileName, parentDirectory: currentDirectory)
                    stackDirectory.append(component as! VFSDirectory)
                } else {
                    component = VFSFile(fileName, parentDirectory: currentDirectory)
                }
                try? currentDirectory.appendComponent(component)
            }
        }
    }
}

