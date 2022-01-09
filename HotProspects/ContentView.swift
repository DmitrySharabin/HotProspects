//
//  ContentView.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 09.01.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }
    
    func fetchReadings() async {
//        do {
//            let url = URL(string: "https://hws.dev/readings.json")!
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let readings = try JSONDecoder().decode([Double].self, from: data)
//
//            output = "Found \(readings.count) readings."
//        } catch {
//            print("Download error")
//        }
        
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            
            return "Found \(readings.count) readings."
        }
        
//        fetchTask.cancel()
        
        let result = await fetchTask.result
        
//        do {
//            output = try result.get()
//        } catch {
//            output = "Download error: \(error.localizedDescription)"
//        }
        
        switch result {
            case .success(let str):
                output = str
                
            case .failure(let error):
                output = "Download error: \(error.localizedDescription)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
