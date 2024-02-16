//
//  SwipperModel.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 15/02/24.
//

import Foundation

class SwipperModel: ObservableObject {
    @Published var termsInReview: SwipeReview
    @Published var currentTerm: Term
    
    var rightTerms: [Term] = []
    var leftTerms: [Term] = []
    
    init(terms: [Term]) {
        let today = Date()
        let filteredTerms = terms.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }
        
        self.termsInReview = SwipeReview(termsToReview: filteredTerms)
        
        self.currentTerm = filteredTerms[0]
    }
    
    private func nextSpacedRepetitionSystem(after current: SpacedRepetitionSystem) -> SpacedRepetitionSystem? {
        guard let index = SpacedRepetitionSystem.allCases.firstIndex(of: current),
              index +  1 < SpacedRepetitionSystem.allCases.count else {
            return nil
        }
        return SpacedRepetitionSystem.allCases[index +  1]
    }
    
    
    func addToRight() {
        if let nextSrs = nextSpacedRepetitionSystem(after: currentTerm.srs) {
            currentTerm.rawSRS = Int16(nextSrs.rawValue)
        }
        rightTerms.append(currentTerm)
        termsInReview.termsToReview.removeAll(where: {$0 == currentTerm})
        termsInReview.termsReviewed.append(currentTerm)
        currentTerm = termsInReview.termsToReview[0]
    }
    
    func addToLeft() {
        leftTerms.append(currentTerm)
        termsInReview.termsToReview.removeAll(where: {$0 == currentTerm})
        termsInReview.termsReviewed.append(currentTerm)
        currentTerm = termsInReview.termsToReview[0]
    }
}
