import SwiftUI

struct IdeaCreationView: View {
    @ObservedObject var viewModel: ContentIdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedContentType: ContentType = .photo
    @State private var description = ""
    @State private var publishDate: Date?
    @State private var selectedStatus: ContentStatus = .idea
    @State private var hashtags = ""
    @State private var showingDatePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var editingIdea: ContentIdea?
    
    init(viewModel: ContentIdeasViewModel, editingIdea: ContentIdea? = nil) {
        self.viewModel = viewModel
        self.editingIdea = editingIdea
        
        if let idea = editingIdea {
            _title = State(initialValue: idea.title)
            _selectedContentType = State(initialValue: idea.contentType)
            _description = State(initialValue: idea.description)
            _publishDate = State(initialValue: idea.publishDate)
            _selectedStatus = State(initialValue: idea.status)
            _hashtags = State(initialValue: idea.hashtags)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Morning coffee", text: $title)
                                .font(.playfairDisplay(16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.primaryWhite)
                                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content Type")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(ContentType.allCases, id: \.self) { type in
                                    ContentTypeButton(
                                        type: type,
                                        isSelected: selectedContentType == type
                                    ) {
                                        selectedContentType = type
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextEditor(text: $description)
                                .font(.playfairDisplay(16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(minHeight: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.primaryWhite)
                                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Publish Date")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.theme.primaryBlue)
                                    
                                    if let date = publishDate {
                                        Text(date, style: .date)
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(Color.theme.primaryText)
                                    } else {
                                        Text("Select date")
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    if publishDate != nil {
                                        Button(action: {
                                            publishDate = nil
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color.theme.secondaryText)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.primaryWhite)
                                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Menu {
                                ForEach(ContentStatus.allCases, id: \.self) { status in
                                    Button(status.displayName) {
                                        selectedStatus = status
                                    }
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(selectedStatus.color)
                                        .frame(width: 12, height: 12)
                                    
                                    Text(selectedStatus.displayName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.primaryWhite)
                                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hashtags")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("#morning #coffee #lifestyle", text: $hashtags)
                                .font(.playfairDisplay(16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.primaryWhite)
                                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                                )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingIdea != nil ? "Edit Idea" : "New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.accentText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIdea()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $publishDate)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveIdea() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a title for your idea."
            showingAlert = true
            return
        }
        
        if let existingIdea = editingIdea {
            let updatedIdea = ContentIdea(
                id: existingIdea.id,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                contentType: selectedContentType,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                publishDate: publishDate,
                status: selectedStatus,
                hashtags: hashtags.trimmingCharacters(in: .whitespacesAndNewlines),
                createdDate: existingIdea.createdDate
            )
            
            viewModel.updateIdea(updatedIdea)
        } else {
            let newIdea = ContentIdea(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                contentType: selectedContentType,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                publishDate: publishDate,
                status: selectedStatus,
                hashtags: hashtags.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addIdea(newIdea)
        }
        
        dismiss()
    }
}

struct ContentTypeButton: View {
    let type: ContentType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color.theme.primaryBlue)
                
                Text(type.displayName)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color.theme.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(Color.theme.purpleGradient) : AnyShapeStyle(Color.theme.primaryWhite))
                    .shadow(color: Color.theme.shadowColor, radius: isSelected ? 8 : 3, x: 0, y: 2)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date?
    @Environment(\.dismiss) private var dismiss
    @State private var tempDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $tempDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("Publish Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedDate = tempDate
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let date = selectedDate {
                tempDate = date
            }
        }
    }
}

#Preview {
    IdeaCreationView(viewModel: ContentIdeasViewModel())
}
