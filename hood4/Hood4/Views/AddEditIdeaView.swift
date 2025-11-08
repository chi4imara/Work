import SwiftUI

struct AddEditIdeaView: View {
    @ObservedObject var viewModel: GiftManagerViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingIdea: GiftIdea?
    let preselectedPersonId: UUID?
    
    @State private var selectedPersonId: UUID?
    @State private var title = ""
    @State private var status: GiftStatus = .idea
    @State private var eventType: EventType?
    @State private var eventDate: Date?
    @State private var budgetText = ""
    @State private var store = ""
    @State private var notes = ""
    
    @State private var showingEventDatePicker = false
    @State private var titleError: String?
    @State private var budgetError: String?
    
    private var isEditing: Bool {
        editingIdea != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedPersonId != nil &&
        titleError == nil &&
        budgetError == nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if preselectedPersonId == nil {
                            personSelectionView
                        }
                        
                        titleFieldView
                        
                        statusSelectionView
                        
                        eventTypeSelectionView
                        
                        eventDateView
                        
                        budgetFieldView
                        
                        storeFieldView
                        
                        notesFieldView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Idea" : "New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIdea()
                    }
                    .foregroundColor(canSave ? AppColors.primaryYellow : AppColors.textTertiary)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .sheet(isPresented: $showingEventDatePicker) {
            eventDatePickerSheet
        }
    }
    
    private var personSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Person")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Menu {
                ForEach(viewModel.people) { person in
                    Button(person.name) {
                        selectedPersonId = person.id
                    }
                }
            } label: {
                HStack {
                    if let personId = preselectedPersonId ?? selectedPersonId,
                       let person = viewModel.getPerson(by: personId) {
                        Text(person.name)
                            .foregroundColor(AppColors.textPrimary)
                    } else {
                        Text("Select person")
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                }
                .font(AppFonts.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var titleFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Gift Idea")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Enter gift idea", text: $title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .onChange(of: title) { _ in
                    validateTitle()
                }
            
            if let titleError = titleError {
                Text(titleError)
                    .font(AppFonts.caption1)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var statusSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(GiftStatus.allCases, id: \.self) { giftStatus in
                    Button(action: { status = giftStatus }) {
                        HStack(spacing: 8) {
                            Image(systemName: giftStatus.icon)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(giftStatus.displayName)
                                .font(AppFonts.footnote)
                        }
                        .foregroundColor(status == giftStatus ? AppColors.primaryBlue : AppColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(status == giftStatus ? AppColors.primaryYellow : AppColors.cardBackground)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    private var eventTypeSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Type (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Menu {
                Button("None") {
                    eventType = nil
                }
                
                ForEach(EventType.allCases, id: \.self) { type in
                    Button(type.displayName) {
                        eventType = type
                    }
                }
            } label: {
                HStack {
                    Text(eventType?.displayName ?? "Select event type")
                        .foregroundColor(eventType != nil ? AppColors.textPrimary : AppColors.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                }
                .font(AppFonts.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var eventDateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Event Date (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Button(action: { showingEventDatePicker = true }) {
                HStack {
                    if let eventDate = eventDate {
                        Text(eventDate, style: .date)
                            .foregroundColor(AppColors.textPrimary)
                    } else {
                        Text("Select date")
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    if eventDate != nil {
                        Button(action: { eventDate = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Image(systemName: "calendar")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .font(AppFonts.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var budgetFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Budget (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                Text("$")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("0.00", text: $budgetText)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .onChange(of: budgetText) { _ in
                        validateBudget()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            
            if let budgetError = budgetError {
                Text(budgetError)
                    .font(AppFonts.caption1)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var storeFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Store / Where to Buy (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Enter store name", text: $store)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
    
    private var notesFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Additional notes...", text: $notes, axis: .vertical)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(3...6)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
    
    private var eventDatePickerSheet: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    DatePicker(
                        "Event Date",
                        selection: Binding(
                            get: { eventDate ?? Date() },
                            set: { eventDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingEventDatePicker = false
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingEventDatePicker = false
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .presentationDetents([.height(300)])
    }
    
    private func setupInitialValues() {
        if let editingIdea = editingIdea {
            selectedPersonId = editingIdea.personId
            title = editingIdea.title
            status = editingIdea.status
            eventType = editingIdea.eventType
            eventDate = editingIdea.eventDate
            budgetText = editingIdea.budget != nil ? String(format: "%.2f", editingIdea.budget!) : ""
            store = editingIdea.store ?? ""
            notes = editingIdea.notes ?? ""
        } else if let preselectedPersonId = preselectedPersonId {
            selectedPersonId = preselectedPersonId
        }
    }
    
    private func validateTitle() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty && !title.isEmpty {
            titleError = "Title cannot be empty"
        } else {
            titleError = nil
        }
    }
    
    private func validateBudget() {
        if budgetText.isEmpty {
            budgetError = nil
            return
        }
        
        if let budget = Double(budgetText), budget > 0 {
            budgetError = nil
        } else {
            budgetError = "Budget must be a positive number"
        }
    }
    
    private func saveIdea() {
        guard canSave, let personId = selectedPersonId else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let budget = budgetText.isEmpty ? nil : Double(budgetText)
        let trimmedStore = store.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingIdea = editingIdea {
            var updatedIdea = editingIdea
            updatedIdea.personId = personId
            updatedIdea.title = trimmedTitle
            updatedIdea.status = status
            updatedIdea.eventType = eventType
            updatedIdea.eventDate = eventDate
            updatedIdea.budget = budget
            updatedIdea.store = trimmedStore.isEmpty ? nil : trimmedStore
            updatedIdea.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
            
            viewModel.updateGiftIdea(updatedIdea)
        } else {
            var newIdea = GiftIdea(personId: personId, title: trimmedTitle, status: status)
            newIdea.eventType = eventType
            newIdea.eventDate = eventDate
            newIdea.budget = budget
            newIdea.store = trimmedStore.isEmpty ? nil : trimmedStore
            newIdea.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
            
            viewModel.addGiftIdea(newIdea)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditIdeaView(
        viewModel: GiftManagerViewModel(),
        editingIdea: nil,
        preselectedPersonId: nil
    )
}
