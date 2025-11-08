import SwiftUI

struct EditProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var bio: String
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        self._name = State(initialValue: userProfile.name)
        self._bio = State(initialValue: userProfile.bio)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Text("Edit Profile")
                        .font(.ubuntuTitle)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.ubuntuHeadline)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter your name", text: $name)
                                .font(.ubuntuBody)
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.ubuntuHeadline)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Tell us about yourself", text: $bio)
                                .font(.ubuntuBody)
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        userProfile.updateName(name)
                        userProfile.updateBio(bio)
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.primaryPurple, Color.primaryBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    EditProfileView(userProfile: UserProfile())
}

