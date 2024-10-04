import SwiftUI

struct Expense: Identifiable {
    let id = UUID()
    var description: String
    var amount: Double
    var paidBy: UUID
    var splits: [Split]
    var isRecurring: Bool
    var date: Date
}

struct Split: Identifiable, Hashable {
    var id = UUID()
    var userID: UUID
    var percentage: Double
}


class ExpensesViewModel: ObservableObject {
    @Published var expenses: [Expense] = []

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func calculateSimplifiedDebts() -> [String: Double] {
        var debts = [String: Double]()
        let allDebts = calculateDebts()

        for (ower, debtDetails) in allDebts {
            for (lender, amount) in debtDetails {
                let debtKey = "\(ower)-\(lender)"
                let inverseDebtKey = "\(lender)-\(ower)"

                if var existingDebt = debts[debtKey] {
                    existingDebt -= amount
                    debts[debtKey] = existingDebt
                } else if var existingDebt = debts[inverseDebtKey] {
                    existingDebt += amount
                    debts[inverseDebtKey] = existingDebt
                } else {
                    debts[debtKey] = amount
                }
            }
        }

        // Filter out zero or negative debts
        let simplifiedDebts = debts.filter { $0.value > 0 }

        return simplifiedDebts
    }

    
    func calculateDebts() -> [String: [String: Double]] {
        var debts: [String: [String: Double]] = [:]

        for expense in expenses {
            let totalAmount = expense.amount
            let paidByUser = expense.paidBy

            for split in expense.splits {
                let owingUser = split.userID.uuidString // Convert UUID to String
                let owedAmount = totalAmount * (split.percentage)

                let paidByUserString = paidByUser.uuidString // Convert UUID to String

                if owingUser != paidByUserString {
                    debts[owingUser, default: [:]][paidByUserString, default: 0] += owedAmount
                }
            }
        }

        return debts
    }

    func expenses(in month: Date) -> [Expense] {
        let calendar = Calendar.current
        return expenses.filter { calendar.isDate($0.date, equalTo: month, toGranularity: .month) }
    }
    
    func userExpenses(for month: Date) -> [String: Double] {
            var userExpenses: [String: Double] = [:]

            let monthlyExpenses = expenses(in: month)
        for expense in monthlyExpenses {
            for split in expense.splits {
                let userShare = expense.amount * (split.percentage)
                let userIDString = split.userID.uuidString // Convert UUID to String
                userExpenses[userIDString, default: 0] += userShare
            }
        }


            return userExpenses
        }
}

class HouseholdViewModel: ObservableObject {
    @Published var household: Household {
        didSet {
            saveHousehold()
        }
    }

    
    func saveHousehold() {
        if let encoded = try? JSONEncoder().encode(household) {
            UserDefaults.standard.set(encoded, forKey: "HouseholdData")
        }
    }
    
    func loadHousehold() {
        if let savedHousehold = UserDefaults.standard.object(forKey: "HouseholdData") as? Data,
           let loadedHousehold = try? JSONDecoder().decode(Household.self, from: savedHousehold) {
            household = loadedHousehold
        }
    }
    
    init() {
        // Attempt to load the household from UserDefaults
        if let savedHousehold = UserDefaults.standard.object(forKey: "HouseholdData") as? Data,
           let loadedHousehold = try? JSONDecoder().decode(Household.self, from: savedHousehold) {
            self.household = loadedHousehold
        } else {
            // If there is no saved data, initialize a new empty Household
            self.household = Household(name: "", address: "")
        }
    }
    
}

struct Household: Codable {
    var name: String
    var address: String
}


