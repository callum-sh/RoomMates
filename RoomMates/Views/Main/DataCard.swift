//
//  TestAction.swift
//  RoomMates
//
//  Created by callum on 2024-10-04.
//
import SwiftUI

// Health Data Card
struct HealthDataCard: View {
    var title: String
    var subtitle: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(value)
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
