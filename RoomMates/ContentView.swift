import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var isProfileExpanded = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with dynamic opacity and height
                headerView
                    .frame(height: UIScreen.main.bounds.height * 0.075) // Set height to 7.5% of the screen
                
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
                    
                    HouseInfoView(chores: sampleChores)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Chores")
                        }
                }
                .frame(maxHeight: .infinity)
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
                    Text("Summary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
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
    // Sample data for ChoresView
    private var sampleChores: [Chore] {
        [
            Chore(title: "Pack lunch for school", dueDate: Date().addingTimeInterval(-86400), status: .overdue, tags: ["RB"]),
            Chore(title: "Catch the bus", dueDate: Date(), status: .today, tags: ["RE", "JY"]),
            Chore(title: "Write in journal", dueDate: Date().addingTimeInterval(3600), status: .today, tags: ["RE"]),
            Chore(title: "Take out trash", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, status: .thisWeek, tags: ["RE", "JY"]),
            Chore(title: "Finish essay", dueDate: Date().addingTimeInterval(-172800), status: .completed, tags: ["RB"])
        ]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
