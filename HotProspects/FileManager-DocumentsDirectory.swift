//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 14.01.2022.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
