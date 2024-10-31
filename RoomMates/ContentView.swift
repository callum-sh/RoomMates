import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var isProfileExpanded = false

    var body: some View {
        NavigationStack {
            VStack {
                // Header with dynamic opacity and height
                headerView
                
                // Main Content with Tab Navigation
                TabView {
                    ExpensesView()
                        .tabItem {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("Expenses")
                        }
                    
                    FeedbackView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Feedback")
                        }

                    HouseInfoView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Chores")
                        }
                }
                .accentColor(.blue) // Customize tab selection color
            }
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.bottom) // Extend background color under the tab bar
            .navigationDestination(isPresented: $isProfileExpanded) {
                ProfileView()
            }
        }
    }

    // Header view with profile button
    private var headerView: some View {
        VStack {
            if scrollOffset < 100 {
                HStack {
                    Spacer()
                    Button(action: {
                        // Profile picture clicked
                        isProfileExpanded = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.82, green: 0.82, blue: 0.94),
                    .gray
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .background(.ultraThinMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
