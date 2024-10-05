import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var isProfileExpanded = false

    var body: some View {
        NavigationStack {
            VStack {
                // Main Content
                ZStack(alignment: .top) {
                    // Background color to match the fade effect
                    Color(.systemBackground)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 0) {
                        // Header with dynamic opacity and height
                        headerView
                        // ScrollView with GeometryReader to track offset
                    }
                }
                
                // Nav Footer
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
                .navigationDestination(isPresented: $isProfileExpanded) {
                    ProfileView()
                }
                .navigationTitle("RoomMate")
            }
        }
    }
    
    // TODO: move into new file?
    private var headerView: some View {
        VStack {
            if scrollOffset < 100 {
                // Header Content
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
                    Color(red: 0.82, green: 0.82, blue: 0.94),   // Soft teal
                    .gray // gray (believe it or not)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .background(.ultraThinMaterial)
    }
}


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button(action: {
            authViewModel.signOut()
        }) {
            Text("Log Out")
                .frame(maxWidth: 300)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
