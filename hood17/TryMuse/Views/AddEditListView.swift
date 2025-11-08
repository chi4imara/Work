import SwiftUI

struct AddEditListView: View {
    @ObservedObject var viewModel: ListViewModel
    let listToEdit: ListModel?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var listName = ""
    @State private var selectedCategory: ListCategory = .movies
    
    private var isEditing: Bool {
        listToEdit != nil
    }
    
    private var isFormValid: Bool {
        !listName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.appBody)
                        .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit List" : "New List")
                            .font(.appNavTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveList()
                        }
                        .font(.appButton)
                        .foregroundColor(isFormValid ? AppColors.yellow : AppColors.secondaryText)
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("List Name")
                                .font(.appHeadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter list name", text: $listName)
                                .font(.appBody)
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.appHeadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(ListCategory.allCases, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.appBody)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: saveList) {
                            Text("Save List")
                                .font(.appButton)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? AppColors.yellow : AppColors.secondaryText.opacity(0.3))
                                .cornerRadius(25)
                                .shadow(color: isFormValid ? AppColors.yellow.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!isFormValid)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let list = listToEdit {
                listName = list.name
                selectedCategory = list.category
            }
        }
    }
    
    private func saveList() {
        let trimmedName = listName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingList = listToEdit {
            var updatedList = existingList
            updatedList.name = trimmedName
            updatedList.category = selectedCategory
            viewModel.updateList(updatedList)
        } else {
            let newList = ListModel(name: trimmedName, category: selectedCategory)
            viewModel.addList(newList)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditListView(viewModel: ListViewModel(), listToEdit: nil)
}
