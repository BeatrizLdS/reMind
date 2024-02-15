//
//  TermRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 15/02/24.
//

import Foundation

// MARK: CreateTermRepository Implementation
class TermRepository: CreateTermRepository {
    func createNewTermTo(box: Box, title: String, meaning: String, theme: reTheme) -> Term {
        let newTerm = Term.newObject()
        newTerm.identifier = UUID()
        newTerm.value = title
        newTerm.meaning = meaning
        
        newTerm.creationDate = Date()
        newTerm.lastReview = Date()
        newTerm.rawSRS = Int16(SpacedRepetitionSystem.first.rawValue)
        
        newTerm.rawTheme = Int16(theme.rawValue)
        
        box.addToTerms(newTerm)
        return newTerm
    }
}
