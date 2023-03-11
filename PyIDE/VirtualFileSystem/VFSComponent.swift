//
//  VFSComponent.swift
//  PyIDE
//
//  Created by Даниил Суханов on 07.01.2023.
//

import Foundation

struct VFSContainer: Hashable, Identifiable {
    var id: ObjectIdentifier
    var component: VFSComponent
    
    init(component: VFSComponent) {
        self.id = component.id
        self.component = component
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(component.hashValue)
    }
}

class VFSComponent: Hashable, Identifiable, CustomStringConvertible, ObservableObject {
    var description: String { name }
    var name: String {
        get { url.lastPathComponent }
        set {
            url.deleteLastPathComponent()
            url = url.appendingPathComponent(newValue)
        }
    }
    @Published var storedComponents: Array<VFSContainer>?
    private(set) var url: URL
    var urlJSONAST: URL {
        var array = url.pathComponents
        let index = Int(array.firstIndex(of: "PyIDEProjects")!)
        array.replaceSubrange(index...index, with: ["PyIDEASTProjects"])
        if array[array.endIndex - 1].contains(".py") {
            array[array.endIndex - 1] = array[array.endIndex - 1].replacing(".py", with: ".json")
        }
        return URL(filePath: array.joined(separator: "/"))
    }
    private(set) var parentDirectory: VFSDirectory?

    required init(_ name: String, parentDirectory: VFSDirectory) {
        self.parentDirectory = parentDirectory
        self.url = parentDirectory.url.appendingPathComponent(name)
    }
    
    required init(_ name: String, url: URL) {
        self.url = url.appendingPathComponent(name)
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
    
    func kill() {
        let manager = FileManager.default
        try! manager.removeItem(at: url)
        guard let directory = parentDirectory else {
            return
        }
        try! directory.removeComponent(self.pack())
    }
    
    func pack() -> VFSContainer {
        VFSContainer(component: self)
    }
}

class VFSFile: VFSComponent {
    @Published var data: String?
    
    required init(_ name: String, parentDirectory: VFSDirectory) {
        super.init(name, parentDirectory: parentDirectory)
        try! create()
        pullData()
    }
    
    required init(_ name: String, url: URL) {
        fatalError("init(_:url:) has not been implemented")
    }
    
    private func create() throws {
        let manager = FileManager()
        if !manager.fileExists(atPath: url.path()) {
            if !manager.createFile(atPath: url.path(), contents: nil) {
                throw VFSError.failedCreateVFSComponent("Невозможно создать файл")
            }
        }
        if !manager.fileExists(atPath: urlJSONAST.path()) {
            if !manager.createFile(atPath: urlJSONAST.path(), contents: nil) {
                throw VFSError.failedCreateVFSComponent("Невозможно создать файл JSON")
            }
        }
    }
    
    /**
     Загружает в компонент данные из физического файла
     */
    func pullData() {
        data = try! String(contentsOf: url)
    }
    
    /**
     Записывает в физический файл данные
     */
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
        do {
            try manager.createDirectory(at: urlJSONAST, withIntermediateDirectories: false)
        } catch {
            if !manager.fileExists(atPath: urlJSONAST.path()) {
                throw VFSError.failedCreateVFSComponent(error.localizedDescription)
            }
        }
    }
    
    func appendComponent(_ component: VFSContainer) throws {
        guard let _ = storedComponents else {
            throw VFSError.failedCreateVFSComponent("Хранимые свойства не инициализированы")
        }
        if storedComponents!.contains(where: { $0.component.name == component.component.name}) {
            throw VFSError.failedCreateVFSComponent("Нельзя добавить компонент, если он уже находиться в хранимых компонентов")
        }
        storedComponents!.append(component)

    }
    
    func removeComponent(_ component: VFSContainer) throws {
        guard let _ = storedComponents else {
            throw VFSError.failedRemoveVFSComponent("Хранимые свойства не инициализированы")
        }
        let index = storedComponents?.firstIndex(where: { $0.component.name == component.component.name })
        guard let _ = index else {
            throw VFSError.failedRemoveVFSComponent("Не удалось найти элемент в хранимых компонентов")
        }
        storedComponents!.remove(at: index!)
        
    }
    
}

enum VFSError: Error {
    case pathNotFound(String)
    case pathNotCorrect(String)
    case failedCreateVFSComponent(String)
    case failedRemoveVFSComponent(String)
}
