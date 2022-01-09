//
//  ContentView.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 09.01.2022.
//

import SwiftUI

@MainActor class DelayedUpdater: ObservableObject {
//    @Published var value = 0
    
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @StateObject var updater = DelayedUpdater()
    
    var body: some View {
        Text("Value is: \(updater.value)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
