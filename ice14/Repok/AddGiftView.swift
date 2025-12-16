import SwiftUI

struct AddFirstGiftView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedTab: Int
    
    @State private var title = ""
    @State private var person = ""
    @State private var selectedCategoryId: UUID?
    @State private var note = ""
    @State private var status: Gift.GiftStatus = .planned
    @State private var showingCategoriesManagement = false
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private var navigationTitle: String {
        "New Gift"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("New Gift")
                        .font(.appTitle(28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormFieldView(title: "Gift Name", isRequired: true) {
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
                                
                                Button(action: {
                                    withAnimation {
                                        selectedTab = 1
                                    }
                                }) {
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
                        
                        Button(action: {
                            saveGift()
                        }) {
                            Text("Save")
                                .font(.appHeadline(18))
                                .foregroundColor(AppColors.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppColors.primaryText)
                                .cornerRadius(8)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
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
        selectedCategoryId = dataManager.categories.first?.id
    }
    
    private func resetFields() {
        title = ""
        person = ""
        note = ""
        status = .planned
        selectedCategoryId = dataManager.categories.first?.id
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
        
        let newGift = Gift(
            title: trimmedTitle,
            person: person.trimmingCharacters(in: .whitespacesAndNewlines),
            categoryId: categoryId,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            status: status
        )
        
        dataManager.addGift(newGift)
        resetFields()
        
        withAnimation {
            selectedTab = 0
        }
    }
}
