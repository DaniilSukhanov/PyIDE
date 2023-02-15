//
//  VirtualFileSystem.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import Foundation

class VirtualFileSystem: ObservableObject {
    private(set) var project: Project
    @Published var rootDirectory: VFSDirectory
    var urlFileTerminal: URL

    init(project: Project) throws {
        self.project = project
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw VFSError.pathNotFound("Путь не найден")
        }
        print(url.path)
        let urlProjects = url.appendingPathComponent("PyIDEProjects")
        try? manager.createDirectory(at: urlProjects, withIntermediateDirectories: false)
        rootDirectory = VFSDirectory(project.name, url: urlProjects)
        let urlTerminal = url.appendingPathComponent("terminal.txt")
        if !manager.fileExists(atPath: urlTerminal.path()) {
            manager.createFile(atPath: urlTerminal.path(), contents: .none)
        }
        urlFileTerminal = urlTerminal
        updateStoredComponents()
    }
    
    func updateStoredComponents() {
        var stackDirectory = [rootDirectory], fileNames: [String], manager = FileManager.default,
            isDirectory: ObjCBool = false, component: VFSComponent, url: URL
        while !stackDirectory.isEmpty {
            guard let currentDirectory = stackDirectory.popLast() else {
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
                    (component as! VFSFile).pullData()
                }
                try? currentDirectory.appendComponent(component.pack())
            }
        }
    }
}

