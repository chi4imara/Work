import SwiftUI

struct AddHobbyView: View {
    @ObservedObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var hobbyName = ""
    @State private var selectedIcon = "star.fill"
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    var body: some View {
        NavigationView {
            ZStack {
                WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Create New Hobby")
                                .font(FontManager.title)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text("Choose a name and icon for your new hobby")
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hobby Name")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            TextField("Enter hobby name", text: $hobbyName)
                                .font(FontManager.body)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Choose Icon")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(HobbyIcons.availableIcons, id: \.self) { icon in
                                    IconSelectionButton(
                                        icon: icon,
                                        isSelected: selectedIcon == icon
                                    ) {
                                        selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preview")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            HobbyPreviewCard(name: hobbyName.isEmpty ? "Your Hobby" : hobbyName, icon: selectedIcon)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("New Hobby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHobby()
                    }
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.primaryBlue)
                    .disabled(hobbyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveHobby() {
        let trimmedName = hobbyName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a hobby name"
            showingError = true
            return
        }
        
        viewModel.addHobby(name: trimmedName, icon: selectedIcon)
        dismiss()
    }
}

struct IconSelectionButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryBlue.opacity(0.1) : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.secondaryText)
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct HobbyPreviewCard: View {
    let name: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.semibold)
                
                Text("0 sessions • 0m")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                
                ProgressView(value: 0.0)
                    .progressViewStyle(CustomProgressViewStyle())
                    .frame(height: 6)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
}
