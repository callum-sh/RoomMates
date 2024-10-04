import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel = ExpensesViewModel()
    @ObservedObject var householdViewModel = HouseholdViewModel() // Add this line
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
                        Text("Date: \(formatDate(expense.date))")
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
                    Button(action: { showingHouseholdSetup.toggle() }) { // Add this button
                        Image(systemName: "house")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { showingAddExpense = true }) {
                                       Label("Add Expense", systemImage: "plus")
                                   }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                        AddExpenseView(viewModel: viewModel, householdViewModel: householdViewModel)
                    }
            .sheet(isPresented: $showingOverview) {
                MonthlyStatisticsView(viewModel: viewModel, month: Date())
            }
            .sheet(isPresented: $showingDebts) {
                DebtsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingHouseholdSetup) { // Add this sheet
                HouseholdSetupView(viewModel: householdViewModel)
            }
            .sheet(item: $selectedExpense) { expense in
                if let index = viewModel.expenses.firstIndex(where: { $0.id == expense.id }) {
                    EditExpenseView(householdViewModel: householdViewModel, expense: $viewModel.expenses[index])
                }
            }
        }
    }

    private func deleteExpense(at offsets: IndexSet) {
        viewModel.expenses.remove(atOffsets: offsets)
    }
}

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpensesViewModel
    @ObservedObject var householdViewModel: HouseholdViewModel

    @State private var description: String = ""
    @State private var paidByUserID: UUID?
    @State private var amount: Double = 0.0
    @State private var isRecurring: Bool = false
    @State private var splits: [Split] = []
    @State private var date: Date = Date()
    @State private var showValidationError = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Expense")) {
                    TextField("Description", text: $description)

                    Picker("Paid by", selection: $paidByUserID) {
                        ForEach(householdViewModel.household.housemates, id: \.id) { housemate in
                            Text(housemate.name).tag(housemate.id)
                        }
                    }

                    TextField("Amount", value: $amount, formatter: NumberFormatter.currency)
                        .keyboardType(.decimalPad)

                    Toggle(isOn: $isRecurring) {
                        Text("Recurring")
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Split Details")) {
                    ForEach($splits.indices, id: \.self) { index in
                        HStack {
                            Picker("User", selection: $splits[index].userID) {
                                ForEach(householdViewModel.household.housemates, id: \.id) { housemate in
                                    Text(housemate.name).tag(housemate.id)
                                }
                            }

                            TextField("Percentage", value: $splits[index].percentage, formatter: NumberFormatter.percentage)
                                .keyboardType(.decimalPad)
                        }
                    }
                    Button("Add Split") {
                        
                        // Distribute the new percentage among existing splits
                        splits = splits.map { split in
                            let updatedSplit = split
                            return updatedSplit
                        }
                        
                        // Add the new split with the same newPercentage
                        splits.append(Split(userID: householdViewModel.household.housemates.first?.id ?? UUID(), percentage: 0))
                    }

                }

                Button("Add Expense") {
                        let defaultPaidBy: UUID = UUID(uuidString: "defaultUUIDString") ?? UUID()
                        let newExpense = Expense(description: description, amount: amount, paidBy: paidByUserID ?? defaultPaidBy, splits: splits, isRecurring: isRecurring, date: date)
                        viewModel.addExpense(newExpense)
                        dismiss()
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    private var totalPercentage: Double {
        splits.reduce(0) { $0 + $1.percentage }
    }
}




struct HouseholdSetupView: View {
    @ObservedObject var viewModel: HouseholdViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newHousemateName: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Household Info")) {
                    TextField("Household Name", text: $viewModel.household.name)
                    TextField("Address", text: $viewModel.household.address)
                }
                
                Section(header: Text("Housemates")) {
                    ForEach(viewModel.household.housemates, id: \.id) { housemate in
                        Text(housemate.name)
                    }
                    .onDelete(perform: removeHousemate)

                    HStack {
                        TextField("New Housemate Name", text: $newHousemateName)
                        Button(action: {
                            let newHousemate = User(name: newHousemateName)
                            viewModel.addHousemate(newHousemate)
                            newHousemateName = ""
                        }) {
                            Text("Add")
                        }
                        .disabled(newHousemateName.isEmpty)
                    }
                }
            }
            .navigationTitle("Setup Household")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveHousehold()
                        dismiss()  // Add this line to dismiss the view
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()  // Add this line to dismiss the view if needed
                    }
                }
            }
        }
    }
    
    private func removeHousemate(at offsets: IndexSet) {
        viewModel.household.housemates.remove(atOffsets: offsets)
    }
}

