//
//  ASTComponents.swift
//  PyIDE
//
//  Created by Даниил Суханов on 21.03.2023.
//

import Foundation


struct ASTComponent: Decodable {
    let type: String
    let lineno: Int?
    let col_offset: Int?
    let end_lineno: Int?
    let end_col_offset: Int?
    let body: [ASTComponent]?
}
