import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(filter: #Predicate<Medicine> { $0.remaining <= 5 }, sort: \Medicine.name) var lowStockMedicines: [Medicine]
    @Query var allMedicines: [Medicine] // Used to show total active prescriptions
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header Profile Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, Harsh")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Here is your daily health summary.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                    }
                    .padding()
                    // This creates a sleek, modern iOS gradient
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.cyan]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Stats Row
                    HStack(spacing: 15) {
                        StatCard(title: "Active Meds", value: "\(allMedicines.count)", icon: "pill.fill", color: .blue)
                        StatCard(title: "Low Stock", value: "\(lowStockMedicines.count)", icon: "exclamationmark.triangle.fill", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Low Stock Action Cards
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Action Required")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if lowStockMedicines.isEmpty {
                            VStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                    .padding(.bottom, 5)
                                Text("All medicines are fully stocked.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(Color(.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                            .padding(.horizontal)
                        } else {
                            ForEach(lowStockMedicines) { medicine in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(medicine.name)
                                            .font(.headline)
                                        Text("\(medicine.remaining) units remaining")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.red)
                                    }
                                    Spacer()
                                    Button(action: {
                                        // Refill logic can go here later
                                    }) {
                                        Text("Refill")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.red.opacity(0.1))
                                            .foregroundColor(.red)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Dashboard")
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Medicine.self, DoseLog.self], inMemory: true)
}
