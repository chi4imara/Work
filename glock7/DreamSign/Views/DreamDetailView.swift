import SwiftUI

struct DreamDetailView: View {
    let dream: Dream
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var showingDeleteAlert = false
    @State private var dreamToEdit: Dream?
    @State private var outcomeFormData: OutcomeFormData?
    @State private var selectedOutcomeStatus: DreamStatus = .fulfilled
    @State private var outcomeDate = Date()
    @State private var outcomeComment = ""
    
    private var currentDream: Dream {
        dataManager.dreams.first { $0.id == dream.id } ?? dream
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Dream Details")
                        .font(AppFonts.callout.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: { dreamToEdit = currentDream }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        DetailSection(title: "Dream") {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(currentDream.title)
                                        .font(AppFonts.bold(20))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("Dreamed on \(formatDate(currentDream.dreamDate))")
                                        .font(AppFonts.regular(14))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                if let description = currentDream.description, !description.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Description")
                                            .font(AppFonts.semiBold(16))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Text(description)
                                            .font(AppFonts.regular(15))
                                            .foregroundColor(AppColors.secondaryText)
                                            .lineSpacing(2)
                                    }
                                } else {
                                    Text("No description added")
                                        .font(AppFonts.regular(15))
                                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                        .italic()
                                }
                                
                                if !currentDream.tags.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Tags")
                                            .font(AppFonts.semiBold(16))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                            ForEach(currentDream.tags, id: \.self) { tag in
                                                Text(tag)
                                                    .font(AppFonts.medium(12))
                                                    .foregroundColor(AppColors.backgroundBlue)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .fill(AppColors.yellow.opacity(0.8))
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        DetailSection(title: "Prediction") {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Expected Event")
                                        .font(AppFonts.semiBold(16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(currentDream.expectedEvent)
                                        .font(AppFonts.regular(15))
                                        .foregroundColor(AppColors.secondaryText)
                                        .lineSpacing(2)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Check Deadline")
                                        .font(AppFonts.semiBold(16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(formatDate(currentDream.checkDeadline))
                                        .font(AppFonts.regular(15))
                                        .foregroundColor(AppColors.yellow)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Status")
                                        .font(AppFonts.semiBold(16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(currentDream.status.color)
                                            .frame(width: 12, height: 12)
                                        
                                        Text(currentDream.status.displayName)
                                            .font(AppFonts.medium(15))
                                            .foregroundColor(currentDream.status.color)
                                    }
                                }
                                
                                if currentDream.status != .waiting {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Divider()
                                            .background(AppColors.primaryText.opacity(0.3))
                                        
                                        if let outcomeDate = currentDream.outcomeDate {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("Outcome Date")
                                                    .font(AppFonts.semiBold(16))
                                                    .foregroundColor(AppColors.primaryText)
                                                
                                                Text(formatDate(outcomeDate))
                                                    .font(AppFonts.regular(15))
                                                    .foregroundColor(AppColors.secondaryText)
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Comment")
                                                .font(AppFonts.semiBold(16))
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            if let comment = currentDream.outcomeComment, !comment.isEmpty {
                                                Text(comment)
                                                    .font(AppFonts.regular(15))
                                                    .foregroundColor(AppColors.secondaryText)
                                                    .lineSpacing(2)
                                            } else {
                                                Text("No comment added")
                                                    .font(AppFonts.regular(15))
                                                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                                    .italic()
                                            }
                                        }
                                    }
                                }
                                
                                if currentDream.status == .waiting {
                                    VStack(spacing: 12) {
                                        Divider()
                                            .background(AppColors.primaryText.opacity(0.3))
                                        
                                        Text("Quick Actions")
                                            .font(AppFonts.semiBold(16))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                selectedOutcomeStatus = .fulfilled
                                                outcomeDate = Date()
                                                outcomeComment = ""
                                                outcomeFormData = OutcomeFormData(
                                                    status: .fulfilled,
                                                    outcomeDate: Date(),
                                                    outcomeComment: ""
                                                )
                                            }) {
                                                Text("Mark as Fulfilled")
                                                    .font(AppFonts.medium(10))
                                                    .foregroundColor(AppColors.backgroundBlue)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(AppColors.green)
                                                    )
                                            }
                                            
                                            Button(action: {
                                                selectedOutcomeStatus = .notFulfilled
                                                outcomeDate = Date()
                                                outcomeComment = ""
                                                outcomeFormData = OutcomeFormData(
                                                    status: .notFulfilled,
                                                    outcomeDate: Date(),
                                                    outcomeComment: ""
                                                )
                                            }) {
                                                Text("Mark as Not Fulfilled")
                                                    .font(AppFonts.medium(10))
                                                    .foregroundColor(AppColors.backgroundBlue)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(AppColors.red)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        DetailSection(title: "Timeline") {
                            VStack(alignment: .leading, spacing: 12) {
                                TimelineItem(
                                    title: "Created",
                                    date: currentDream.createdAt,
                                    icon: "plus.circle.fill",
                                    color: AppColors.teal
                                )
                                
                                if currentDream.updatedAt != currentDream.createdAt {
                                    TimelineItem(
                                        title: "Last Modified",
                                        date: currentDream.updatedAt,
                                        icon: "pencil.circle.fill",
                                        color: AppColors.yellow
                                    )
                                }
                                
                                if let outcomeDate = currentDream.outcomeDate {
                                    TimelineItem(
                                        title: "Outcome Recorded",
                                        date: outcomeDate,
                                        icon: currentDream.status == .fulfilled ? "checkmark.circle.fill" : "xmark.circle.fill",
                                        color: currentDream.status.color
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: Binding<Dream?>(
            get: { dreamToEdit },
            set: { _ in dreamToEdit = nil }
        )) { dream in
            AddEditDreamView(dream: dream) { updatedDream in
                DataManager.shared.updateDream(updatedDream)
            }
        }
        .sheet(item: Binding<OutcomeFormData?>(
            get: { outcomeFormData },
            set: { _ in outcomeFormData = nil }
        )) { data in
            OutcomeFormView(
                status: data.status,
                outcomeDate: $outcomeDate,
                outcomeComment: $outcomeComment
            ) {
                updateDreamStatus()
            }
        }
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                DataManager.shared.deleteDream(currentDream)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
    }
    
    private func updateDreamStatus() {
        var updatedDream = currentDream
        updatedDream.updateStatus(selectedOutcomeStatus, outcomeDate: outcomeDate, comment: outcomeComment.isEmpty ? nil : outcomeComment)
        DataManager.shared.updateDream(updatedDream)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.bold(18))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct TimelineItem: View {
    let title: String
    let date: Date
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.medium(14))
                    .foregroundColor(AppColors.primaryText)
                
                Text(formatDateTime(date))
                    .font(AppFonts.regular(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct OutcomeFormView: View {
    let status: DreamStatus
    @Binding var outcomeDate: Date
    @Binding var outcomeComment: String
    let onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Update Status")
                        .font(AppFonts.callout.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .opacity(0)
                    .disabled(true)
                }
                .padding()
                
                VStack(spacing: 12) {
                    Image(systemName: status == .fulfilled ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(status.color)
                    
                    Text("Mark as \(status.displayName)")
                        .font(AppFonts.bold(20))
                        .foregroundColor(AppColors.primaryText)
                }
                .padding(.top, 40)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Outcome Date")
                            .font(AppFonts.semiBold(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        DatePicker("", selection: $outcomeDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .foregroundColor(AppColors.primaryText)
                            .colorInvert()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment (Optional)")
                            .font(AppFonts.semiBold(16))
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
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(AppFonts.semiBold(18))
                        .foregroundColor(AppColors.backgroundBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(status.color)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

struct OutcomeFormData: Identifiable {
    let id = UUID()
    let status: DreamStatus
    let outcomeDate: Date
    let outcomeComment: String
}

#Preview {
    DreamDetailView(dream: Dream(
        title: "Flying Dream",
        dreamDate: Date(),
        description: "I was flying over a beautiful landscape",
        expectedEvent: "I will travel to a new place",
        checkDeadline: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    ))
}
