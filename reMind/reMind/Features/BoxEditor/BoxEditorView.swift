//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {    
    @ObservedObject var viewModel: BoxEditorModel
    @Binding var isPresented: Bool
    
    @FocusState var focusField: BoxEditorModel.FocusedField?
    let editorType: BoxEditorType
    
    init(isPresented: Binding<Bool>, editorType: BoxEditorType, box: Box? = nil) {
        self._isPresented = isPresented
        self.editorType = editorType
        
        if let currentBox = box {
            self.viewModel = BoxEditorModel(
                creationRepositoryImplementation: BoxRepository(),
                editionRepositoryImplementation: BoxRepository(),
                box: currentBox)
        } else {
            self.viewModel = BoxEditorModel(
                creationRepositoryImplementation: BoxRepository(),
                editionRepositoryImplementation: BoxRepository())
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    reTextField(title: "Name",
                                text: $viewModel.name)
                    .focused($focusField, equals: .name)
                    .onSubmit {
                        focusField = .keywords
                    }
                    
                    reTextField(title: "Keywords",
                                caption: "Separated by , (comma)",
                                text: $viewModel.keywords)
                    .focused($focusField, equals: .keywords)
                    .onSubmit {
                        focusField = .description
                    }
                    
                    reTextEditor(title: "Description",
                                 text: $viewModel.description)
                    .focused($focusField, equals: .description)
                    
                    
                    reRadioButtonGroup(title: "Theme",
                                       currentSelection: $viewModel.theme)
                    Spacer()
                }
            }
            .padding(10)
            .alert(isPresented: $viewModel.alertError.showAlert) {
                Alert(title: Text("Error!"), message: Text(viewModel.alertError.errorMessage))
            }
            .onAppear {
                focusField = editorType == .createNewBox ? .name : nil
            }
            .background(reBackground())
            .navigationTitle(editorType.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.save() {
                            isPresented = false
                        }
                    }
                    .fontWeight(.bold)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
    
    enum BoxEditorType : String {
        case createNewBox = "New Box"
        case editBox = "Edit Box"
    }
}

struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(isPresented: .constant(true), editorType: .createNewBox)
    }
}

