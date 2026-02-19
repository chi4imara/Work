import SwiftUI

struct EditItemView: View {
    let item: GarageItem
    @ObservedObject var viewModel: GarageViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedCategory: ItemCategory
    @State private var location: String
    @State private var condition: String
    @State private var comment: String
    
    init(item: GarageItem, viewModel: GarageViewModel) {
        self.item = item
        self.viewModel = viewModel
        
        _name = State(initialValue: item.name)
        _selectedCategory = State(initialValue: item.category)
        _location = State(initialValue: item.location)
        _condition = State(initialValue: item.condition)
        _comment = State(initialValue: item.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Item")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.white)
                            
                            Text("Update your item information")
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
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        var updatedItem = item
        updatedItem.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.category = selectedCategory
        updatedItem.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.condition = condition.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}
