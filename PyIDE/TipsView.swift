//
//  TipsView.swift
//  PyIDE
//
//  Created by Даниил Суханов on 07.05.2023.
//

import SwiftUI

struct TipsView: View {
    fileprivate struct Container: Identifiable {
        let text: String
        var id: String {
            text
        }
    }
    
    @Binding var selectedVFSContainer: VFSContainer?
    @Binding var cursorPosition: Int?
    
    fileprivate func getTips() -> [Container] {
        var result = [Container]()
        guard let file = selectedVFSContainer?.component as? VFSFile else {
            return result
        }
        guard let cursorPosition = cursorPosition else {
            return result
        }
        let dataFile = file.data!
        let rootComponent = file.getJSONData()
        let methods = rootComponent.getMethods()
        let variables = rootComponent.getVariable()
        let string = dataFile.getFragment(cursorPosition == dataFile.count ? cursorPosition - 1 : cursorPosition)
        print(string)
        if !string.contains(".") {
            return result
        }
        guard let cls = variables?.first(where: { (key, _) in
            
            return key.id! == string.components(separatedBy: ".")[0]
        })?.value else {
            return result
        }
        guard let currentMethods = methods?.first(where: { (key, _) in
            key.name! == cls.id!
        }) else {
            return result
        }
        let nameFragmentMethod = string.components(separatedBy: ".")[1]
        result += currentMethods.value.filter {
            nameFragmentMethod.isEmpty || $0.name!.contains(nameFragmentMethod)
        }.map {
            Container(text: $0.name!)
        }
        return result
    }
    
    fileprivate func getASTComponent(_ rootComponent: ASTComponent, _ row: Int) -> ASTComponent? {
        var stack = [rootComponent]
        while !stack.isEmpty {
            let component = stack.popLast()!
            if component.body != nil {
                stack += component.body!
            }
            guard let lineno = component.lineno else {
                continue
            }
            if lineno == row {
                return component
            }
        }
        return nil
    }
    
    fileprivate func getCoordsCursor(_ string: String, _ cursorPosition: Int) -> (row: Int, col: Int)? {
        var cursorPosition = cursorPosition
        let array = Array(string.components(separatedBy: "\n").enumerated())
        for (i, substring) in array {
            var n = substring.count
            if i != array.count {
                n += 1
            }
            cursorPosition -= n
            if cursorPosition <= 0 {
                return (i, cursorPosition + n)
            }
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 18) {
                ForEach(getTips()) {
                    Text($0.text).font(.largeTitle)
                }
                Spacer()
            }
        }
    }
}

fileprivate extension String {
    func getFragment(_ cursorPosition: Int) -> String {
        if self.isEmpty {
            return self
        }
        guard (0..<self.count).contains(cursorPosition) else {
            return self
        }
        
        var left = cursorPosition, right = cursorPosition
        let chars: [Character] = [" ", "\t", "\n"]
        var char: Character
        repeat {
            char = self[self.index(self.startIndex, offsetBy: left)]
            left -= 1
            if left < 0 {
                break
            }
        } while !chars.contains(char)
        repeat {
            char = self[self.index(self.startIndex, offsetBy: right)]
            right += 1
            if right >= self.count {
                break
            }
        } while !chars.contains(char)
        let range = self.index(self.startIndex, offsetBy: left <= 0 ? 0 : left - 1)...self.index(self.startIndex, offsetBy: right - 1)
        return String(self[range]).replacing(" ", with: "").replacing("\n", with: "").replacing("\t", with: "")
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
