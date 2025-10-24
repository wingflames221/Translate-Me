//
//  ProfileView.swift
//  Translate Me
//
//  Created by shaun amoah on 10/24/25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var email: String
    @Environment(\.dismiss) var dismiss
    @State private var tempEmail: String = ""
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("Email")
                            .foregroundColor(.gray)
                        Spacer()
                        TextField("Enter email", text: $tempEmail)
                            .multilineTextAlignment(.trailing)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                    }
                }
                
                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("1.0")
                    }
                    
                    HStack {
                        Text("Build")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("1")
                    }
                }
                
                Section {
                    Button(action: {
                        saveEmail()
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Changes")
                                .font(.system(size: 17, weight: .semibold))
                            Spacer()
                        }
                    }
                    .disabled(tempEmail.isEmpty)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Profile Updated", isPresented: $showingSaveConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your email has been updated successfully.")
            }
        }
        .onAppear {
            tempEmail = email
        }
    }
    
    private func saveEmail() {
        email = tempEmail
        UserDefaults.standard.set(tempEmail, forKey: "userEmail")
        showingSaveConfirmation = true
    }
}
