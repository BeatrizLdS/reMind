//
//  reMindApp.swift
//  reMind
//
//  Created by Pedro Sousa on 23/06/23.
//

import SwiftUI

@main
struct reMindApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @State var alertError = AlertError()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BoxesView(viewModel: 
                            BoxViewModel(
                                repositoryImplementation:
                                    BoxRepository()
                            )
                )
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .background:
                    let saveSuccessful = CoreDataStack.shared.saveContext()
                    if !saveSuccessful {
                        alertError.showAlert = true
                        alertError.errorMessage = "Could not save the new box. Please try again; if the issue persists, report the problem."
                    }
                default:
                    break
                }
            }
            .alert(isPresented: $alertError.showAlert) {
                Alert(title: Text("Error!"), message: Text(alertError.errorMessage))
            }
        }
    }
}
