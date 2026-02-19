import SwiftUI

struct AddJewelryView: View {
    @Environment(\.presentationMode) var presentationMode
    let store: JewelryStore
    
    @State private var name = ""
    @State private var selectedCategory = JewelryCategory.earrings
    @State private var customCategoryName = ""
    @State private var description = ""
    @State private var showingCustomCategory = false
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.bauhausRegular(size: 16))
                            .foregroundColor(AppColors.primaryWhite)
                            
                            Spacer()
                            
                            Text("New Jewelry")
                                .font(.bauhausBold(size: 20))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Spacer()
                            
                            Button("Create") {
                                createJewelry()
                            }
                            .font(.bauhausBold(size: 16))
                            .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.primaryWhite.opacity(0.5))
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Name*", text: $name, placeholder: "Enter jewelry name")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                Menu {
                                    ForEach(JewelryCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category
                                            showingCustomCategory = false
                                        }
                                    }
                                    
                                    Button("Create Category") {
                                        showingCustomCategory = true
                                    }
                                } label: {
                                    HStack {
                                        Text(showingCustomCategory ? "Custom Category" : selectedCategory.displayName)
                                            .font(.bauhausRegular(size: 16))
                                            .foregroundColor(AppColors.darkGray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.darkGray)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                                }
                                
                                if showingCustomCategory {
                                    FormField(title: "", text: $customCategoryName, placeholder: "Enter category name")
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                TextEditor(text: $description)
                                    .font(.bauhausRegular(size: 16))
                                    .padding(12)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.darkGray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                Text("Never worn")
                                    .font(.bauhausRegular(size: 16))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground.opacity(0.7))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func createJewelry() {
        let finalCategory: JewelryCategory
        let finalCustomName: String?
        
        if showingCustomCategory && !customCategoryName.isEmpty {
            store.addCustomCategory(customCategoryName)
            finalCategory = .custom
            finalCustomName = customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            finalCategory = selectedCategory
            finalCustomName = nil
        }
        
        let newItem = JewelryItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: finalCategory,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            customCategoryName: finalCustomName,
            lastWornDate: nil
        )
        
        store.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.bauhausBold(size: 16))
                    .foregroundColor(AppColors.primaryWhite)
            }
            
            TextField(placeholder, text: $text)
                .font(.bauhausRegular(size: 16))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.darkGray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddJewelryView(store: JewelryStore())
}
