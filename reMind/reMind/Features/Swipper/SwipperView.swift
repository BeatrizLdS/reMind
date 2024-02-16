//
//  SwipperView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct SwipperView: View {
    @State var viewModel: SwipperModel
    @State private var direction: SwipperDirection = .none
    @Binding var isPresenting: Bool

    var body: some View {
        NavigationStack {
                VStack {
                    SwipperLabel(direction: $direction)
                        .padding()
                    
                    Spacer()
                    
                    SwipperCard(direction: $direction,
                                frontContent: {
                        Text(viewModel.currentTerm.value ?? "Unknown")
                    }, backContent: {
                        Text(viewModel.currentTerm.meaning ?? "Unknown")
                    }).transition(.opacity)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresenting.toggle()
                    }, label: {
                        Text("Finish Review")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .buttonStyle(reButtonStyle())
                    .padding(.bottom, 30)
                    
                }
                .onChange(of: direction, perform: { direction in
                    if direction == .right {
                        viewModel.addToRight()
                    } else if direction == .left {
                        viewModel.addToLeft()
                    }
                })
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(reBackground())
                .navigationTitle("\(viewModel.termsInReview.termsToReview.count) terms left")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
}

struct SwipperView_Previews: PreviewProvider {
    static let term: Term = {
        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Term"
        term.meaning = "Meaning"
        term.rawSRS = 0
        term.rawTheme = 0
        
        return term
    }()
    static var previews: some View {
        NavigationStack {
            SwipperView(viewModel: SwipperModel(terms: [
                Term(context: CoreDataStack.inMemory.managedContext)
            ]), isPresenting: .constant(false))
        }
    }
}
