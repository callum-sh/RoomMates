//
//  ChoreDetailsView.swift
//  RoomMates
//
//  Created by Jacob Kolyakov on 10/31/24.
//
import SwiftUI

struct ChoreDetailsView: View {
    let chore: Chore
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(chore.title)
                .font(.largeTitle)
                .bold()
            
            Text("Due Date: \(chore.dueDate, formatter: DateFormatter())")
                .font(.headline)
            
            Text("Status: \(String(describing: chore.status))")
                .font(.headline)
            
            ForEach(chore.tags, id: \.self) { tag in
                Text(tag)
                    .font(.subheadline)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
            }
            
            Spacer()
        }
        .padding()
    }
}
