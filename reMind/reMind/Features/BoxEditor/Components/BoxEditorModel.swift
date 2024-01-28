//
//  BoxEditorModel.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 24/01/24.
//

import Foundation

class BoxEditorModel: ObservableObject {
    enum FocusedField: Hashable {
        case name, keywords, description
    }
        
    @Published var name: String = ""
    @Published var keywords: String = ""
    @Published var description: String = ""
    @Published var theme: Int = 0

    @Published var box: Box?
    
    @Published var alertError = AlertError()
    
    func createNewBox() -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newBox = Box.newObject()
        newBox.identifier = UUID()
        newBox.name = name
        newBox.descriptions = description
        newBox.keywords = keywords
        newBox.rawTheme = Int16(theme)
        
        let saveSuccessful = CoreDataStack.shared.saveContext()
        if !saveSuccessful {
            alertError.showAlert = true
            alertError.errorMessage = "Could not save the new box. Please try again; if the issue persists, report the problem."
            return false
        }
        return true
    }
    
    private func fieldsAreFilled() -> Bool {
        let filteredName = name.filter{ $0 != " " }
        let filteredKeywords = keywords.filter{ $0 != " " }
        let filteredDescription = description.filter{ $0 != " " }
        
        if filteredName.isEmpty || filteredKeywords.isEmpty || filteredDescription.isEmpty {
            return false
        }
        return true
    }
}

struct AlertError {
    var showAlert = false
    var errorMessage = ""
}
