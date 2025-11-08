import SwiftUI

struct QuickAddEntry: View {
    @ObservedObject var viewModel: ScentDiaryViewModel
    @State private var name: String = ""
    @State private var selectedCategory: String = ""
    @State private var customCategory: String = ""
    @State private var associations: String = ""
    @State private var showingCustomCategoryField = false
    @State private var showingNameError = false
    @State private var showingPreview = false
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Add New Entry")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.top)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Scent Name")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Coffee scent", text: $name)
                                .font(AppFonts.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(showingNameError ? AppColors.destructiveButton : Color.clear, lineWidth: 1)
                                        }
                                )
                            
                            if showingNameError {
                                Text("Enter scent name")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.destructiveButton)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(category) {
                                        selectedCategory = category
                                        showingCustomCategoryField = false
                                    }
                                }
                                
                                Button("Custom Category") {
                                    showingCustomCategoryField = true
                                    selectedCategory = ""
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.isEmpty ? (showingCustomCategoryField ? "Custom Category" : "Select category") : selectedCategory)
                                        .font(AppFonts.body)
                                        .foregroundColor(selectedCategory.isEmpty && !showingCustomCategoryField ? AppColors.lightText : AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(AppColors.lightText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                            }
                            
                            if showingCustomCategoryField {
                                TextField("Enter custom category", text: $customCategory)
                                    .font(AppFonts.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Associations and Emotions")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .frame(minHeight: 120)
                                
                                if associations.isEmpty {
                                    Text("e.g., The smell of fresh bread reminded me of childhood mornings. Warmth, comfort and peace.")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.lightText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                                
                                TextEditor(text: $associations)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(associations.count)/\(AppConstants.Limits.maxAssociationsLength)")
                                    .font(AppFonts.caption)
                                    .foregroundColor(associations.count > AppConstants.Limits.maxAssociationsLength ? AppColors.destructiveButton : AppColors.lightText)
                            }
                        }
                        
                        if !name.isEmpty {
                            HStack {
                                Text("Preview Card")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                            }
                                
                                ScentEntryCard(entry: ScentEntry(
                                    name: name,
                                    category: showingCustomCategoryField ? customCategory : selectedCategory,
                                    associations: associations
                                ))
                        }
                        
                        Button(action: saveEntry) {
                            Text("Save Entry")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(name.isEmpty ? AppColors.lightText : AppColors.buttonBackground)
                                )
                        }
                        .disabled(name.isEmpty)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .onChange(of: associations) { newValue in
            if newValue.count > AppConstants.Limits.maxAssociationsLength {
                associations = String(newValue.prefix(AppConstants.Limits.maxAssociationsLength))
            }
        }
    }
    
    private func saveEntry() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingNameError = true
            return
        }
        
        showingNameError = false
        
        let finalCategory: String
        if showingCustomCategoryField && !customCategory.isEmpty {
            finalCategory = customCategory
            viewModel.addCategory(customCategory)
        } else {
            finalCategory = selectedCategory
        }
        
        let newEntry = ScentEntry(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: finalCategory,
            associations: associations.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        viewModel.addEntry(newEntry)
        
        resetFields()
    }
    
    private func resetFields() {
        name = ""
        selectedCategory = ""
        customCategory = ""
        associations = ""
        showingCustomCategoryField = false
        showingNameError = false
    }
}
