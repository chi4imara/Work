import SwiftUI

struct AddEditEventView: View {
    @ObservedObject var eventStore: EventStore
    let eventToEdit: Event?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var selectedType: EventType = .birthday
    @State private var selectedDate = Date()
    @State private var note = ""
    @State private var giftIdeas: [String] = []
    @State private var isFavorite = false
    
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    @State private var titleError = ""
    @State private var hasChanges = false
    
    private var isEditing: Bool {
        eventToEdit != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Event" : "New Event"
    }
    
    init(eventStore: EventStore, eventToEdit: Event? = nil) {
        self.eventStore = eventStore
        self.eventToEdit = eventToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        TitleFieldSection(
                            title: $title,
                            titleError: $titleError,
                            hasChanges: $hasChanges
                        )
                        
                        EventTypeSection(
                            selectedType: $selectedType,
                            hasChanges: $hasChanges
                        )
                        
                        DateSelectionSection(
                            selectedDate: $selectedDate,
                            hasChanges: $hasChanges
                        )
                        
                        NoteFieldSection(
                            note: $note,
                            hasChanges: $hasChanges
                        )
                        
                        GiftIdeasInputSection(
                            giftIdeas: $giftIdeas,
                            hasChanges: $hasChanges
                        )
                        
                        FavoriteToggleSection(
                            isFavorite: $isFavorite,
                            hasChanges: $hasChanges
                        )
                        
                        if isEditing {
                            DeleteEventSection(showingDeleteAlert: $showingDeleteAlert)
                        }
                        
                        Spacer(minLength: 100)
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
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.accent)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            loadEventData()
        }
        .alert("Discard Changes", isPresented: $showingDiscardAlert) {
            Button("Keep Editing", role: .cancel) { }
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to discard your changes?")
        }
        .alert("Delete Event", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let event = eventToEdit {
                    eventStore.archiveEvent(event)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("This event will be permanently removed from all lists. This action cannot be undone.")
        }
    }
    
    private func loadEventData() {
        if let event = eventToEdit {
            title = event.title
            selectedType = event.type
            selectedDate = event.date
            note = event.note
            giftIdeas = event.giftIdeas
            isFavorite = event.isFavorite
        }
    }
    
    private func saveEvent() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            titleError = "Please enter a title"
            return
        }
        
        titleError = ""
        
        if let existingEvent = eventToEdit {
            let updatedEvent = Event(
                title: trimmedTitle,
                type: selectedType,
                date: selectedDate,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                giftIdeas: giftIdeas.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                isFavorite: isFavorite,
                isActive: existingEvent.isActive
            )
            
            if let index = eventStore.events.firstIndex(where: { $0.id == existingEvent.id }) {
                eventStore.events[index] = Event(
                    title: updatedEvent.title,
                    type: updatedEvent.type,
                    date: updatedEvent.date,
                    note: updatedEvent.note,
                    giftIdeas: updatedEvent.giftIdeas,
                    isFavorite: updatedEvent.isFavorite,
                    isActive: updatedEvent.isActive
                )
                eventStore.saveEvents()
            }
        } else {
            let newEvent = Event(
                title: trimmedTitle,
                type: selectedType,
                date: selectedDate,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                giftIdeas: giftIdeas.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                isFavorite: isFavorite
            )
            
            eventStore.addEvent(newEvent)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct TitleFieldSection: View {
    @Binding var title: String
    @Binding var titleError: String
    @Binding var hasChanges: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Title")
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Enter event title", text: $title)
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(titleError.isEmpty ? Color.clear : AppColors.error, lineWidth: 1)
                        )
                )
                .onChange(of: title) { _ in
                    hasChanges = true
                    titleError = ""
                }
            
            if !titleError.isEmpty {
                Text(titleError)
                    .font(FontManager.small)
                    .foregroundColor(AppColors.error)
            }
        }
    }
}

struct EventTypeSection: View {
    @Binding var selectedType: EventType
    @Binding var hasChanges: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Event Type")
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(EventType.allCases, id: \.self) { eventType in
                    EventTypeButton(
                        eventType: eventType,
                        isSelected: selectedType == eventType
                    ) {
                        selectedType = eventType
                        hasChanges = true
                    }
                }
            }
        }
    }
}

struct EventTypeButton: View {
    let eventType: EventType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: eventType.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.background : AppColors.accent)
                
                Text(eventType.displayName)
                    .font(FontManager.poppinsRegular(size: 10))
                    .foregroundColor(isSelected ? AppColors.background : AppColors.primaryText)
                
                Spacer()
            }
            .padding(16)
            .frame(width: 160, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.accent : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.accent.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DateSelectionSection: View {
    @Binding var selectedDate: Date
    @Binding var hasChanges: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(AppColors.accent)
                .colorScheme(.dark)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
                .onChange(of: selectedDate) { _ in
                    hasChanges = true
                }
        }
    }
}

struct NoteFieldSection: View {
    @Binding var note: String
    @Binding var hasChanges: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Note (Optional)")
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            ZStack(alignment: .topLeading) {
                if note.isEmpty {
                    Text("Add a note about this event...")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                
                TextEditor(text: $note)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(minHeight: 100)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .onChange(of: note) { _ in
                        hasChanges = true
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct GiftIdeasInputSection: View {
    @Binding var giftIdeas: [String]
    @Binding var hasChanges: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Gift Ideas (Optional)")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: addGiftIdea) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            if giftIdeas.isEmpty {
                Text("No gift ideas added yet")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText.opacity(0.5))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                    )
            } else {
                ForEach(Array(giftIdeas.enumerated()), id: \.offset) { index, idea in
                    HStack(spacing: 12) {
                        TextField("Gift idea", text: Binding(
                            get: { giftIdeas[index] },
                            set: { 
                                giftIdeas[index] = $0
                                hasChanges = true
                            }
                        ))
                        .font(FontManager.body)
                        .foregroundColor(AppColors.primaryText)
                        
                        Button(action: { removeGiftIdea(at: index) }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.error)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                    )
                }
            }
        }
    }
    
    private func addGiftIdea() {
        giftIdeas.append("")
        hasChanges = true
    }
    
    private func removeGiftIdea(at index: Int) {
        giftIdeas.remove(at: index)
        hasChanges = true
    }
}

struct FavoriteToggleSection: View {
    @Binding var isFavorite: Bool
    @Binding var hasChanges: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Add to Favorites")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Mark this event as favorite for quick access")
                    .font(FontManager.small)
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isFavorite)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
                .onChange(of: isFavorite) { _ in
                    hasChanges = true
                }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct DeleteEventSection: View {
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        Button(action: { showingDeleteAlert = true }) {
            HStack {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Delete Event")
                    .font(FontManager.subheadline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColors.error)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddEditEventView(eventStore: EventStore())
}
