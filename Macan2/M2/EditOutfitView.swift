import SwiftUI

struct EditOutfitView: View {
    let outfit: OutfitEntry
    @ObservedObject var viewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date
    @State private var description: String
    @State private var comfort: Double
    @State private var selectedMood: Mood
    @State private var selectedReaction: Reaction
    @State private var notes: String
    @State private var selectedTags: Set<String>
    @State private var newTagName = ""
    @State private var showingNewTagField = false
    
    init(outfit: OutfitEntry, viewModel: OutfitViewModel) {
        self.outfit = outfit
        self.viewModel = viewModel
        
        _selectedDate = State(initialValue: outfit.date)
        _description = State(initialValue: outfit.description)
        _comfort = State(initialValue: Double(outfit.comfort))
        _selectedMood = State(initialValue: outfit.mood)
        _selectedReaction = State(initialValue: outfit.reaction)
        _notes = State(initialValue: outfit.notes)
        _selectedTags = State(initialValue: Set(outfit.tags))
    }
    
    private var canSave: Bool {
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        dateSection
                        
                        descriptionSection
                        
                        comfortSection
                        
                        moodSection
                        
                        reactionSection
                        
                        notesSection
                        
                        tagsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Edit Outfit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(canSave ? ColorManager.primaryText : ColorManager.secondaryText)
                    .disabled(!canSave)
                }
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .font(.playfairDisplay(16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outfit Description *")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            TextField("Describe your outfit", text: $description, axis: .vertical)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
                .lineLimit(3...6)
        }
    }
    
    private var comfortSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Comfort Level")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(Int(comfort))/10")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.accentYellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(ColorManager.accentYellow.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Slider(value: $comfort, in: 1...10, step: 1)
                .accentColor(ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            HStack(spacing: 12) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: mood.icon)
                                .font(.system(size: 24))
                                .foregroundColor(selectedMood == mood ? .white : mood.color)
                            
                            Text(mood.rawValue)
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(selectedMood == mood ? .white : ColorManager.primaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(selectedMood == mood ? mood.color : ColorManager.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var reactionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Others' Reaction")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 8) {
                ForEach(Reaction.allCases, id: \.self) { reaction in
                    Button(action: {
                        selectedReaction = reaction
                    }) {
                        HStack {
                            Circle()
                                .fill(reaction.color)
                                .frame(width: 12, height: 12)
                            
                            Text(reaction.rawValue)
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            if selectedReaction == reaction {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(selectedReaction == reaction ? ColorManager.accentYellow.opacity(0.2) : ColorManager.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            TextField("Additional comments", text: $notes, axis: .vertical)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
                .lineLimit(2...4)
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tags")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Button(action: {
                    showingNewTagField.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
                        .foregroundColor(ColorManager.accentYellow)
                }
            }
            
            if showingNewTagField {
                HStack {
                    TextField("New tag name", text: $newTagName)
                        .font(.playfairDisplay(16))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(ColorManager.cardBackground)
                        .cornerRadius(12)
                    
                    Button("Add") {
                        addNewTag()
                    }
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(ColorManager.primaryText)
                    .cornerRadius(12)
                    .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            
            if !viewModel.tags.isEmpty {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 100), spacing: 8)
                ], spacing: 8) {
                    ForEach(viewModel.tags, id: \.name) { tag in
                        Button(action: {
                            toggleTag(tag.name)
                        }) {
                            Text(tag.name)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(selectedTags.contains(tag.name) ? .white : ColorManager.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(selectedTags.contains(tag.name) ? ColorManager.primaryText : ColorManager.cardBackground)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            if !selectedTags.isEmpty {
                Text("Selected: \(Array(selectedTags).joined(separator: ", "))")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(.top, 4)
            }
        }
    }
    
    private func toggleTag(_ tagName: String) {
        if selectedTags.contains(tagName) {
            selectedTags.remove(tagName)
        } else {
            selectedTags.insert(tagName)
        }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        viewModel.addTag(trimmedName)
        selectedTags.insert(trimmedName)
        newTagName = ""
        showingNewTagField = false
    }
    
    private func saveChanges() {
        var updatedOutfit = outfit
        updatedOutfit.date = selectedDate
        updatedOutfit.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedOutfit.comfort = Int(comfort)
        updatedOutfit.mood = selectedMood
        updatedOutfit.reaction = selectedReaction
        updatedOutfit.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedOutfit.tags = Array(selectedTags)
        
        viewModel.updateOutfit(updatedOutfit)
        dismiss()
    }
}

#Preview {
    EditOutfitView(
        outfit: OutfitEntry(
            date: Date(),
            description: "Black dress with blazer",
            comfort: 8,
            mood: .happy,
            reaction: .positive,
            notes: "Great for office",
            tags: ["office", "black"]
        ),
        viewModel: OutfitViewModel()
    )
}

