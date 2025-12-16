import SwiftUI

struct AddItemViewForShopping: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: Category = .outerwear
    @State private var selectedSeason: Season = .spring
    @State private var comment: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter item name", text: $name)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Menu {
                                ForEach(Category.allCases, id: \.rawValue) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Menu {
                                ForEach(Season.allCases, id: \.rawValue) { season in
                                    Button(season.displayName) {
                                        selectedSeason = season
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedSeason.displayName)
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            HStack {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.accentOrange)
                                Text("Buy")
                                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                                    .foregroundColor(.accentOrange)
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentOrange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.accentOrange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add shopping notes (optional)", text: $comment, axis: .vertical)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .lineLimit(3...6)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveItem()
                }
                .disabled(name.isEmpty)
            )
        }
        .alert("Name Required", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please enter a name for the item.")
        }
    }
    
    private func saveItem() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingAlert = true
            return
        }
        
        let newItem = WardrobeItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            season: selectedSeason,
            status: .buy,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}
