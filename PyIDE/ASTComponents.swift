//
//  ASTComponents.swift
//  PyIDE
//
//  Created by Даниил Суханов on 21.03.2023.
//

import Foundation
import UIKit

protocol ASTComponentable {
    var type: String { get }
}

struct ASTComponent: ASTComponentable, Decodable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case function = "func"
        case type, lineno, name, col_offset, end_lineno,
             end_col_offset, id, body, targets, orelse, value
    }
    
    let type: String
    let lineno: Int?
    let name: String?
    let col_offset: Int?
    let end_lineno: Int?
    let end_col_offset: Int?
    let id: String?
    let function: ASTName?
    let body: [ASTComponent]?
    let targets: [ASTComponent]?
    let orelse: [ASTComponent]?
    let value: ASTValue?
}

struct ASTName: ASTComponentable, Decodable, Hashable {
    let type: String
    let lineno: Int?
    let col_offset: Int?
    let end_lineno: Int?
    let end_col_offset: Int?
    let id: String?
}

struct ASTValue: ASTComponentable, Decodable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case function = "func"
        case type, lineno, col_offset, end_lineno,
             end_col_offset, id
    }
    let type: String
    let function: ASTName?
    let lineno: Int?
    let col_offset: Int?
    let end_lineno: Int?
    let end_col_offset: Int?
    let id: String?
}
