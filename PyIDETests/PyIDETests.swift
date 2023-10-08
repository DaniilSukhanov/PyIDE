//
//  PyIDETests.swift
//  PyIDETests
//
//  Created by Даниил Суханов on 14.09.2023.
//

import XCTest
@testable import PyIDE
import Combine
import Python

final class PyIDETests: XCTestCase {
    var pythonRunner: PythonProgram!
    var store = [AnyCancellable]()

    override func setUpWithError() throws {
        pythonRunner = .init(name: "123", mainFile: .init(string: "123")!)
    }

    override func tearDownWithError() throws {
        pythonRunner = nil
    }

    func testExample() throws {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(4)) {
            StreamingDataManager.addInInput(data: "StreamingDataManager!")
            StreamingDataManager.addInInput(data: "StreamingDataManager!")
        }
        
        try? pythonRunner.runProgram()
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("failure: \(error)")
                }
            } receiveValue: { value in
                print("receiveValue: \(value)")
            }.store(in: &store)
        sleep(6)

    }

}
