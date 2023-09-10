//
//  PythonManager.swift
//  PyIDE
//
//  Created by Даниил Суханов on 10.09.2023.
//

import Foundation
import Combine


protocol Programa: AnyObject {
    var isRunning: Bool { get }
    var name: String { get }
    
    init(name: String)
    
    func runProgram() throws -> AnyPublisher
}

