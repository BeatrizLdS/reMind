//
//  CreateBoxRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 08/02/24.
//

import Foundation

protocol CreateTermRepository {
    func createNewTermTo(box: Box, title: String, meaning: String, theme: reTheme) -> Term
}
