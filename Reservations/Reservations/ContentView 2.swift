import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.clock")
                    .imageScale(.large)
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                Text("Reservations")
                    .font(.largeTitle).bold()
                Text("Welcome!")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
