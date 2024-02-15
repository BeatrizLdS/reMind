//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//

import Foundation

class BoxViewModel: ObservableObject {
    @Published var boxes: [Box] = []
    @Published var numberOfTerms: [Int] = []
    
    private let boxesRepository: FetchBoxRepository

    init(repositoryImplementation: FetchBoxRepository) {
        boxesRepository = repositoryImplementation
        fetchBoxes()
    }
    
    func getCountTermsIn(_ box: Box) -> Int {
        if let index = boxes.firstIndex(of: box) {
            return numberOfTerms[index]
        }
        return 0 
    }
    
    func fetchBoxes() {
        self.boxes = boxesRepository.fetchAll()
        self.numberOfTerms = self.boxes.map { $0.terms?.count ?? 0 }
    }

    func getNumberOfPendingTerms(of box: Box) -> String {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count == 0 ? "" : "\(filteredTerms.count)"
    }
}
