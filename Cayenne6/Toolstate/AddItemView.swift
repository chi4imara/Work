import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: GarageViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var name = ""
    @State private var selectedCategory: ItemCategory = .tools
    @State private var location = ""
    @State private var condition = ""
    @State private var comment = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Item")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Text("Add a new item to your garage inventory")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Name",
                            text: $name,
                            placeholder: "Enter item name"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(ItemCategory.allCases, id: \.id) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category,
                                            action: {
                                                selectedCategory = category
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        CustomTextField(
                            title: "Storage Location",
                            text: $location,
                            placeholder: "e.g., Shelf #2, Toolbox"
                        )
                        
                        CustomTextField(
                            title: "Condition",
                            text: $condition,
                            placeholder: "e.g., New, Used, Fair"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            TextEditor(text: $comment)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.white)
                                .scrollContentBackground(.hidden)
                                .padding(12)
                                .frame(minHeight: 80)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.separator, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveItem) {
                        Text("Save Item")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveItem() {
        let newItem = GarageItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            condition: condition.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.white)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.white)
                .padding(12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.separator, lineWidth: 1)
                )
        }
    }
}

struct CategoryButton: View {
    let category: ItemCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: categoryIcon(for: category))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.lightBlue)
                
                Text(category.displayName)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.secondaryText)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.lightBlue : AppColors.cardBackground)
            )
        }
    }
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .carCare: return "drop"
        case .spareParts: return "gearshape"
        case .other: return "cube.box"
        }
    }
}
