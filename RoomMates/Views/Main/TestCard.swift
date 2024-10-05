//
//  Test.swift
//  RoomMates
//
//  Created by callum on 2024-10-04.
//
import SwiftUI

// Health Data Highlight Card
struct HealthDataHighlightCard: View {
    var title: String
    var description: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
