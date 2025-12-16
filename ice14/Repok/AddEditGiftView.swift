import SwiftUI

struct AddEditGiftView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isPresented: Bool
    
    let gift: Gift?
    
    @State private var title = ""
    @State private var person = ""
    @State private var selectedCategoryId: UUID?
    @State private var note = ""
    @State private var status: Gift.GiftStatus = .planned
    @State private var showingCategoriesManagement = false
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private var isEditing: Bool {
        gift != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Gift" : "New Gift"
    }
    
    init(gift: Gift? = nil, isPresented: Binding<Bool>) {
        self.gift = gift
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormFieldView(title: "Gift Name *", isRequired: true) {
                            TextField("Enter gift name", text: $title)
                                .font(.appBody(16))
                                .foregroundColor(AppColors.secondaryText)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                        }
                        
                        FormFieldView(title: "For Whom") {
                            TextField("Enter person's name", text: $person)
                                .font(.appBody(16))
                                .foregroundColor(AppColors.secondaryText)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                        }
                        
                        FormFieldView(title: "Category") {
                            VStack(spacing: 12) {
                                Menu {
                                    ForEach(dataManager.categories) { category in
                                        Button(action: {
                                            selectedCategoryId = category.id
                                        }) {
                                            HStack {
                                                Image(systemName: category.iconName)
                                                Text(category.name)
                                                if selectedCategoryId == category.id {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if let categoryId = selectedCategoryId,
                                           let category = dataManager.getCategory(for: categoryId) {
                                            Image(systemName: category.iconName)
                                                .foregroundColor(AppColors.primaryPurple)
                                            Text(category.name)
                                                .foregroundColor(AppColors.secondaryText)
                                        } else {
                                            Text("Select category")
                                                .foregroundColor(AppColors.secondaryText.opacity(0.6))
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.secondaryText.opacity(0.6))
                                    }
                                    .font(.appBody(16))
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                                }
                                
                                Button(action: { showingCategoriesManagement = true }) {
                                    Text("Manage Categories")
                                        .font(.appCaption(14))
                                        .foregroundColor(AppColors.primaryPurple)
                                }
                            }
                        }
                        
                        FormFieldView(title: "Note") {
                            TextEditor(text: $note)
                                .font(.appBody(16))
                                .foregroundColor(AppColors.secondaryText)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                                .frame(minHeight: 80)
                        }
                        
                        FormFieldView(title: "Status") {
                            HStack(spacing: 20) {
                                ForEach(Gift.GiftStatus.allCases, id: \.self) { giftStatus in
                                    Button(action: {
                                        status = giftStatus
                                    }) {
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(status == giftStatus ? AppColors.primaryPurple : Color.clear)
                                                .frame(width: 20, height: 20)
                                                .overlay(
                                                    Circle()
                                                        .stroke(AppColors.primaryText, lineWidth: 2)
                                                )
                                            
                                            Text(giftStatus.displayName)
                                                .font(.appBody(16))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGift()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .sheet(isPresented: $showingCategoriesManagement) {
            CategoriesView()
                .environmentObject(dataManager)
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func setupInitialValues() {
        if let gift = gift {
            title = gift.title
            person = gift.person
            selectedCategoryId = gift.categoryId
            note = gift.note
            status = gift.status
        } else {
            selectedCategoryId = dataManager.categories.first?.id
        }
    }
    
    private func saveGift() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            validationMessage = "Please enter a gift name"
            showingValidationError = true
            return
        }
        
        if trimmedTitle.count > 120 {
            validationMessage = "Gift name must be 120 characters or less"
            showingValidationError = true
            return
        }
        
        if person.count > 80 {
            validationMessage = "Person name must be 80 characters or less"
            showingValidationError = true
            return
        }
        
        if note.count > 500 {
            validationMessage = "Note must be 500 characters or less"
            showingValidationError = true
            return
        }
        
        guard let categoryId = selectedCategoryId else {
            validationMessage = "Please select a category"
            showingValidationError = true
            return
        }
        
        if let existingGift = gift {
            var updatedGift = existingGift
            updatedGift.title = trimmedTitle
            updatedGift.person = person.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedGift.categoryId = categoryId
            updatedGift.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedGift.status = status
            
            dataManager.updateGift(updatedGift)
        } else {
            let newGift = Gift(
                title: trimmedTitle,
                person: person.trimmingCharacters(in: .whitespacesAndNewlines),
                categoryId: categoryId,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                status: status
            )
            
            dataManager.addGift(newGift)
        }
        
        isPresented = false
    }
}

struct FormFieldView<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.appHeadline(16))
                    .foregroundColor(AppColors.primaryText)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(AppColors.deleteRed)
                }
                
                Spacer()
            }
            
            content
        }
    }
}

struct AddGiftView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddGift = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 12) {
                    Text("Add New Gift")
                        .font(.appTitle(24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Tap to add a new gift idea")
                        .font(.appBody(16))
                        .foregroundColor(AppColors.primaryText.opacity(0.8))
                }
                
                Button(action: { showingAddGift = true }) {
                    Text("Add Gift")
                        .font(.appHeadline(18))
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(AppColors.primaryText)
                        .cornerRadius(25)
                }
            }
        }
        .sheet(isPresented: $showingAddGift) {
            AddEditGiftView(isPresented: $showingAddGift)
                .environmentObject(dataManager)
        }
        .onAppear {
            showingAddGift = true
        }
    }
}
