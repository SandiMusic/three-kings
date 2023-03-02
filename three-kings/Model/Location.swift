//
//  Location.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

struct Location: CustomStringConvertible {
    
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    var description: String {
        return "Board Location: (\(row),\(column))"
    }
    
}
