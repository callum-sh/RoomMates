//
//  HouseInfoView.swift
//  RoomMates
//
//  Created by callum on 2024-10-05.
//
import SwiftUI

struct HouseInfoView: View {
    @ObservedObject var choreList: ChoreList

    init(chores: [Chore]) {
        self.choreList = ChoreList(chores: chores)
    }
    
    // Formatter to display due dates in a user-friendly format
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        NavigationStack {
            List {
                // "Today" Section
                if !choreList.today.isEmpty {
                    Section(header: Text("Today")) {
                        ForEach(choreList.today) { chore in
                            ChoreRowView(chore: chore, dateFormatter: dateFormatter, onIconTap: { choreList.updateChore(chore) })
                        }
                    }
                }
                
                // "This Week" Section
                if !choreList.thisWeek.isEmpty {
                    Section(header: Text("This Week")) {
                        ForEach(choreList.thisWeek) { chore in
                            ChoreRowView(chore: chore, dateFormatter: dateFormatter, onIconTap: { choreList.updateChore(chore) })
                        }
                    }
                }
                
                // "Older" Section
                if !choreList.older.isEmpty {
                    Section(header: Text("Older")) {
                        ForEach(choreList.older) { chore in
                            ChoreRowView(chore: chore, dateFormatter: dateFormatter, onIconTap: { choreList.updateChore(chore) })
                        }
                    }
                }
                
                // "Completed" Section
                if !choreList.completed.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(choreList.completed) { chore in
                            ChoreRowView(chore: chore, dateFormatter: dateFormatter, onIconTap: { choreList.updateChore(chore) }) // No action on completed chores
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Chores")
        }
    }
    
}
