import SwiftUI

struct EditEntryView: View {
    let entryId: UUID
    @ObservedObject var viewModel: CareJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedType: CareEntryType
    @State private var name: String
    @State private var selectedDate: Date
    @State private var comment: String
    @State private var showingAlert = false
    
    private var entry: CareEntry? {
        viewModel.getEntry(by: entryId)
    }
    
    init(entryId: UUID, viewModel: CareJournalViewModel) {
        self.entryId = entryId
        self.viewModel = viewModel
        
        if let entry = viewModel.getEntry(by: entryId) {
            self._selectedType = State(initialValue: entry.type)
            self._name = State(initialValue: entry.name)
            self._selectedDate = State(initialValue: entry.date)
            self._comment = State(initialValue: entry.comment)
        } else {
            self._selectedType = State(initialValue: .product)
            self._name = State(initialValue: "")
            self._selectedDate = State(initialValue: Date())
            self._comment = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        typeSelectionView
                        
                        nameInputView
                        
                        datePickerView
                        
                        commentInputView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(AppColors.yellow)
                    .fontWeight(.semibold)
                }
            }
            .alert("Missing Information", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("Name cannot be empty.")
            }
        }
    }
    
    private var typeSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Type")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                ForEach(CareEntryType.allCases, id: \.self) { type in
                    TypeSelectionButton(
                        type: type,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                }
                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var nameInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            TextField(selectedType == .product ? "Product name" : "Procedure name", text: $name)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var datePickerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .accentColor(AppColors.yellow)
                .colorScheme(.dark)
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var commentInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment (Optional)")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Add your thoughts...", text: $comment, axis: .vertical)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
                .lineLimit(3...6)
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private func saveChanges() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              var currentEntry = entry else {
            showingAlert = true
            return
        }
        
        currentEntry.type = selectedType
        currentEntry.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        currentEntry.date = selectedDate
        currentEntry.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateEntry(currentEntry)
        dismiss()
    }
}

#Preview {
    let viewModel = CareJournalViewModel()
    let sampleId = CareEntry.sampleData[0].id
    return EditEntryView(
        entryId: sampleId,
        viewModel: viewModel
    )
}
