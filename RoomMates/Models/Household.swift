//
//  Household.swift
//  RoomMates
//
//  Created by callum on 2024-10-04.
//

import Foundation
import SwiftUI
import Combine

class Chore: Identifiable, ObservableObject {
    let id = UUID()
    let title: String
    let dueDate: Date
    @Published var status: ChoreStatus
    let tags: [String]
    @Published var lastStatus: ChoreStatus?
    @Published var dateComplete: Date?
    
    init(title: String, dueDate: Date, status: ChoreStatus, tags: [String], lastStatus: ChoreStatus? = nil, dateComplete: Date? = nil) {
        self.title = title
        self.dueDate = dueDate
        self.status = status
        self.tags = tags
        self.lastStatus = lastStatus
        self.dateComplete = dateComplete
    }
}

class ChoreList: ObservableObject {
    @Published var chores: [Chore]
    @Published var today: [Chore] = []
    @Published var thisWeek: [Chore] = []
    @Published var older: [Chore] = []
    @Published var completed: [Chore] = []
    
    init(chores: [Chore]) {
        self.chores = chores
        filterChores()
    }
    
    private func filterThisWeekChores() -> [Chore] {
        let today = Calendar.current
        return self.chores.filter {
            !today.isDateInToday($0.dueDate) &&
            $0.dueDate < today.date(byAdding: .day, value: 7, to: Date())! &&
            $0.status != .completed
        }
    }
    
    private func filterOlderChores() -> [Chore] {
        let today = Calendar.current
        return self.chores.filter { $0.dueDate < Date() && $0.dueDate >= today.date(byAdding: .day, value: 7, to: Date())!
            && !today.isDateInToday($0.dueDate) && $0.status != .completed }
    }
    
    private func filterCompletedChores() -> [Chore]{
        return self.chores.filter { $0.status == .completed}
    }
    
    
    private func filterTodayChores() -> [Chore] {
        let today = Calendar.current
        return self.chores.filter { $0.status != .completed && today.isDateInToday($0.dueDate) && $0.status != .completed}
    }
    
    func filterChores() {
        today = filterTodayChores()
        thisWeek = filterThisWeekChores()
        older = filterOlderChores()
        completed = filterCompletedChores()
    }
    
    
    func updateChore(_ chore: Chore) {
        if let index = chores.firstIndex(where: { $0.id == chore.id }) {
            if (chores[index].status == .completed){
                chores[index].status = chores[index].lastStatus ?? .today
            }
            else{
                chores[index].lastStatus = chores[index].status
                chores[index].status = .completed
                
            }
            filterChores()
        }
    }
}

enum ChoreStatus {
    case overdue, today, thisWeek, completed
}
