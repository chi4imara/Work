import SwiftUI

struct AddEditEntryView: View {
    @ObservedObject var viewModel: WonderViewModel
    let entry: WonderEntry?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    private var isEditing: Bool {
        entry != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.appSubheadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("What surprised you?", text: $title)
                                .font(.appBody)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(showingValidationError && !viewModel.validateTitle(title) ? AppColors.error : AppColors.cardBorder, lineWidth: 1)
                                )
                                .onChange(of: title) { newValue in
                                    if newValue.count > 50 {
                                        title = String(newValue.prefix(50))
                                    }
                                }
                            
                            HStack {
                                if showingValidationError && !viewModel.validateTitle(title) {
                                    Text("Title is required")
                                        .font(.appCaption)
                                        .foregroundColor(AppColors.error)
                                }
                                
                                Spacer()
                                
                                Text("\(title.count)/50")
                                    .font(.appCaption)
                                    .foregroundColor(title.count > 50 ? AppColors.error : (title.count > 40 ? AppColors.warning : AppColors.secondaryText))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.appSubheadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $description)
                                .font(.appBody)
                                .padding(8)
                                .frame(minHeight: 120)
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                                .scrollContentBackground(.hidden)
                                .onChange(of: description) { newValue in
                                    if newValue.count > 300 {
                                        description = String(newValue.prefix(300))
                                    }
                                }
                            
                            HStack {
                                Text("Optional")
                                    .font(.appCaption)
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Spacer()
                                
                                Text("\(description.count)/300")
                                    .font(.appCaption)
                                    .foregroundColor(description.count > 300 ? AppColors.error : (description.count > 250 ? AppColors.warning : AppColors.secondaryText))
                            }
                        }
                    
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.appSubheadline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time")
                                    .font(.appSubheadline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private var canSave: Bool {
        viewModel.validateTitle(title) && 
        viewModel.validateTitleLength(title) && 
        viewModel.validateDescriptionLength(description)
    }
    
    private func setupInitialValues() {
        if let entry = entry {
            title = entry.title
            description = entry.description
            selectedDate = entry.date
            selectedTime = entry.time
        } else {
            selectedDate = Date()
            selectedTime = Date()
        }
    }
    
    private func saveEntry() {
        guard viewModel.validateTitle(title) else {
            validationMessage = "Please enter a title"
            showingValidationError = true
            return
        }
        
        guard viewModel.validateTitleLength(title) else {
            validationMessage = "Title must be 50 characters or less"
            showingValidationError = true
            return
        }
        
        guard viewModel.validateDescriptionLength(description) else {
            validationMessage = "Description must be 300 characters or less"
            showingValidationError = true
            return
        }
        
        if let entry = entry {
            viewModel.updateEntry(entry, title: title, description: description, date: selectedDate, time: selectedTime)
        } else {
            viewModel.addEntry(title: title, description: description, date: selectedDate, time: selectedTime)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditEntryView(viewModel: WonderViewModel(), entry: nil)
}
