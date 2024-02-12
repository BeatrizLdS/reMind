//
//  CreateBoxRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 08/02/24.
//

import Foundation

protocol CreateBoxRepository {
    func createNewBox(name: String, keywords: String, description: String, theme: reTheme) -> Box
}
