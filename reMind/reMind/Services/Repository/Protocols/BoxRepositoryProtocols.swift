//
//  getBoxRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 08/02/24.
//

import Foundation

protocol FetchBoxRepository {
    func fetchAll() -> [Box]
}

protocol CreateBoxRepository {
    func createNewBox(name: String, keywords: String, description: String, theme: reTheme) -> Box
}

protocol EditBoxRepository {
    func editBox(box: Box, name: String, keywords: String, description: String, theme: Int) -> Box
}
