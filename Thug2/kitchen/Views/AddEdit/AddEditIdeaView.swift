import SwiftUI

struct AddEditIdeaView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    let ideaToEdit: InteriorIdea?
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var selectedCategory: InteriorIdea.Category = .livingRoom
    @State private var note: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingCategoryPicker = false
    
    private var isEditing: Bool {
        ideaToEdit != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    HStack {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                        .disabled(true)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Idea" : "New Idea")
                            .font(AppFonts.title2())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Divider()
                        .overlay {
                            Color.white
                        }
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Idea Title *")
                                    .font(AppFonts.subheadline())
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Enter idea title", text: $title)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(AppFonts.subheadline())
                                    .foregroundColor(AppColors.primaryText)
                                
                                Button(action: { showingCategoryPicker = true }) {
                                    HStack {
                                        Text(selectedCategory.rawValue)
                                            .font(AppFonts.body())
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(AppFonts.subheadline())
                                    .foregroundColor(AppColors.primaryText)
                                
                                ZStack(alignment: .topLeading) {
                                    if note.isEmpty {
                                        Text("Enter your idea details...")
                                            .font(AppFonts.body())
                                            .foregroundColor(AppColors.tertiaryText)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 16)
                                    }
                                    
                                    TextEditor(text: $note)
                                        .font(AppFonts.body())
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(12)
                                        .background(Color.clear)
                                        .frame(minHeight: 120)
                                        .scrollContentBackground(.hidden)
                                }
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Add to Favorites")
                                        .font(AppFonts.subheadline())
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("Mark this idea as favorite")
                                        .font(AppFonts.caption())
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(CustomToggleStyle())
                            }
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            
                            
                            HStack(spacing: 16) {
                                Button(action: { dismiss() }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Cancel")
                                            .font(AppFonts.button())
                                    }
                                    .foregroundColor(AppColors.primaryOrange)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primaryOrange.opacity(0.1))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppColors.primaryOrange, lineWidth: 2)
                                    )
                                }
                                
                                Button(action: saveIdea) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Save")
                                            .font(AppFonts.button())
                                    }
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(canSave ? AnyShapeStyle(AppGradients.buttonGradient) : AnyShapeStyle(AppColors.cardBackground))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(canSave ? Color.clear : AppColors.cardBorder, lineWidth: 1)
                                    )
                                }
                                .disabled(!canSave)
                                .opacity(canSave ? 1.0 : 0.6)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 10)
                    }
                }
                
            
            }
        }
        .onAppear {
            if let idea = ideaToEdit {
                title = idea.title
                selectedCategory = idea.category
                note = idea.note
                isFavorite = idea.isFavorite
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
    }
    
    private func saveIdea() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        if let existingIdea = ideaToEdit {
            var updatedIdea = existingIdea
            updatedIdea.title = trimmedTitle
            updatedIdea.category = selectedCategory
            updatedIdea.note = note
            updatedIdea.isFavorite = isFavorite
            viewModel.updateIdea(updatedIdea)
        } else {
            let newIdea = InteriorIdea(
                title: trimmedTitle,
                category: selectedCategory,
                note: note,
                isFavorite: isFavorite
            )
            viewModel.addIdea(newIdea)
        }
        
        dismiss()
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: InteriorIdea.Category
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                    .disabled(true)
                    .opacity(0)
                    
                    Spacer()
                    
                    Text("Select Category")
                        .font(AppFonts.title1(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                }
                .padding()
                
                Divider()
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Color.white
                    }
                
                ForEach(InteriorIdea.Category.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        dismiss()
                    }) {
                        HStack {
                            Text(category.rawValue)
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryOrange)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.white
                        }
                }
                Spacer()
            }
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? AppColors.primaryOrange : AppColors.cardBackground)
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(AppColors.primaryWhite)
                            .frame(width: 26, height: 26)
                            .offset(x: configuration.isOn ? 10 : -10)
                            .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    AddEditIdeaView(viewModel: InteriorIdeasViewModel(), ideaToEdit: nil)
}
