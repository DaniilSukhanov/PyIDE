//
//  String+FindWords.swift
//  PyIDE
//
//  Created by Даниил Суханов on 13.04.2023.
//

import Foundation

extension String {
    func ranges(words: [String]) -> [String:[NSRange]] {
        var result = words.reduce(into: [String:[NSRange]]()) {
            $0[$1] = [NSRange]()
        }
        var startIndex: Int?, endIndex: Int?
        var word: String
        for (i, symbol) in self.enumerated() {
            if startIndex != nil && endIndex != nil {
                startIndex = nil
                endIndex = nil
            }
            if "\n\t/(): ".contains(symbol) && endIndex == nil && startIndex != nil {
                endIndex = i - 1
            } else if startIndex == nil && !"\n\t/(): ".contains(symbol) {
                startIndex = i
            }
            guard let endIndex, let startIndex else {
                continue
            }
            let range = self.index(self.startIndex, offsetBy: startIndex)...self.index(self.startIndex, offsetBy: endIndex)
            word = String(self[range])
            guard words.contains(word) else {
                continue
            }
            result[word]!.append(NSRange(location: startIndex, length: endIndex - startIndex + 1))
            print(result)
        }
        return result
    }
}
