//
//  Program.swift
//  PyIDE
//
//  Created by Даниил Суханов on 10.09.2023.
//

import Foundation
import Combine

protocol Program: AnyObject {
    var name: String { get }
    var mainFile: URL { get }
    
    init(name: String, mainFile: URL)
    
    func runProgram() throws -> AnyPublisher<Any, Error>
}
