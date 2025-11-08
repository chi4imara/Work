import SwiftUI

struct AddEditDreamView: View {
    let dream: Dream?
    let onSave: (Dream) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var dreamDate = Date()
    @State private var description = ""
    @State private var expectedEvent = ""
    @State private var checkDeadline = Date()
    @State private var selectedTags: Set<String> = []
    @State private var newTagName = ""
    @State private var status: DreamStatus = .waiting
    @State private var outcomeDate: Date?
    @State private var outcomeComment = ""
    
    @State private var showingTagInput = false
    @State private var titleCharacterCount = 0
    @State private var eventCharacterCount = 0
    
    private let titleLimit = 80
    private let eventLimit = 140
    
    private var isEditing: Bool { dream != nil }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !expectedEvent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        checkDeadline >= dreamDate &&
        (status == .waiting || outcomeDate != nil)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    cancelButton
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Dream" : "New Dream")
                        .font(AppFonts.callout.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    saveButton
                }
                .padding()
                
                formContent
            }
        }
        .alert("Add New Tag", isPresented: $showingTagInput) {
            TextField("Tag name", text: $newTagName)
            Button("Add") {
                addNewTag()
            }
            Button("Cancel", role: .cancel) {
                newTagName = ""
            }
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var formContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                titleSection
                dreamDateSection
                descriptionSection
                expectedEventSection
                checkDeadlineSection
                tagsSection
                statusSection
                if status != .waiting {
                    outcomeDetailsSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var titleSection: some View {
        FormSection(title: "Dream Title") {
            VStack(alignment: .trailing, spacing: 4) {
                titleTextField
                titleCharacterCountText
            }
        }
    }
    
    private var titleTextField: some View {
        TextField("Enter dream title", text: $title)
            .font(AppFonts.regular(16))
            .foregroundColor(AppColors.primaryText)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.cardBackground)
            )
            .onChange(of: title) { newValue in
                if newValue.count > titleLimit {
                    title = String(newValue.prefix(titleLimit))
                }
                titleCharacterCount = title.count
            }
    }
    
    private var titleCharacterCountText: some View {
        Text("\(titleCharacterCount)/\(titleLimit)")
            .font(AppFonts.regular(12))
            .foregroundColor(titleCharacterCount > Int(Double(titleLimit) * 0.9) ? AppColors.red : AppColors.secondaryText)
    }
    
    private var dreamDateSection: some View {
        FormSection(title: "Dream Date") {
            DatePicker("", selection: $dreamDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .foregroundColor(AppColors.primaryText)
                .colorInvert()
        }
    }
    
    private var descriptionSection: some View {
        FormSection(title: "Description (Optional)") {
            TextField("Describe your dream in detail", text: $description, axis: .vertical)
                .font(AppFonts.regular(16))
                .foregroundColor(AppColors.primaryText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.cardBackground)
                )
                .lineLimit(4...8)
        }
    }
    
    private var expectedEventSection: some View {
        FormSection(title: "Expected Event") {
            VStack(alignment: .trailing, spacing: 4) {
                expectedEventTextField
                eventCharacterCountText
            }
        }
    }
    
    private var expectedEventTextField: some View {
        TextField("What do you expect to happen?", text: $expectedEvent, axis: .vertical)
            .font(AppFonts.regular(16))
            .foregroundColor(AppColors.primaryText)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.cardBackground)
            )
            .lineLimit(2...4)
            .onChange(of: expectedEvent) { newValue in
                if newValue.count > eventLimit {
                    expectedEvent = String(newValue.prefix(eventLimit))
                }
                eventCharacterCount = expectedEvent.count
            }
    }
    
    private var eventCharacterCountText: some View {
        Text("\(eventCharacterCount)/\(eventLimit)")
            .font(AppFonts.regular(12))
            .foregroundColor(eventCharacterCount > Int(Double(eventLimit) * 0.9) ? AppColors.red : AppColors.secondaryText)
    }
    
    private var checkDeadlineSection: some View {
        FormSection(title: "Check Deadline") {
            DatePicker("", selection: $checkDeadline, in: dreamDate..., displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .foregroundColor(AppColors.primaryText)
                .colorInvert()
        }
    }
    
    private var tagsSection: some View {
        FormSection(title: "Tags") {
            VStack(spacing: 12) {
                selectedTagsGrid
                availableTagsGrid
                addTagButton
            }
        }
    }
    
    private var selectedTagsGrid: some View {
        Group {
            if !selectedTags.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                    ForEach(Array(selectedTags), id: \.self) { tag in
                        TagChip(tag: tag, isSelected: true) {
                            selectedTags.remove(tag)
                        }
                    }
                }
            }
        }
    }
    
    private var availableTagsGrid: some View {
        Group {
            let availableTags = DataManager.shared.tags.map { $0.name }.filter { !selectedTags.contains($0) }
            if !availableTags.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                    ForEach(availableTags, id: \.self) { tag in
                        TagChip(tag: tag, isSelected: false) {
                            selectedTags.insert(tag)
                        }
                    }
                }
            }
        }
    }
    
    private var addTagButton: some View {
        Button(action: { showingTagInput = true }) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .medium))
                Text("Add Tag")
                    .font(AppFonts.medium(14))
            }
            .foregroundColor(AppColors.yellow)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppColors.yellow, lineWidth: 1)
            )
        }
    }
    
    private var statusSection: some View {
        FormSection(title: "Status") {
            VStack(spacing: 12) {
                ForEach(DreamStatus.allCases, id: \.self) { dreamStatus in
                    StatusOption(
                        status: dreamStatus,
                        isSelected: status == dreamStatus
                    ) {
                        status = dreamStatus
                        if dreamStatus == .waiting {
                            outcomeDate = nil
                        } else if outcomeDate == nil {
                            outcomeDate = Date()
                        }
                    }
                }
            }
        }
    }
    
    private var outcomeDetailsSection: some View {
        FormSection(title: "Outcome Details") {
            VStack(spacing: 16) {
                outcomeDatePicker
                outcomeCommentField
            }
        }
    }
    
    private var outcomeDatePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outcome Date")
                .font(AppFonts.medium(14))
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: Binding(
                get: { outcomeDate ?? Date() },
                set: { outcomeDate = $0 }
            ), in: dreamDate...Date(), displayedComponents: .date)
            .datePickerStyle(CompactDatePickerStyle())
            .foregroundColor(AppColors.primaryText)
        }
    }
    
    private var outcomeCommentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment (Optional)")
                .font(AppFonts.medium(14))
                .foregroundColor(AppColors.primaryText)
            
            TextField("Add a comment about the outcome", text: $outcomeComment, axis: .vertical)
                .font(AppFonts.regular(16))
                .foregroundColor(AppColors.primaryText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.cardBackground)
                )
                .lineLimit(3...6)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.white)
    }
    
    private var saveButton: some View {
        Button("Save") {
            saveDream()
        }
        .disabled(!isFormValid)
        .foregroundColor(isFormValid ? AppColors.yellow : AppColors.secondaryText)
    }
    
    private func setupInitialValues() {
        if let dream = dream {
            title = dream.title
            dreamDate = dream.dreamDate
            description = dream.description ?? ""
            expectedEvent = dream.expectedEvent
            checkDeadline = dream.checkDeadline
            selectedTags = Set(dream.tags)
            status = dream.status
            outcomeDate = dream.outcomeDate
            outcomeComment = dream.outcomeComment ?? ""
        } else {
            checkDeadline = Calendar.current.date(byAdding: .month, value: 1, to: dreamDate) ?? Date()
        }
        
        titleCharacterCount = title.count
        eventCharacterCount = expectedEvent.count
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty && DataManager.shared.addTag(trimmedName) {
            selectedTags.insert(trimmedName)
        }
        newTagName = ""
    }
    
    private func saveDream() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEvent = expectedEvent.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedComment = outcomeComment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingDream = dream {
            var updatedDream = existingDream
            updatedDream.title = trimmedTitle
            updatedDream.dreamDate = dreamDate
            updatedDream.description = trimmedDescription.isEmpty ? nil : trimmedDescription
            updatedDream.expectedEvent = trimmedEvent
            updatedDream.checkDeadline = checkDeadline
            updatedDream.tags = Array(selectedTags)
            updatedDream.status = status
            updatedDream.outcomeDate = outcomeDate
            updatedDream.outcomeComment = trimmedComment.isEmpty ? nil : trimmedComment
            updatedDream.updatedAt = Date()
            
            onSave(updatedDream)
        } else {
            let newDream = Dream(
                title: trimmedTitle,
                dreamDate: dreamDate,
                description: trimmedDescription.isEmpty ? nil : trimmedDescription,
                expectedEvent: trimmedEvent,
                checkDeadline: checkDeadline,
                tags: Array(selectedTags),
                status: status,
                outcomeDate: outcomeDate,
                outcomeComment: trimmedComment.isEmpty ? nil : trimmedComment
            )
            
            onSave(newDream)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.semiBold(16))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TagChip: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(tag)
                    .font(AppFonts.medium(12))
                    .foregroundColor(isSelected ? AppColors.backgroundBlue : AppColors.primaryText)
                
                if isSelected {
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.backgroundBlue)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? AppColors.yellow : AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusOption: View {
    let status: DreamStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? status.color : AppColors.secondaryText)
                
                Text(status.displayName)
                    .font(AppFonts.regular(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddEditDreamView(dream: nil) { _ in }
}
