//
//  Prospect.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 11.01.2022.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send() // Order matters!!!
        prospect.isContacted.toggle()
    }
}
