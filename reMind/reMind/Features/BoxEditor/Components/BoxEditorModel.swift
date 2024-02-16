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
    
    private let boxRepository: CreateEditBoxRepository
//    private let boxRepository: EditBoxRepository
        
    @Published var name: String = ""
    @Published var keywords: String = ""
    @Published var description: String = ""
    @Published var theme: Int = 0

    @Published var box: Box?
    
    @Published var alertError = AlertError()
    
    init(repositoryImplementation: CreateEditBoxRepository, box: Box? = nil) {
        self.boxRepository = repositoryImplementation
        
        if let currentBox = box {
            self.box = currentBox
            name = currentBox.name!
            keywords = currentBox.keywords!
            description = currentBox.descriptions!
            theme = Int(currentBox.rawTheme)
        }
    }
    
    func save() -> Bool {
        if box == nil {
            return createNewBox()
        }
        return editCurrentBox()
    }

    private func createNewBox() -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
        
        let newBox = boxRepository.createNewBox(
            name: name,
            keywords: keywords,
            description: description,
            theme: reTheme(rawValue: theme)!
        )
        
        return true
    }
    
    private func editCurrentBox() -> Bool {
        let isValid = fieldsAreFilled()
        if !isValid {
            alertError.showAlert = true
            alertError.errorMessage = "Fill in all the fields."
            return false
        }
                
        box = boxRepository.editBox(
            box: box!,
            name: name,
            keywords: keywords,
            description: description,
            theme: theme)
        
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
