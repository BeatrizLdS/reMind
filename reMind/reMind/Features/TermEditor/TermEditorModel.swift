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
    
    func createNewTerm(box: Box) -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newTerm = Term.newObject()
        newTerm.identifier = UUID()
        newTerm.meaning = meaning
        newTerm.value = term
        newTerm.creationDate = Date()
        newTerm.lastReview = Date()
        newTerm.rawSRS = Int16(SpacedRepetitionSystem.first.rawValue)
        let theme = reTheme.allCases.randomElement() ?? reTheme.lavender
        newTerm.rawTheme = Int16(theme.rawValue)
        
        box.addToTerms(newTerm)
        
        let saveSuccessful = CoreDataStack.shared.saveContext()
        if !saveSuccessful {
            alertError.showAlert = true
            alertError.errorMessage = "Could not save the new box. Please try again; if the issue persists, report the problem."
            return false
        }
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
}
