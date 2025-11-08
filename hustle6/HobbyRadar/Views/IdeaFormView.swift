import SwiftUI

struct IdeaFormView: View {
    @StateObject private var viewModel: IdeaFormViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingUnsavedChangesAlert = false
    @State private var showingDeleteConfirmation = false
    @State private var showingDuplicateWarning = false
    
    init(idea: Idea? = nil) {
        _viewModel = StateObject(wrappedValue: IdeaFormViewModel(idea: idea))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        
                        Divider()
                            .padding(.horizontal, -10)
                        
                        categorySection
                        
                        Divider()
                            .padding(.horizontal, -10)
                        
                        descriptionSection
                        
                        Divider()
                            .padding(.horizontal, -10)
                        
                        sourceSection
                        
                        if viewModel.isEditing {
                            actionButtonsSection
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Idea" : "New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        handleCancelAction()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        handleSaveAction()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingCategoryCreation) {
            CategoryCreationView(viewModel: viewModel)
        }
        .alert("Unsaved Changes", isPresented: $showingUnsavedChangesAlert) {
            Button("Save", role: .none) {
                if viewModel.saveIdea() {
                    dismiss()
                }
            }
            Button("Don't Save", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Would you like to save them before leaving?")
        }
        .alert("Delete Idea", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if viewModel.deleteIdea() {
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .alert("Similar Idea Found", isPresented: $showingDuplicateWarning) {
            Button("Save Anyway") {
                if viewModel.saveIdea() {
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("An idea with a similar title already exists. Would you like to save this idea anyway?")
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                
                Text("Idea Title *")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            TextField("Enter your idea...", text: $viewModel.title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(
                    ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    viewModel.errorMessage.contains("title") ? AppColors.error : Color.clear,
                                    lineWidth: 1
                                )
                        }
                )
            
            if viewModel.errorMessage.contains("title") {
                Text(viewModel.errorMessage)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.error)
            }
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                
                Text("Category *")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Menu {
                ForEach(viewModel.availableCategories, id: \.id) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                    }) {
                        HStack {
                            Text(category.name)
                            if viewModel.selectedCategory?.id == category.id {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Divider()
                
                Button(action: {
                    viewModel.showingCategoryCreation = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create New Category...")
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCategory?.name ?? "Select Category")
                        .font(AppFonts.body)
                        .foregroundColor(viewModel.selectedCategory != nil ? AppColors.primaryText : AppColors.secondaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
            }
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Text("Description")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                Spacer()
                Spacer()
                
                Text("\(viewModel.description.count)/300")
                    .font(AppFonts.caption1)
                    .foregroundColor(viewModel.description.count > 300 ? AppColors.error : AppColors.lightText)
            }
            
            TextField("Add a description (optional)...", text: $viewModel.description, axis: .vertical)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(4...8)
                .padding(16)
                .background(
                    ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    viewModel.description.count > 300 ? AppColors.error : Color.clear,
                                    lineWidth: 1
                                )
                        }
                )
            
            if viewModel.description.count > 300 {
                Text("Description is too long. Please keep it under 300 characters.")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.error)
            }
        }
    }
    
    private var sourceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                
                Text("Source")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            TextField("e.g., Book title, website, etc. (optional)", text: $viewModel.source)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Idea")
                        .font(AppFonts.buttonTitle)
                }
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppColors.error, lineWidth: 2)
                )
            }
        }
    }
    
    private func handleCancelAction() {
        if viewModel.hasUnsavedChanges {
            showingUnsavedChangesAlert = true
        } else {
            dismiss()
        }
    }
    
    private func handleSaveAction() {
        if viewModel.checkForDuplicateTitle() {
            showingDuplicateWarning = true
        } else {
            if viewModel.saveIdea() {
                dismiss()
            }
        }
    }
}

struct CategoryCreationView: View {
    @ObservedObject var viewModel: IdeaFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack {
                        Button("Cancel") {
                            viewModel.newCategoryName = ""
                            viewModel.errorMessage = ""
                            dismiss()
                        }
                        
                        Spacer()
                        
                        Text("New Category")
                            .font(AppFonts.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button("Create") {
                            if viewModel.createNewCategory() {
                                dismiss()
                            }
                        }
                        .disabled(viewModel.newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Enter category name...", text: $viewModel.newCategoryName)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryText)
                            .padding(16)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.errorMessage.contains("Category") ? AppColors.error : Color.clear,
                                            lineWidth: 1
                                        )
                                }
                            )
                        
                        if viewModel.errorMessage.contains("Category") {
                            Text(viewModel.errorMessage)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.error)
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    IdeaFormView()
}
