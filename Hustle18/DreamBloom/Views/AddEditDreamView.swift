import SwiftUI

struct AddEditDreamView: View {
    @ObservedObject var dreamStore: DreamStore
    @Environment(\.dismiss) private var dismiss
    
    let dreamToEdit: Dream?
    
    @State private var selectedDate = Date()
    @State private var description = ""
    @State private var selectedTags: Set<String> = []
    @State private var newTagText = ""
    @State private var showingNewTagField = false
    @State private var showingDatePicker = false
    @State private var showingSaveConfirmation = false
    
    private let characterLimit = 1000
    
    init(dreamStore: DreamStore, dreamToEdit: Dream? = nil) {
        self.dreamStore = dreamStore
        self.dreamToEdit = dreamToEdit
        
        if let dream = dreamToEdit {
            self._selectedDate = State(initialValue: dream.date)
            self._description = State(initialValue: dream.description)
            self._selectedTags = State(initialValue: Set(dream.tags))
        }
    }
    
    private var isFormValid: Bool {
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedDate <= Date()
    }
    
    private var remainingCharacters: Int {
        characterLimit - description.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Dream Date")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Text(selectedDate, style: .date)
                                        .font(.dreamBody)
                                        .foregroundColor(.dreamWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(.dreamYellow)
                                }
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.dreamWhite.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Dream Description")
                                    .font(.dreamHeadline)
                                    .foregroundColor(.dreamWhite)
                                
                                Spacer()
                                
                                Text("\(remainingCharacters)")
                                    .font(.dreamCaption)
                                    .foregroundColor(remainingCharacters < 50 ? .red : .dreamWhite.opacity(0.6))
                            }
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.dreamWhite.opacity(0.2), lineWidth: 1)
                                    )
                                    .frame(minHeight: 120)
                                
                                if description.isEmpty {
                                    Text("Describe your dream in detail...")
                                        .font(.dreamBody)
                                        .foregroundColor(.dreamWhite.opacity(0.5))
                                        .padding(12)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.dreamBody)
                                    .foregroundColor(.dreamWhite)
                                    .padding(8)
                                    .background(Color.clear)
                                    .onChange(of: description) { newValue in
                                        if newValue.count > characterLimit {
                                            description = String(newValue.prefix(characterLimit))
                                        }
                                    }
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(.dreamHeadline)
                                .foregroundColor(.dreamWhite)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(dreamStore.allTags, id: \.id) { tag in
                                    SelectableTagView(
                                        tag: tag.name,
                                        isSelected: selectedTags.contains(tag.name)
                                    ) {
                                        if selectedTags.contains(tag.name) {
                                            selectedTags.remove(tag.name)
                                        } else {
                                            selectedTags.insert(tag.name)
                                        }
                                    }
                                }
                            }
                            
                            if showingNewTagField {
                                HStack {
                                    TextField("Enter new tag", text: $newTagText)
                                        .font(.dreamBody)
                                        .foregroundColor(.dreamWhite)
                                        .padding(12)
                                        .background(Color.cardBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.dreamWhite.opacity(0.2), lineWidth: 1)
                                        )
                                    
                                    Button("Add") {
                                        addCustomTag()
                                    }
                                    .font(.dreamBody)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.dreamYellow)
                                    .cornerRadius(8)
                                    .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    
                                    Button("Cancel") {
                                        showingNewTagField = false
                                        newTagText = ""
                                    }
                                    .font(.dreamBody)
                                    .foregroundColor(.dreamWhite.opacity(0.7))
                                }
                            } else {
                                Button(action: { showingNewTagField = true }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.dreamYellow)
                                        
                                        Text("Add Custom Tag")
                                            .font(.dreamBody)
                                            .foregroundColor(.dreamYellow)
                                    }
                                    .padding(12)
                                    .background(Color.cardBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.dreamYellow.opacity(0.5), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(dreamToEdit == nil ? "New Dream" : "Edit Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.dreamWhite.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDream()
                    }
                    .foregroundColor(.dreamYellow)
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .alert("Dream Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your dream has been saved successfully.")
        }
    }
    
    private func addCustomTag() {
        let trimmedTag = newTagText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if !trimmedTag.isEmpty {
            dreamStore.addCustomTag(trimmedTag)
            selectedTags.insert(trimmedTag)
            newTagText = ""
            showingNewTagField = false
        }
    }
    
    private func saveDream() {
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingDream = dreamToEdit {
            var updatedDream = existingDream
            updatedDream.date = selectedDate
            updatedDream.description = trimmedDescription
            updatedDream.tags = Array(selectedTags)
            dreamStore.updateDream(updatedDream)
        } else {
            let newDream = Dream(
                date: selectedDate,
                description: trimmedDescription,
                tags: Array(selectedTags)
            )
            dreamStore.addDream(newDream)
        }
        
        showingSaveConfirmation = true
    }
}

struct SelectableTagView: View {
    let tag: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .dreamYellow : .dreamWhite.opacity(0.6))
                
                Text(tag.capitalized)
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
            }
            .padding(12)
            .background(isSelected ? Color.tagColor(for: tag).opacity(0.3) : Color.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.tagColor(for: tag) : Color.dreamWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.dreamYellow)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AddEditDreamView(dreamStore: DreamStore())
}
