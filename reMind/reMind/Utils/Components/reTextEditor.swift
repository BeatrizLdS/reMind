//
//  reTextEditor.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct reTextEditor: View {
    @State var title: String
    @Binding var text: String
    @State var maxSize: Int = 150
    @State var currentSize: Int = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body)
                .fontWeight(.bold)

            VStack {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .onChange(of: text) { newValue in
                        if text.count > maxSize {
                            self.text = String(text.prefix(maxSize))
                            currentSize = maxSize
                        } else {
                            currentSize = text.count
                        }
                    }

                Divider()
                    .background(Palette.label.render.opacity(0.6))

                Text("\(maxSize - currentSize)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(8)
            .frame(height: 200)
            .background(Palette.background.render)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.25) ,radius: 5)
        }
        .padding(.horizontal, 8)
    }
}

struct reTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        reTextEditor(title: "Description", text: .constant("Text"), maxSize: 150)
            .padding()
    }
}
