//
//  TermRepository.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 15/02/24.
//

import Foundation

// MARK: CreateTermRepository and EditBoxRepository Implementation
class TermRepository: CreateEditTermRepository {
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
    
    func editTerm(term: Term, title: String, meaning: String) -> Term {
        term.value = title
        term.meaning = meaning
        
        return term
    }
}
