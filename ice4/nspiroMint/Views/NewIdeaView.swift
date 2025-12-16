import SwiftUI

struct NewIdeaView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedHobby: HobbyCategory = .drawing
    @State private var ideaTitle = ""
    @State private var ideaDescription = ""
    @State private var mood = ""
    @State private var selectedDate = Date()
    
    var editingIdea: HobbyIdea?
    
    init(viewModel: HobbyIdeaViewModel, editingIdea: HobbyIdea? = nil) {
        self.viewModel = viewModel
        self.editingIdea = editingIdea
        
        if let idea = editingIdea {
            _selectedHobby = State(initialValue: idea.hobby)
            _ideaTitle = State(initialValue: idea.title)
            _ideaDescription = State(initialValue: idea.description)
            _mood = State(initialValue: idea.mood)
            _selectedDate = State(initialValue: idea.dateCreated)
        }
    }
    
    private var isFormValid: Bool {
        !ideaTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !ideaDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !mood.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text(editingIdea != nil ? "Edit Idea" : "New Idea")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Hobby Category")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Menu {
                                    ForEach(HobbyCategory.allCases, id: \.self) { category in
                                        Button(action: { selectedHobby = category }) {
                                            HStack {
                                                Image(systemName: category.icon)
                                                Text(category.displayName)
                                                if selectedHobby == category {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: selectedHobby.icon)
                                            .foregroundColor(AppColors.primaryYellow)
                                        Text(selectedHobby.displayName)
                                            .foregroundColor(AppColors.primaryText)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite.opacity(0.2))
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Idea / Theme")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Enter your creative idea...", text: $ideaTitle)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite.opacity(0.2))
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextEditor(text: $ideaDescription)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 100)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite.opacity(0.2))
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mood / Association")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("e.g., Relaxation, Energy, Focus...", text: $mood)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite.opacity(0.2))
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .colorInvert()
                                    .accentColor(AppColors.primaryYellow)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite.opacity(0.2))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Text("Cancel")
                                    .font(.playfairDisplay(18, weight: .semibold))
                                    .foregroundColor(AppColors.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppColors.secondaryText, lineWidth: 2)
                                    )
                            }
                            
                            Button(action: saveIdea) {
                                Text("Save")
                                    .font(.playfairDisplay(18, weight: .semibold))
                                    .foregroundColor(AppColors.buttonText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(isFormValid ? AppColors.buttonBackground : AppColors.disabledButton)
                                    )
                            }
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveIdea() {
        let trimmedTitle = ideaTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = ideaDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMood = mood.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingIdea = editingIdea {
            var updatedIdea = editingIdea
            updatedIdea.hobby = selectedHobby
            updatedIdea.title = trimmedTitle
            updatedIdea.description = trimmedDescription
            updatedIdea.mood = trimmedMood
            updatedIdea.dateCreated = selectedDate
            
            viewModel.updateIdea(updatedIdea)
        } else {
            let newIdea = HobbyIdea(
                hobby: selectedHobby,
                title: trimmedTitle,
                description: trimmedDescription,
                mood: trimmedMood,
                dateCreated: selectedDate
            )
            
            viewModel.addIdea(newIdea)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NewIdeaView(viewModel: HobbyIdeaViewModel())
}
