import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: Category = .outerwear
    @State private var selectedSeason: Season = .spring
    @State private var selectedStatus: ItemStatus = .inUse
    @State private var comment: String = ""
    @State private var showingAlert = false
    
    var isEditing: Bool = false
    var editingItem: WardrobeItem?
    
    init(viewModel: WardrobeViewModel, editingItem: WardrobeItem? = nil) {
        self.viewModel = viewModel
        self.editingItem = editingItem
        self.isEditing = editingItem != nil
        
        if let item = editingItem {
            _name = State(initialValue: item.name)
            _selectedCategory = State(initialValue: item.category)
            _selectedSeason = State(initialValue: item.season)
            _selectedStatus = State(initialValue: item.status)
            _comment = State(initialValue: item.comment)
        }
    }
    
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
                            
                            HStack(spacing: 12) {
                                ForEach(ItemStatus.allCases, id: \.rawValue) { status in
                                    StatusButton(
                                        status: status,
                                        isSelected: selectedStatus == status
                                    ) {
                                        selectedStatus = status
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add a comment (optional)", text: $comment, axis: .vertical)
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
            .navigationTitle(isEditing ? "Edit Item" : "New Item")
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
        
        if isEditing, let editingItem = editingItem {
            var updatedItem = editingItem
            updatedItem.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedItem.category = selectedCategory
            updatedItem.season = selectedSeason
            updatedItem.status = selectedStatus
            updatedItem.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateItem(updatedItem)
        } else {
            let newItem = WardrobeItem(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                season: selectedSeason,
                status: selectedStatus,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addItem(newItem)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct StatusButton: View {
    let status: ItemStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(status.displayName)
                .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .textOnDark : statusColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? statusColor : statusColor.opacity(0.1))
                        .shadow(color: AppShadows.cardShadow, radius: isSelected ? 3 : 1, x: 0, y: 1)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var statusColor: Color {
        switch status {
        case .inUse:
            return .accentGreen
        case .store:
            return .primaryBlue
        case .buy:
            return .accentOrange
        }
    }
}
