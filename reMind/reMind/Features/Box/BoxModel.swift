//
//  BoxModel.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 28/01/24.
//

import Foundation

class BoxModel: ObservableObject {
    @Published var box: Box
    @Published var searchText: String = ""
    @Published var filteredTerms: [Term] = []
    @Published var title: String
        
    init(box: Box) {
        self.box = box
        self.title = box.name ?? "Unknown"
        updateFilteredTerms()
    }
    
    func updateTitle() {
        title = box.name ?? "Unknown"
    }
    
    func updateFilteredTerms() {
        let termsSet = box.terms as? Set<Term> ?? []
        let terms = Array(termsSet).sorted { lhs, rhs in
            (lhs.creationDate!) > (rhs.creationDate!)
        }
        
        if searchText.isEmpty {
            filteredTerms = terms
        } else {
            filteredTerms = terms.filter { ($0.value ?? "").contains(searchText) }
        }
    }
    
    func getNumberOfPendingTerms() -> Int {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count
    }
    
    func deleteTerm(term: Term) {
        term.destroy()
    }
}
