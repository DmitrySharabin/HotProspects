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
    fileprivate(set) var date = Date.now
}

enum SortOrderType {
    case date, name
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    private let savePath = FileManager.documentDirectory.appendingPathComponent("SavedData")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send() // Order matters!!!
        prospect.isContacted.toggle()
        save()
    }
    
    func sort(by order: SortOrderType) {
        people.sort {
            switch order {
                case .name:
                    return $0.name < $1.name
                case .date:
                    return $0.date > $1.date
            }
        }
    }
}
