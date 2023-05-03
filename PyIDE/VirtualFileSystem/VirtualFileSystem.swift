//
//  VirtualFileSystem.swift
//  PyIDE
//
//  Created by Даниил Суханов on 24.12.2022.
//

import Foundation
import OSLog
 
class VirtualFileSystem: ObservableObject {
    private(set) var project: Project
    @Published var rootDirectory: VFSDirectory
    var urlFileTerminal: URL
    var urlFilesASTProject: URL
    var urlFileStdin: URL
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "vfs")

    init(project: Project) throws {
        self.project = project
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw VFSError.pathNotFound("Путь не найден")
        }
        urlFilesASTProject = url.appendingPathComponent("PyIDEASTProjects").appendingPathComponent(project.name)
        let urlProjects = url.appendingPathComponent("PyIDEProjects")
        try? manager.createDirectory(at: self.urlFilesASTProject, withIntermediateDirectories: true)
        try? manager.createDirectory(at: urlProjects, withIntermediateDirectories: false)
        rootDirectory = VFSDirectory(project.name, url: urlProjects)
        let urlTerminal = url.appendingPathComponent("terminal.txt")
        if !manager.fileExists(atPath: urlTerminal.path()) {
            logger.info("Создание файла терминала \(urlTerminal)")
            manager.createFile(atPath: urlTerminal.path(), contents: .none)
        }
        urlFileTerminal = urlTerminal
        let urlStdin = url.appendingPathComponent("stdin.txt")
        if !manager.fileExists(atPath: urlStdin.path()) {
            logger.info("Создание файла стандартного ввода \(urlStdin)")
            manager.createFile(atPath: urlStdin.path(), contents: .none)
        }
        urlFileStdin = urlStdin
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
                if fileName == ".DS_Store" || fileName == "__pycache__" {
                    continue
                }
                url = currentDirectory.url.appendingPathComponent(fileName)
                guard manager.fileExists(atPath: url.path(), isDirectory: &isDirectory) else {
                    logger.info("файл \(url ) был не найден")
                    continue
                }
                if isDirectory.boolValue {
                    component = VFSDirectory(fileName, parentDirectory: currentDirectory)
                    stackDirectory.append(component as! VFSDirectory)
                } else {
                    component = VFSFile(fileName, parentDirectory: currentDirectory)
                    (component as! VFSFile).pullData()
                }
                logger.info("Добавление в VFS элемента \(url)")
                try? currentDirectory.appendComponent(component.pack())
            }
        }
    }
}

