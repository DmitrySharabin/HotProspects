//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Dmitry Sharabin on 11.01.2022.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false

    @State private var isShowingSortOrderSheet = false
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    prospectListRow(for: prospect)
                        .swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                                
                                Button {
                                    addNotification(for: prospect)
                                } label: {
                                    Label("Remind Me", systemImage: "bell")
                                }
                                .tint(.orange)
                            }
                        }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSortOrderSheet = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    .disabled(filteredProspects.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Dmitry Sharabin\ndmitrysharabin@gmail.com", completion: handleScan)
            }
            .confirmationDialog("Sort by", isPresented: $isShowingSortOrderSheet, titleVisibility: .visible) {
                Button("Name") { sortProspects(by: .name) }
                Button("Most Recent") { sortProspects(by: .date) }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted people"
            case .uncontacted:
                return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter { $0.isContacted }
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func sortProspects(by order: SortOrderType) {
        prospects.sort(by: order)
    }
    
    func prospectListRow(for prospect: Prospect) -> some View {
        let icon = prospect.isContacted ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.badge.xmark"
        let color: Color = prospect.isContacted ? .green : .blue
        
        return HStack {
            if filter == .none {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading) {
                Text(prospect.name)
                    .font(.headline)
                
                Text(prospect.emailAddress)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                
                let person = Prospect()
                person.name = details[0]
                person.emailAddress = details[1]
                
                prospects.add(person)
                
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for testing
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
