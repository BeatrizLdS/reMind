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
    
    private let createBoxRepository: CreateBoxRepository
        
    @Published var name: String = ""
    @Published var keywords: String = ""
    @Published var description: String = ""
    @Published var theme: Int = 0

    @Published var box: Box?
    
    @Published var alertError = AlertError()
    
    init(repositoryImplementation: CreateBoxRepository) {
        self.createBoxRepository = repositoryImplementation
    }
    
    func createNewBox() -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newBox = createBoxRepository.createNewBox(
            name: name,
            keywords: keywords,
            description: description,
            theme: reTheme(rawValue: theme)!
        )
        
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