struct HouseholdSetupView_Previews: PreviewProvider {
    static var previews: some View {
        HouseholdSetupView(viewModel: HouseholdViewModel())
    }
}

struct EditExpenseView: View {
    @ObservedObject var householdViewModel: HouseholdViewModel
    @Binding var expense: Expense
    
    @Environment(\.dismiss) var dismiss
    
    // Formatter for percentage
    let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.multiplier = 1
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Description", text: $expense.description)
                    TextField("Amount", value: $expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    Toggle(isOn: $expense.isRecurring) {
                        Text("Recurring")
                    }
                    DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                }

                Section(header: Text("Expense Splits")) {
                    ForEach(Array($expense.splits.enumerated()), id: \.element.id) { index, $split in
                        HStack {
                            Picker("User", selection: $split.userID) {
                                ForEach(householdViewModel.household.housemates, id: \.id) { housemate in
                                    Text(housemate.name).tag(housemate.id)
                                }
                            }
                            
                            // TextField to edit the percentage as a string
                            TextField("Percentage", text: Binding<String>(
                                get: {
                                    self.percentageFormatter.string(from: NSNumber(value: split.percentage)) ?? "0%"
                                },
                                set: {
                                    if let value = self.percentageFormatter.number(from: $0)?.doubleValue {
                                        split.percentage = value
                                    }
                                }
                            ))
                            .keyboardType(.decimalPad)
                        }
                    }
                    .onDelete(perform: deleteSplit)
                    
                    Button("Add Split") {
                        let newSplit = Split(userID: UUID(), percentage: 0)
                        expense.splits.append(newSplit)
                    }
                }

                Section {
                    Button("Update") {
                        // Implement the update logic
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    // Function to handle the deletion of splits
    private func deleteSplit(at offsets: IndexSet) {
        expense.splits.remove(atOffsets: offsets)
    }
}



struct BarGraphView: View {
    var userExpenses: [String: Double] // String here is assumed to be user ID
    var userNames: [String: String] // Mapping from user ID to user name
    var maxValue: Double {
        userExpenses.values.max() ?? 0
    }

    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(userExpenses.sorted(by: { $0.value > $1.value }), id: \.key) { userID, value in
                VStack {
                    Text(String(format: "%.2f", value))
                        .font(.caption)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(value / maxValue) * 200)
                    Text(userNames[userID] ?? "Unknown")
                        .font(.caption)
                }
            }
        }
    }
}

                 
struct DebtsView: View {
    @ObservedObject var viewModel: ExpensesViewModel

    var body: some View {
        List {
            ForEach(Array(viewModel.calculateDebts().keys), id: \.self) { owingUser in
                Section(header: Text("\(owingUser) owes:")) {
                    ForEach(Array(viewModel.calculateDebts()[owingUser]!.keys), id: \.self) { paidByUser in
                        let amount = viewModel.calculateDebts()[owingUser]![paidByUser]!
                        let debtKey = "\(owingUser)-\(paidByUser)"
                        let simplifiedAmount = viewModel.calculateSimplifiedDebts()[debtKey] ?? 0
                        
                        HStack {
                            Text(paidByUser)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                    .foregroundColor(.red) // Normal debt in red
                                if simplifiedAmount != 0 {
                                    Text("\(simplifiedAmount > 0 ? "Owes: " : "Owed: ")\(simplifiedAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                        .foregroundColor(simplifiedAmount > 0 ? .green : .blue) // Simplified debt in green or blue
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Debts Overview")
    }
}

                          

struct MonthlyStatisticsView: View {
  @ObservedObject var viewModel: ExpensesViewModel
    @ObservedObject var householdViewModel = HouseholdViewModel()
  var month: Date

  var body: some View {
      ScrollView {
          VStack {
              List {
                  let userNamesDict = viewModel.userNamesDictionary() // Obtain the mapping from your viewModel
                  ForEach(viewModel.userExpenses(for: month).sorted(by: { $0.value > $1.value }), id: \.key) { userID, value in
                      if let userName = userNamesDict[UUID(uuidString: userID) ?? UUID()] { // Convert the string to UUID and lookup the name
                          HStack {
                              Text(userName) // Display the user's name
                              Spacer()
                              Text("\(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                          }
                      }
                  }
              }
              .background(Color.green) // Debugging background
              .frame(height: 300) // Set a fixed height
              .navigationTitle("User Expenses")
              BarGraphView(
                  userExpenses: viewModel.userExpenses(for: month),
                  userNames: householdViewModel.userNamesDictionary
              )
                  .padding()
          }
      }
  }
}

- n 


// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

