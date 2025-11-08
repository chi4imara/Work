import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    @ObservedObject private var recipeViewModel = RecipeViewModel.shared
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Settings")
                        .font(AppFonts.titleLarge)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 16) {
                            settingsSection(title: "Legal", icon: "doc.text") {
                                SettingsRow(
                                    title: "Terms and Conditions",
                                    icon: "doc.plaintext",
                                    action: { openURL("https://docs.google.com/document/d/1iWe7oOGPvs_DMObazsb0TIvscXnlCU08AdjyKe6g6aw/edit?usp=sharing") }
                                )
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised",
                                    action: { openURL("https://docs.google.com/document/d/1hp018cliQhZvpzf20mn87lOs_GvZFxaY1VbNs7MNTdQ/edit?usp=sharing") }
                                )
                            }
                            
                            settingsSection(title: "Support", icon: "questionmark.circle") {
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: { openURL("https://forms.gle/dWmH5WBi4mWq7GSPA") }
                                )
                                
                                SettingsRow(
                                    title: "Rate the App",
                                    icon: "star",
                                    action: { requestAppReview() }
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryPurple, Color.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "book.closed")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text("Daily Love Bites")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("Your Personal Recipe Library")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func settingsSection<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryPurple)
                
                Text(title)
                    .font(AppFonts.titleSmall)
                    .foregroundColor(.white)
            }
            
            content()
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func addTestRecipe() {
        let testRecipe = Recipe(
            name: "Test Recipe \(Date().timeIntervalSince1970)",
            servings: 2,
            cookingTime: 30,
            difficulty: .easy,
            tags: ["test"],
            ingredients: [Ingredient(quantity: "1 cup", name: "test ingredient")],
            steps: [CookingStep(description: "Test step")],
            isFavorite: false
        )
        recipeViewModel.addRecipe(testRecipe)
        print("🧪 Added test recipe: \(testRecipe.name)")
    }
    
    private func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "SavedRecipes")
        UserDefaults.standard.removeObject(forKey: "SavedTags")
        UserDefaults.standard.removeObject(forKey: "hasCreatedSampleData")
        UserDefaults.standard.synchronize()
        print("🗑️ Cleared all data from UserDefaults")
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryPurple)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.darkGray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
        }
    }
}

#Preview {
    SettingsView()
}
