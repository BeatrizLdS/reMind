//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI

struct TermEditorView: View {
    @Binding var box: Box
    
    enum FocusedField: Hashable {
        case term, meaning
    }
    
    @FocusState var focusField: FocusedField?
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TermEditorModel = TermEditorModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        reTextField(title: "Term", text: $viewModel.term)
                            .focused($focusField, equals: .term)
                            .onSubmit {
                                focusField = .meaning
                            }
                        reTextEditor(title: "Meaning", text: $viewModel.meaning)
                            .focused($focusField, equals: .meaning)
                            .onSubmit {
                                UIApplication.shared.endEditing()
                            }
                    }
                    .padding(.bottom, 60)
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        createTerm()
                    }, label: {
                        Text("Save and Add New")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(reButtonStyle())
                }
            }
            .padding(10)
            .background(reBackground())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onAppear {
                focusField = .term
            }
            .alert(isPresented: $viewModel.alertError.showAlert) {
                Alert(title: Text("Error!"), message: Text(viewModel.alertError.errorMessage))
            }
            .navigationTitle("New Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented.toggle()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        createTerm()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    func createTerm() {
        if viewModel.createNewTerm(box: box) {
            UIApplication.shared.endEditing()
            isPresented.toggle()
        }
    }
}

struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditorView(box: .constant(Box()), isPresented: .constant(true))
    }
}
