import SwiftUI

struct HowItWorksView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("How It Works")
                            .font(.ubuntuTitle)
                            .foregroundColor(.textPrimary)
                            .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("This is a recipe organizer. You can:")
                                .font(.ubuntuBody)
                                .foregroundColor(.textSecondary)
                            
                            FeatureItem(
                                icon: "plus.circle",
                                title: "Add New Recipes",
                                description: "Create recipes with name, category, ingredients, and instructions."
                            )
                            
                            FeatureItem(
                                icon: "pencil",
                                title: "Edit and Delete",
                                description: "Modify existing recipes or remove them when no longer needed."
                            )
                            
                            FeatureItem(
                                icon: "magnifyingglass",
                                title: "Search Recipes",
                                description: "Find recipes by name or ingredients using the search function."
                            )
                            
                            FeatureItem(
                                icon: "list.bullet",
                                title: "Shopping List",
                                description: "Use ingredients as a shopping list by checking off items you've purchased."
                            )
                            
                            FeatureItem(
                                icon: "checkmark.square",
                                title: "Track Progress",
                                description: "Mark ingredients as used while cooking to keep track of your progress."
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primaryPurple)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntuSubheadline)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.ubuntuBody)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HowItWorksView()
}
