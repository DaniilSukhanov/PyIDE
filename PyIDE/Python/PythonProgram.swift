//
//  PythonProgram.swift
//  PyIDE
//
//  Created by Даниил Суханов on 13.09.2023.
//

import Foundation
import Combine
import Python

final class PythonProgram: Program {
    
    private(set) var name: String
    private(set) var mainFile: URL
    
    init(name: String, mainFile: URL) {
        self.name = name
        self.mainFile = mainFile
    }
    
    func runProgram() throws -> AnyPublisher<Any, Error> {
        Future { promise in
            let dict: [String: [Int32]] = [
                "/Users/daniilsuhanov/Desktop/1/main.py": [10, 2, 5, 2]
            ]
            var cArray = [ItemDictionary]()
            for (key, value) in dict {
                var item = ItemDictionary()
                item.key = UnsafePointer(UnsafeMutablePointer(mutating: (key as NSString).utf8String))
                value.withUnsafeBufferPointer { bufferPoint in
                    guard let pointer = bufferPoint.baseAddress else {
                        return
                    }
                    item.value = pointer
                }
                item.amountBreakpoint = Int32(value.count)
                cArray.append(item)
            }
            
            cArray.withUnsafeMutableBufferPointer { bufferPoint in
                guard let pointer = bufferPoint.baseAddress else {
                    return
                }
                print(pointer.pointee.value.pointee)
                print(pointer.pointee.key.pointee)
                runPython("/Users/daniilsuhanov/Desktop/1/main.py", pointer, Int32(dict.count))
            }
            promise(.success(0))
            
        }
        .eraseToAnyPublisher()
    }
    
}
