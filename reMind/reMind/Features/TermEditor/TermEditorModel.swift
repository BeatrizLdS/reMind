//
//  TermEditorModel.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 28/01/24.
//

import Foundation

class TermEditorModel: ObservableObject {
    @Published var term: String = ""
    @Published var meaning: String = ""
    
    @Published var alertError = AlertError()
    
    private let createTermRepository: CreateTermRepository
    
    init(termRepositoryImplentation: CreateTermRepository) {
        self.createTermRepository = termRepositoryImplentation
    }
    
    func createNewTerm(box: Box) -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newTerm = createTermRepository.createNewTermTo(
            box: box,
            title: term,
            meaning: meaning,
            theme: reTheme.allCases.randomElement() ?? reTheme.lavender)
        
        return true
    }
    
    private func fieldsAreFilled() -> Bool {
        let filteredTerm = term.filter{ $0 != " " }
        let filteredMeaning = meaning.filter{ $0 != " " }
        
        if filteredTerm.isEmpty || filteredMeaning.isEmpty {
            return false
        }
        return true
    }
    
    func clearAllFields() {
        term = ""
        meaning = ""
    }
}
