//
//  BoxRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 08/02/24.
//

import Foundation

// MARK: FetchBoxRepository Implementation
class BoxRepository: FetchBoxRepository {
    func fetchAll() -> [Box] {
        return Box.all()
    }
}


// MARK: CreateBoxRepository Implementation
extension BoxRepository: CreateBoxRepository {
    func createNewBox(name: String, keywords: String, description: String, theme: reTheme) -> Box {
        let newBox = Box.newObject()
        newBox.identifier = UUID()
        newBox.name = name
        newBox.descriptions = description
        newBox.keywords = keywords
        newBox.rawTheme = Int16(theme.rawValue)
        
        return newBox
    }
}


// MARK: EditBoxRepository Implementation
extension BoxRepository: EditBoxRepository {
    func editBox(box: Box, name: String, keywords: String, description: String, theme: Int) -> Box {
        box.name = name
        box.keywords = keywords
        box.descriptions = description
        box.rawTheme = Int16(theme)
        
        return box
    }
}
