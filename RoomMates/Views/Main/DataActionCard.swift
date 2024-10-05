//
//  DataActionCard.swift
//  RoomMates
//
//  Created by callum on 2024-10-04.
//
import SwiftUI

// Health Data Action Card
struct HealthDataActionCard: View {
    var title: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
