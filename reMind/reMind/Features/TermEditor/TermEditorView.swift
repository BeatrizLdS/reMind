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
    @ObservedObject var viewModel: TermEditorModel
        
    @State var isShowingIcon: Bool = false
    let editorType: TermEditorType
    
    init(box: Binding<Box>, isPresented: Binding<Bool>, editorType: TermEditorType = .createNewTerm, term: Term? = nil) {
        self.viewModel = TermEditorModel(termRepositoryImplentation: TermRepository(), term: term)
        self._box = box
        self._isPresented = isPresented
        self.editorType = editorType
    }
    
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
                
                if editorType == .createNewTerm {
                    VStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                createTermAndClear()
                            }
                        }, label: {
                            if !isShowingIcon {
                                Text("Save and Add New")
                                    .frame(maxWidth: .infinity)
                                    .transition(.opacity.animation(.easeInOut))
                            } else {
                                Image(systemName: "checkmark.rectangle.fill")
                                    .frame(maxWidth: .infinity)
                                    .transition(.opacity.animation(.easeInOut))
                            }
                        })
                        .buttonStyle(reButtonStyle())
                    }
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
            .navigationTitle(editorType.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented.toggle()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        createTermAndClose()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    func createTermAndClose() {
        if viewModel.save(box: box) {
            UIApplication.shared.endEditing()
            isPresented.toggle()
        }
    }
    
    func createTermAndClear() {
        if viewModel.save(box: box) {
            isShowingIcon.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShowingIcon.toggle()
                viewModel.clearAllFields()
                focusField = .term
            }
        }
    }
    
    enum TermEditorType : String {
        case createNewTerm = "New Term"
        case editTerm = "Edit Term"
    }
}

struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditorView(box: .constant(Box()), isPresented: .constant(true))
    }
}
