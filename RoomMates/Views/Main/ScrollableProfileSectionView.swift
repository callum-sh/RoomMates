import SwiftUI

struct ScrollableProfileSectionView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("Section 1").font(.headline)) {
                        Text("Item 1")
                        Text("Item 2")
                    }

                    Section(header: Text("Section 2").font(.headline)) {
                        Text("Item 3")
                        Text("Item 4")
                    }

                    // Add more sections as needed
                }
                .padding()
            }

            // Log Out
            Button(action: {
                authViewModel.signOut()
            }) {
                Text("Log Out")
//                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.red)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableProfileSectionView()
    }
}
