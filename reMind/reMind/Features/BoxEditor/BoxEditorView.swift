//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {    
    @ObservedObject var viewModel: BoxEditorModel = BoxEditorModel(repositoryImplementation: BoxRepository())
    @Binding var isPresented: Bool
    
    @FocusState var focusField: BoxEditorModel.FocusedField?
    let editorType: BoxEditorType
    
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
                focusField = .name
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
                        if viewModel.createNewBox() {
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

