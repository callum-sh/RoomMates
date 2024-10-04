import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = ExpensesViewModel()
    @ObservedObject var householdViewModel = HouseholdViewModel()
    @State private var showingAddExpense = false
    @State private var showingOverview = false
    @State private var showingDebts = false
    @State private var showingHouseholdSetup = false
    @State private var selectedExpense: Expense?

    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.expenses) { $expense in
                    VStack(alignment: .leading) {
                        Text(expense.description).font(.headline)
                        Text("Amount: \(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    }
                    .onTapGesture {
                        selectedExpense = expense
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: { showingDebts = true }) {
                        Label("View Debts", systemImage: "dollarsign.circle")
                    }
                    Button(action: { showingOverview = true }) {
                        Label("Overview", systemImage: "chart.bar")
                    }
                    Button(action: { showingHouseholdSetup.toggle() }) {
                        Image(systemName: "house")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Label("Add Expense", systemImage: "plus")
                    }
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingOverview) {
                // MonthlyStatisticsView(viewModel: viewModel, month: Date())
            }
        }
    }

    private func deleteExpense(at offsets: IndexSet) {
        viewModel.expenses.remove(atOffsets: offsets)
    }
}
