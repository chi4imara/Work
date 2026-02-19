import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: WishViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedType: WishType = .want
    @State private var entryText: String = ""
    @State private var selectedCategoryId: UUID?
    @FocusState private var isTextFieldFocused: Bool
    
    private var uncategorizedCategoryId: UUID? {
        viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id
    }
    
    init(viewModel: WishViewModel) {
        self.viewModel = viewModel
        self._selectedCategoryId = State(initialValue: viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Entry")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Capture your desire or refusal")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Type")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        HStack(spacing: 12) {
                            ForEach(WishType.allCases, id: \.self) { type in
                                TypeSelectorButton(
                                    type: type,
                                    isSelected: selectedType == type
                                ) {
                                    selectedType = type
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.categories) { category in
                                    CategorySelectorButton(
                                        title: category.name,
                                        isSelected: selectedCategoryId == category.id || (selectedCategoryId == nil && category.name == "Uncategorized"),
                                        color: category.color.color
                                    ) {
                                        selectedCategoryId = category.id
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                        .padding(.horizontal, -20)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextEditor(text: $entryText)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                isTextFieldFocused ? AppColors.primaryPurple : AppColors.cardBorder,
                                                lineWidth: isTextFieldFocused ? 2 : 1
                                            )
                                    )
                            )
                            .frame(minHeight: 120)
                    }
                    
                    Spacer()
                    
                    Button(action: saveEntry) {
                        Text("Save")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.secondaryText : AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.disabledButton : AppColors.buttonBackground)
                            )
                    }
                    .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .font(.ubuntu(16))
                }
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    private func saveEntry() {
        let trimmedText = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let categoryId = selectedCategoryId ?? viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id
        let newEntry = WishEntry(type: selectedType, text: trimmedText, categoryId: categoryId)
        viewModel.addEntry(newEntry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditEntryView: View {
    @ObservedObject var viewModel: WishViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let entryId: UUID
    @State private var selectedType: WishType
    @State private var entryText: String
    @State private var selectedCategoryId: UUID?
    @FocusState private var isTextFieldFocused: Bool
    
    private var entry: WishEntry? {
        viewModel.getEntry(by: entryId)
    }
    
    init(viewModel: WishViewModel, entryId: UUID) {
        self.viewModel = viewModel
        self.entryId = entryId
        if let entry = viewModel.getEntry(by: entryId) {
            self._selectedType = State(initialValue: entry.type)
            self._entryText = State(initialValue: entry.text)
            let categoryId = entry.categoryId ?? viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id
            self._selectedCategoryId = State(initialValue: categoryId)
        } else {
            self._selectedType = State(initialValue: .want)
            self._entryText = State(initialValue: "")
            self._selectedCategoryId = State(initialValue: viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Edit Entry")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Update your desire or refusal")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Type")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        HStack(spacing: 12) {
                            ForEach(WishType.allCases, id: \.self) { type in
                                TypeSelectorButton(
                                    type: type,
                                    isSelected: selectedType == type
                                ) {
                                    selectedType = type
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.categories) { category in
                                    CategorySelectorButton(
                                        title: category.name,
                                        isSelected: selectedCategoryId == category.id || (selectedCategoryId == nil && category.name == "Uncategorized"),
                                        color: category.color.color
                                    ) {
                                        selectedCategoryId = category.id
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                        .padding(.horizontal, -20)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextEditor(text: $entryText)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .scrollContentBackground(.hidden)
                            .focused($isTextFieldFocused)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                isTextFieldFocused ? AppColors.primaryPurple : AppColors.cardBorder,
                                                lineWidth: isTextFieldFocused ? 2 : 1
                                            )
                                    )
                            )
                            .frame(minHeight: 120)
                    }
                    
                    Spacer()
                    
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.secondaryText : AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.disabledButton : AppColors.buttonBackground)
                            )
                    }
                    .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .font(.ubuntu(16))
                }
            }
        }
    }
    
    private func saveChanges() {
        let trimmedText = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty, var currentEntry = viewModel.getEntry(by: entryId) else { return }
        
        let categoryId = selectedCategoryId ?? viewModel.categories.first(where: { $0.name == "Uncategorized" })?.id
        currentEntry.update(type: selectedType, text: trimmedText, categoryId: categoryId)
        viewModel.updateEntry(currentEntry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct TypeSelectorButton: View {
    let type: WishType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(type == .want ? AppColors.wantColor : AppColors.dontWantColor)
                    .frame(width: 12, height: 12)
                
                Text(type.displayName)
                    .font(.ubuntu(16, weight: isSelected ? .medium : .regular))
                    .foregroundColor(AppColors.primaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.primaryText.opacity(0.2) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ? AppColors.primaryText.opacity(0.5) : AppColors.cardBorder,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategorySelectorButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                Text(title)
                    .font(.ubuntu(14, weight: isSelected ? .medium : .regular))
                    .foregroundColor(AppColors.primaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.primaryText.opacity(0.2) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? AppColors.primaryText.opacity(0.5) : AppColors.cardBorder,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
