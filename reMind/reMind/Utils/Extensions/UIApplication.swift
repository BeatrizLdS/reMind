//
//  UIApplication.swift
//  reMind
//
//  Created by Beatriz Leonel da Silva on 28/01/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
