import SwiftUI

struct AddEditIdeaView: View {
    @ObservedObject var viewModel: IdeaViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let editingIdea: Idea?
    
    @State private var title = ""
    @State private var selectedDate: Date?
    @State private var hasDate = false
    @State private var category: IdeaCategory = .other
    @State private var description = ""
    @State private var status: IdeaStatus = .planned
    
    init(viewModel: IdeaViewModel, editingIdea: Idea? = nil) {
        self.viewModel = viewModel
        self.editingIdea = editingIdea
        
        if let idea = editingIdea {
            _title = State(initialValue: idea.title)
            _selectedDate = State(initialValue: idea.date)
            _hasDate = State(initialValue: idea.date != nil)
            _category = State(initialValue: idea.category)
            _description = State(initialValue: idea.description)
            _status = State(initialValue: idea.status)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfair(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Picnic by the lake", text: $title)
                                .font(.playfair(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Date")
                                    .font(.playfair(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $hasDate)
                                    .toggleStyle(SwitchToggleStyle(tint: AppColors.blueText))
                            }
                            
                            if hasDate {
                                DatePicker("Select date", selection: Binding(
                                    get: { selectedDate ?? Date() },
                                    set: { selectedDate = $0 }
                                ), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .accentColor(AppColors.blueText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.playfair(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(IdeaCategory.allCases, id: \.self) { cat in
                                    Button(action: {
                                        category = cat
                                    }) {
                                        HStack {
                                            Image(systemName: cat.icon)
                                                .font(.system(size: 16))
                                                .foregroundColor(category == cat ? .white : AppColors.blueText)
                                            
                                            Text(cat.rawValue)
                                                .font(.playfair(size: 14, weight: .medium))
                                                .foregroundColor(category == cat ? .white : AppColors.blueText)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            category == cat ?
                                            AppColors.blueText : AppColors.cardBackground
                                        )
                                        .cornerRadius(12)
                                        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.playfair(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $description)
                                .font(.playfair(size: 16))
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 100)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.playfair(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(IdeaStatus.allCases, id: \.self) { stat in
                                    Button(action: {
                                        status = stat
                                    }) {
                                        HStack {
                                            Image(systemName: stat.icon)
                                                .font(.system(size: 14))
                                                .foregroundColor(status == stat ? .white : AppColors.blueText)
                                            
                                            Text(stat.rawValue)
                                                .font(.playfair(size: 14, weight: .medium))
                                                .foregroundColor(status == stat ? .white : AppColors.blueText)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            status == stat ?
                                            AppColors.blueText : AppColors.cardBackground
                                        )
                                        .cornerRadius(12)
                                        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingIdea == nil ? "New Idea" : "Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveIdea()
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
        .onAppear {
            if !hasDate {
                selectedDate = nil
            }
        }
        .onChange(of: hasDate) { newValue in
            if !newValue {
                selectedDate = nil
            } else if selectedDate == nil {
                selectedDate = Date()
            }
        }
    }
    
    private func saveIdea() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        if let editingIdea = editingIdea {
            var updatedIdea = editingIdea
            updatedIdea.title = trimmedTitle
            updatedIdea.date = hasDate ? selectedDate : nil
            updatedIdea.category = category
            updatedIdea.description = description
            updatedIdea.status = status
            
            viewModel.updateIdea(updatedIdea)
        } else {
            let newIdea = Idea(
                title: trimmedTitle,
                date: hasDate ? selectedDate : nil,
                category: category,
                description: description,
                status: status
            )
            
            viewModel.addIdea(newIdea)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditIdeaView(viewModel: IdeaViewModel())
}
