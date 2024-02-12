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

