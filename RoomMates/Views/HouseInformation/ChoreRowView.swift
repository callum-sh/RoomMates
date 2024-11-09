//
//  ChoreRowView.swift
//  RoomMates
//
//  Created by Jacob Kolyakov on 10/31/24.
//

import SwiftUI

struct ChoreRowView: View {
    @ObservedObject var chore: Chore
    let dateFormatter: DateFormatter
    var onIconTap: (() -> Void)? // Optional closure to handle icon tap
    
    // Helper function for status icon
    private func statusIconName(for status: ChoreStatus) -> String {
        switch status {
        case .overdue:
            return "exclamationmark.circle"
        case .today, .thisWeek:
            return "circle"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
    // Helper function for status color
    private func statusColor(for status: ChoreStatus) -> Color {
        switch status {
        case .overdue:
            return .red
        case .today:
            return .green
        case .thisWeek:
            return .purple
        case .completed:
            return .gray
        }
    }
    
    // Helper function to format the due date
    private func formattedDueDate(for chore: Chore) -> String {
        // Check if the due date is today, tomorrow, or in the future
        let calendar = Calendar.current
        if chore.status == .completed {
            if let completionDate = chore.dateComplete {
                return "Completed, \(dateFormatter.string(from: completionDate))"
            } else {
                return "Completed"
            }
        }
        else if calendar.isDateInToday(chore.dueDate) {
            return "Today, \(dateFormatter.string(from: chore.dueDate))"
        } else if calendar.isDateInTomorrow(chore.dueDate) {
            return "Tomorrow, \(dateFormatter.string(from: chore.dueDate))"
        } else if chore.dueDate < Date() {
            return "Overdue, \(dateFormatter.string(from: chore.dueDate))"
        } else {
            return dateFormatter.string(from: chore.dueDate)
        }
    }
    
    var body: some View {
        HStack {
            // Status Circle Icon with color, clickable if `onIconTap` is provided
            Button(action: {
                onIconTap?()
            }) {
                Image(systemName: statusIconName(for: chore.status))
                    .foregroundColor(statusColor(for: chore.status))
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading) {
                Text(chore.title)
                    .font(.headline)
                
                // Display formatted due date
                Text(formattedDueDate(for: chore))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Right side - clickable area for navigation
            NavigationLink(destination: ChoreDetailsView(chore: chore)) {
                HStack(spacing: 4) {
                    // Tags
                    ForEach(chore.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Prevents any additional styling
        .padding(.vertical, 8)
    }
}
