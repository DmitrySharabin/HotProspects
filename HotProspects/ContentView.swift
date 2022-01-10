//
//  ContentView.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 09.01.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        Text("Hello, World!")
            .padding()
            .background(backgroundColor)
        
        Text("Change Color")
            .padding()
            .contextMenu {
//                Button("Red") {
//                    backgroundColor = .red
//                }
                
                Button(role: .destructive) {
                    backgroundColor = .red
                } label: {
                    Label("Red", systemImage: "checkmark.circle.fill")
//                        .foregroundColor(.red)
                }
                
                Button("Green") {
                    backgroundColor = .green
                }
                
                Button("Blue") {
                    backgroundColor = .blue
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
