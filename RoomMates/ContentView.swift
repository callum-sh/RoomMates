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
                                ScrollView {
                                    GeometryReader { geometry in
                                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .global).minY)
                                    }
                                    .frame(height: 0) // Set frame height to 0 so it does not affect layout

                                    VStack(alignment: .leading, spacing: 16) {
                                        // Add your sections and content here
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                        // Footer as TabView
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
                                    Text("House Info")
                                }
                        }
                     
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
                    Color(red: 0.96, green: 0.61, blue: 0.27),  // Light orange
                    Color(red: 0.42, green: 0.72, blue: 0.84)   // Soft teal
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(1 - Double(scrollOffset / 150))  // Adjust opacity for a fading effect as you scroll
        )
        .background(.ultraThinMaterial)  // Adds a translucent blur effect similar to Apple Health
    }
}


// PreferenceKey for tracking scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


// Placeholder Views for Tab Items
struct ExpensesView: View {
    var body: some View {
        Text("Expenses View")
            .font(.largeTitle)
            .padding()
    }
}

struct FeedbackView: View {
    var body: some View {
        Text("Feedback View")
            .font(.largeTitle)
            .padding()
    }
}

struct HouseInfoView: View {
    var body: some View {
        Text("House Info View")
            .font(.largeTitle)
            .padding()
    }
}
