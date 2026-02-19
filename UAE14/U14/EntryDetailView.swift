import SwiftUI

struct EntryDetailView: View {
    let entry: PullUpEntry
    @ObservedObject var viewModel: PullUpViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerView
                    
                    contentView
                    
                    actionButtonsView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditEntryView(entry: entry, viewModel: viewModel)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(entry)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this entry?")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                Spacer()
            }
            
            Text(entry.dateString)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 10)
    }
    
    private var contentView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Text("\(entry.count)")
                    .font(.ubuntu(72, weight: .bold))
                    .foregroundColor(AppColors.lightBlue)
                
                Text("Pull-ups")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(30)
            .cardStyle()
            
            if !entry.comment.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Comment")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(entry.comment)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .cardStyle()
            }
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button {
                showingEditView = true
            } label: {
                Text("Edit Entry")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.primaryButton)
                    .cornerRadius(8)
            }
            
            Button {
                showingDeleteAlert = true
            } label: {
                Text("Delete Entry")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.dangerButton)
                    .cornerRadius(8)
            }
        }
        .padding(.bottom, 30)
    }
}

struct EditEntryView: View {
    let entry: PullUpEntry
    @ObservedObject var viewModel: PullUpViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date
    @State private var count: String
    @State private var comment: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(entry: PullUpEntry, viewModel: PullUpViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        self._selectedDate = State(initialValue: entry.date)
        self._count = State(initialValue: String(entry.count))
        self._comment = State(initialValue: entry.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    headerView
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            formView
                            
                            saveButton
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(AppColors.secondaryText)
            .font(.ubuntu(16))
            
            Spacer()
            
            Text("Edit Entry")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button("Cancel") {
                dismiss()
            }
            .opacity(0)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .padding(12)
                    .cardStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Number of Pull-ups")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                TextField("Enter count", text: $count)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .keyboardType(.numberPad)
                    .padding(12)
                    .cardStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Comment (Optional)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                TextField("Add a comment", text: $comment, axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(3...6)
                    .padding(12)
                    .cardStyle()
            }
        }
    }
    
    private var saveButton: some View {
        Button("Save Changes") {
            saveChanges()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(count.isEmpty)
        .opacity(count.isEmpty ? 0.6 : 1.0)
    }
    
    private func saveChanges() {
        guard let pullUpCount = Int(count), pullUpCount > 0 else {
            alertMessage = "Please enter a valid number of pull-ups"
            showingAlert = true
            return
        }
        
        let updatedEntry = PullUpEntry(
            id: entry.id,
            date: selectedDate,
            count: pullUpCount,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.updateEntry(updatedEntry)
        dismiss()
    }
}

#Preview {
    EntryDetailView(
        entry: PullUpEntry(date: Date(), count: 25, comment: "Great workout!"),
        viewModel: PullUpViewModel()
    )
}
