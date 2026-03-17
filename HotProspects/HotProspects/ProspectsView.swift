//
//  SwiftUIView.swift
//  HotProspects
//
//  Created by Harsh Virdi on 09/03/26.
//
import CodeScanner
import SwiftUI
import SwiftData
import AVFoundation
import UserNotifications

struct ProspectsView: View {
    enum FilterType{
        case none, contacted, uncontacted
    }
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Prospect.name)]) var prospects: [Prospect]
    @State private var isShowingScanner: Bool = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var editMode: EditMode = .inactive
    @Binding private var sortType: SortTypes
    
    let filter: FilterType
    
    var title: String{
        switch filter {
            case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted"
        }
    }
    
    var body: some View {
        NavigationStack{
            List(prospects, selection: $selectedProspects) {
                prospect in
                if editMode == .inactive {
                    NavigationLink{
                      EditView(prospect: prospect)
                    }
                    label: {
                        prospectRow(prospect)
                    }
                    .tag(prospect)
                }
                
                else {
                    prospectRow(prospect)
                        .tag(prospect)
                }
                
            }
            .environment(\.editMode, $editMode)
            .animation(.default, value: prospects)
                .navigationTitle(title)
                .toolbar{
                    ToolbarItem {
                        Menu{
                            Picker("Sort Order", selection: $sortType) {
                                ForEach(SortTypes.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.2.circlepath.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(editMode.isEditing ? "Done" : "Edit") {
                            withAnimation{
                                editMode = editMode.isEditing ? .inactive : .active
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing ) {
                        Button("Scan", systemImage: "qrcode.viewfinder"){
                            isShowingScanner = true
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if selectedProspects.isEmpty == false && editMode.isEditing {
                        Button("Delete selected items", role: .destructive) {
                            delete()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring, value: selectedProspects)
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr],simulatedData: "Harsh Virdi \n harshvirdi11@gmail.com", completion: handleScan(result: ))
                }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Something breaked: \(error)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects.removeAll()
    }
    
    func addNotification(prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle =  prospect.emailAddress
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
             
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        addRequest()
                    }
                    else if let error {
                        print("Error requesting notification permission: \(error)")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func prospectRow(_ prospect: Prospect) -> some View {
        HStack {
            VStack(alignment: .leading){
                Text(prospect.name)
                    .font(.headline)
                Text(prospect.emailAddress)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if prospect.isContacted {
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                    Text("Contacted")
                }
                .foregroundStyle(.white)
                .padding(5)
                .background(.green)
                .clipShape(.capsule)
            }
        }
        .swipeActions{
            Button("Delete", systemImage: "trash", role: .destructive) {
                modelContext.delete(prospect)
            }
            
            if prospect.isContacted {
                Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                    prospect.isContacted = false
                }
                .tint(.blue)
            }
            
            else {
                Button("Mark contacted", systemImage: "person.crop.circle.badge.checkmark") {
                    prospect.isContacted = true
                }
                .tint(.green)
                
                Button("Remind me", systemImage: "bell"){
                    addNotification(prospect: prospect)
                }
                .tint(.orange)
            }
        }
    }
    
    init(filter: FilterType, sortType: Binding<SortTypes>) {
        self.filter = filter
        _sortType = sortType
        let showAll = (filter == .none)
        let showContactedOnly = (filter == .contacted)
        
        let predicate = #Predicate<Prospect> { prospect in
                showAll ? true : prospect.isContacted == showContactedOnly
            }
        
       let sortDescriptor: SortDescriptor<Prospect>
        if sortType.wrappedValue == .name {
                    sortDescriptor = SortDescriptor(\Prospect.name)
                } else {
                    sortDescriptor = SortDescriptor(\Prospect.dateAdded, order: .reverse)
                }
        _prospects = Query(filter: predicate, sort: [sortDescriptor])
        
    }
    
}

#Preview {
    ProspectsView(filter: .none, sortType: .constant(SortTypes.name))
        .modelContainer(for: Prospect.self)
}
