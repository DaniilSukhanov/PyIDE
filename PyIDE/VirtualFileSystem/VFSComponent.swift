//
//  VFSComponent.swift
//  PyIDE
//
//  Created by Даниил Суханов on 07.01.2023.
//

import Foundation


class VFSComponent: Hashable, Identifiable, CustomStringConvertible, ObservableObject {
    var description: String { name }
    var name: String {
        get { url.lastPathComponent }
        set {
            url.deleteLastPathComponent()
            url = url.appendingPathComponent(newValue)
        }
    }
    @Published var storedComponents: Array<VFSComponent>?
    private(set) var url: URL
    private(set) var parentDirectory: VFSDirectory?

    required init(_ name: String, parentDirectory: VFSDirectory) {
        self.parentDirectory = parentDirectory
        self.url = parentDirectory.url.appendingPathComponent(name)
        
    }
    
    required init(_ name: String, url: URL) {
        self.url = url.appendingPathComponent(name)
    }
    
    func appendComponent(_ component: VFSComponent) throws {
        guard let _ = storedComponents else {
            throw VFSError.failedCreateVFSComponent("Хранимые свойства не инициализированы")
        }
        if storedComponents!.contains(component) {
            throw VFSError.failedCreateVFSComponent("Нельзя добавить компонент, если он уже находиться в хранимых компонентов")
        }
        storedComponents!.append(component)

    }
    
    func removeComponent(_ component: VFSComponent) throws {
        guard let _ = storedComponents else {
            throw VFSError.failedRemoveVFSComponent("Хранимые свойства не инициализированы")
        }
        let index = storedComponents?.firstIndex(of: component)
        guard let _ = index else {
            throw VFSError.failedRemoveVFSComponent("Не удалось найти элемент в хранимых компонентов")
        }
        storedComponents!.remove(at: index!)
    }
    
    fileprivate func initStoreComponents() {
        self.storedComponents = .init()
    }
    
    static func == (lhs: VFSComponent, rhs: VFSComponent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

class VFSFile: VFSComponent {
    var data: String?
    
    required init(_ name: String, parentDirectory: VFSDirectory) {
        super.init(name, parentDirectory: parentDirectory)
        try! create()
        pullData()
    }
    
    required init(_ name: String, url: URL) {
        super.init(name, url: url)
        try! create()
        pullData()
    }
    
    private func create() throws {
        let manager = FileManager()
        if manager.fileExists(atPath: url.path()) {
            return
        }
        if !manager.createFile(atPath: url.path(), contents: nil) {
            throw VFSError.failedCreateVFSComponent("Невозможно создать файл")
        }
    }
    
    func pullData() {
        data = try! String(contentsOf: url)
    }
    
    func pushData(_ data: String) {
        try! data.write(to: url, atomically: false, encoding: .utf8)
    }
}

class VFSDirectory: VFSComponent {
    required init(_ name: String, parentDirectory: VFSDirectory) {
        super.init(name, parentDirectory: parentDirectory)
        initStoreComponents()
        try! create()
    }
    
    required init(_ name: String, url: URL) {
        super.init(name, url: url)
        initStoreComponents()
        try! create()
    }
    
    private func create() throws {
        let manager = FileManager()
        do {
            try manager.createDirectory(at: url, withIntermediateDirectories: false)
        } catch {
            if !manager.fileExists(atPath: url.path()) {
                throw VFSError.failedCreateVFSComponent(error.localizedDescription)
            }
        }
    }
    
}

enum VFSError: Error {
    case pathNotFound(String)
    case pathNotCorrect(String)
    case failedCreateVFSComponent(String)
    case failedRemoveVFSComponent(String)
}
