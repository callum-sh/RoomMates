//
//  ProfileInfoView.swift
//  RoomMates
//
//  Created by callum on 2024-10-05.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button(action: {
            authViewModel.signOut()
        }) {
            Text("Log Out")
                .frame(maxWidth: 300)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
