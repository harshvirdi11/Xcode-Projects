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

struct ProspectsView: View {
    enum FilterType{
        case none, contacted, unContacted
    }
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Prospect.name)]) var prospects: [Prospect]
    @State private var isShowingScanner: Bool = false
    @State private var selectedProspects = Set<Prospect>()
    @State private var editMode: EditMode = .inactive
    
    let filter: FilterType
    
    var title: String{
        switch filter {
            case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .unContacted:
            return "Uncontacted"
        }
    }
    
    var body: some View {
        NavigationStack{
            List(prospects, selection: $selectedProspects) {
                prospect in
                VStack(alignment: .leading){
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
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
                    }
                }
                .tag(prospect)
            }
            .environment(\.editMode, $editMode)
            .animation(.default, value: prospects)
                .navigationTitle(title)
                .toolbar{
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
    
    init(filter: FilterType) {
        self.filter = filter
        if filter != .none {
            let showcontactedOnly = filter == .contacted
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showcontactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
    
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
