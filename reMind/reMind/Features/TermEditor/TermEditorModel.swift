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
    
    @Published var currentTerm: Term?
    
    @Published var alertError = AlertError()
    
    private let termRepository: CreateEditTermRepository
    
    init(termRepositoryImplentation: CreateEditTermRepository, term: Term? = nil) {
        self.termRepository = termRepositoryImplentation
        if let currentTerm = term {
            self.currentTerm = currentTerm
            self.term = currentTerm.value!
            self.meaning = currentTerm.meaning!
        }
    }
    
    func save(box: Box) -> Bool {
        if currentTerm == nil {
            return createNewTerm(box: box)
        }
        return editCurrentTerm()
    }
    
    private func editCurrentTerm() -> Bool {
        currentTerm = termRepository.editTerm(
            term: currentTerm!,
            title: term,
            meaning: meaning)
        return true
    }
    
    private func createNewTerm(box: Box) -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newTerm = termRepository.createNewTermTo(
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
