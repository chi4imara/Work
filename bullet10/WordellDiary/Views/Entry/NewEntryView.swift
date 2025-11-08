import SwiftUI

struct NewEntryView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @Binding var selectedTab: TabItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var selectedMood: Mood = .happy
    @State private var entryText = ""
    @State private var shortTitle = ""
    @State private var showingDatePicker = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var editingEntry: DiaryEntry?
    
    init(viewModel: DiaryViewModel, selectedTab: Binding<TabItem>, editingEntry: DiaryEntry? = nil) {
        self.viewModel = viewModel
        self._selectedTab = selectedTab
        self._editingEntry = State(initialValue: editingEntry)
        
        if let entry = editingEntry {
            self._selectedDate = State(initialValue: entry.date)
            self._selectedMood = State(initialValue: entry.mood)
            self._entryText = State(initialValue: entry.text)
            self._shortTitle = State(initialValue: entry.shortTitle ?? "")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppColors.primaryBlue)
                                    
                                    Text(selectedDate, style: .date)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.darkGray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.darkGray.opacity(0.5))
                                }
                                .padding(16)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.lightPurple, lineWidth: 1)
                                        }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mood")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            HStack(spacing: 16) {
                                ForEach(Mood.allCases, id: \.self) { mood in
                                    MoodButton(
                                        mood: mood,
                                        isSelected: selectedMood == mood,
                                        action: { selectedMood = mood }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Short Title (Optional)")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("Brief description...", text: $shortTitle)
                                .font(AppFonts.body)
                                .padding(16)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.lightPurple, lineWidth: 1)
                                        }
                                }
                                .onChange(of: shortTitle) { newValue in
                                    if newValue.count > 80 {
                                        shortTitle = String(newValue.prefix(80))
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Description")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                Spacer()
                                
                                Text("\(entryText.count)/2000")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                            }
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardGradient)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.lightPurple, lineWidth: 1)
                                    }
                                    .frame(minHeight: 200)
                                
                                if entryText.isEmpty {
                                    Text("Describe today's moment with words...")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.darkGray.opacity(0.5))
                                        .padding(16)
                                }
                                
                                TextEditor(text: $entryText)
                                    .font(AppFonts.body)
                                    .padding(12)
                                    .background(Color.clear)
                                    .onChange(of: entryText) { newValue in
                                        if newValue.count > 2000 {
                                            entryText = String(newValue.prefix(2000))
                                        }
                                    }
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editingEntry == nil ? "Save" : "Update") {
                        saveEntry()
                    }
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(entryText.trimmingCharacters(in: .whitespacesAndNewlines).count < 20 ? .gray : AppColors.primaryBlue)
                    .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).count < 20)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveEntry() {
        let trimmedText = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.count < 20 {
            errorMessage = "Please add a description (at least 20 characters)."
            showingError = true
            return
        }
        
        if selectedDate > Date() {
            errorMessage = "Entry date cannot be in the future."
            showingError = true
            return
        }
        
        if let editingEntry = editingEntry {
            var updatedEntry = editingEntry
            updatedEntry.date = selectedDate
            updatedEntry.mood = selectedMood
            updatedEntry.text = trimmedText
            updatedEntry.shortTitle = shortTitle.isEmpty ? nil : shortTitle
            updatedEntry.updatedAt = Date()
            
            viewModel.addEntry(updatedEntry)
        } else {
            let entry = DiaryEntry(
                date: selectedDate,
                mood: selectedMood,
                text: trimmedText,
                shortTitle: shortTitle.isEmpty ? nil : shortTitle
            )
            
            viewModel.addEntry(entry)
        }
        dismiss()
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryBlue)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(isSelected ? AppColors.primaryBlue : AppColors.lightPurple.opacity(0.3))
                    }
                
                Text(mood.displayName)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray)
                    .fontWeight(isSelected ? .medium : .regular)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    NewEntryView(viewModel: DiaryViewModel(), selectedTab: .constant(.days))
}
