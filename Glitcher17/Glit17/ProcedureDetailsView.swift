import SwiftUI

struct ProcedureDetailsView: View {
    let procedureId: UUID
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var procedure: Procedure? {
        appState.procedures.first { $0.id == procedureId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                if let procedure = procedure {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text(procedure.name)
                                .font(FontManager.ubuntu(28, weight: .bold))
                                .foregroundColor(ColorManager.textWhite)
                                .multilineTextAlignment(.leading)
                            
                            VStack(spacing: 20) {
                                DetailRow(
                                    title: "Category",
                                    value: procedure.category.name,
                                    icon: "tag"
                                )
                                
                                DetailRow(
                                    title: "Frequency",
                                    value: procedure.frequency.displayText,
                                    icon: "clock"
                                )
                                
                                DetailRow(
                                    title: "First Execution Date",
                                    value: formatDate(procedure.firstExecutionDate),
                                    icon: "calendar"
                                )
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "text.bubble")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(ColorManager.accentYellow)
                                        
                                        Text("Comment")
                                            .font(FontManager.ubuntu(16, weight: .medium))
                                            .foregroundColor(ColorManager.textWhite)
                                    }
                                    
                                    Text(procedure.comment.isEmpty ? "No comment available" : procedure.comment)
                                        .font(FontManager.ubuntu(16, weight: .regular))
                                        .foregroundColor(procedure.comment.isEmpty ? ColorManager.textSecondary : ColorManager.textWhite)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(ColorManager.cardBackground)
                                        )
                                }
                            }
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    Text("Edit")
                                        .font(FontManager.ubuntu(18, weight: .medium))
                                        .foregroundColor(ColorManager.primaryPurple)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(ColorManager.buttonGradient)
                                        .cornerRadius(28)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    Text("Delete")
                                        .font(FontManager.ubuntu(18, weight: .medium))
                                        .foregroundColor(ColorManager.textWhite)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(
                                            RoundedRectangle(cornerRadius: 28)
                                                .fill(ColorManager.errorRed.opacity(0.8))
                                        )
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding(20)
                    }
                } else {
                    VStack {
                        Text("Procedure not found")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.textSecondary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.textWhite)
            )
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            if let procedure = procedure {
                EditProcedureView(procedure: procedure, appState: appState)
            }
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let procedure = procedure {
                    appState.deleteProcedure(procedure)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.accentYellow)
                
                Text(title)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
            }
            
            Text(value)
                .font(FontManager.ubuntu(18, weight: .regular))
                .foregroundColor(ColorManager.textWhite)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.cardBackground)
                )
        }
    }
}

struct EditProcedureView: View {
    let procedure: Procedure
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedCategory: Category
    @State private var customCategoryName = ""
    @State private var showingCustomCategory = false
    @State private var selectedFrequency: Procedure.Frequency
    @State private var customDays = 3
    @State private var firstExecutionDate: Date
    @State private var comment: String
    
    init(procedure: Procedure, appState: AppState) {
        self.procedure = procedure
        self.appState = appState
        
        _name = State(initialValue: procedure.name)
        _selectedCategory = State(initialValue: procedure.category)
        _selectedFrequency = State(initialValue: procedure.frequency)
        _firstExecutionDate = State(initialValue: procedure.firstExecutionDate)
        _comment = State(initialValue: procedure.comment)
        
        if case .custom(let days) = procedure.frequency {
            _customDays = State(initialValue: days)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Name")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            TextField("Enter procedure name", text: $name)
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.textWhite)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            Menu {
                                ForEach(appState.categories, id: \.id) { category in
                                    Button(category.name) {
                                        selectedCategory = category
                                        showingCustomCategory = false
                                    }
                                }
                                
                                Button("Create custom category") {
                                    showingCustomCategory = true
                                }
                            } label: {
                                HStack {
                                    Text(showingCustomCategory ? "Custom Category" : selectedCategory.name)
                                        .font(FontManager.ubuntu(16, weight: .regular))
                                        .foregroundColor(ColorManager.textWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorManager.textSecondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                            }
                            
                            if showingCustomCategory {
                                TextField("Enter category name", text: $customCategoryName)
                                    .font(FontManager.ubuntu(16, weight: .regular))
                                    .foregroundColor(ColorManager.textWhite)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            VStack(spacing: 12) {
                                FrequencyOption(
                                    title: "Daily",
                                    isSelected: selectedFrequency == .daily
                                ) {
                                    selectedFrequency = .daily
                                }
                                
                                FrequencyOption(
                                    title: "Weekly",
                                    isSelected: selectedFrequency == .weekly
                                ) {
                                    selectedFrequency = .weekly
                                }
                                
                                VStack(spacing: 8) {
                                    FrequencyOption(
                                        title: "Every X days",
                                        isSelected: {
                                            if case .custom = selectedFrequency { return true }
                                            return false
                                        }()
                                    ) {
                                        selectedFrequency = .custom(days: customDays)
                                    }
                                    
                                    if case .custom = selectedFrequency {
                                        HStack {
                                            Text("Every")
                                                .font(FontManager.ubuntu(14, weight: .medium))
                                                .foregroundColor(ColorManager.textSecondary)
                                            
                                            TextField("3", value: $customDays, format: .number)
                                                .font(FontManager.ubuntu(16, weight: .medium))
                                                .foregroundColor(ColorManager.textWhite)
                                                .keyboardType(.numberPad)
                                                .frame(width: 60)
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(ColorManager.cardBackground)
                                                )
                                                .onChange(of: customDays) { newValue in
                                                    selectedFrequency = .custom(days: newValue)
                                                }
                                            
                                            Text("days")
                                                .font(FontManager.ubuntu(14, weight: .medium))
                                                .foregroundColor(ColorManager.textSecondary)
                                            
                                            Spacer()
                                        }
                                        .padding(.leading, 32)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Execution Date")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            DatePicker("", selection: $firstExecutionDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            TextField("Add a comment", text: $comment, axis: .vertical)
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.textWhite)
                                .lineLimit(3...6)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(isFormValid ? ColorManager.primaryPurple : ColorManager.textSecondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(isFormValid ? AnyShapeStyle(ColorManager.buttonGradient) : AnyShapeStyle(ColorManager.cardBackground))
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.textWhite)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        let finalCategory: Category
        
        if showingCustomCategory && !customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            finalCategory = Category(name: customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            finalCategory = selectedCategory
        }
        
        var updatedProcedure = procedure
        updatedProcedure.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProcedure.category = finalCategory
        updatedProcedure.frequency = selectedFrequency
        updatedProcedure.firstExecutionDate = firstExecutionDate
        updatedProcedure.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        appState.updateProcedure(updatedProcedure)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleProcedure = Procedure(
        name: "Face Mask",
        category: Category(name: "Skin"),
        frequency: .weekly,
        firstExecutionDate: Date(),
        comment: "Use hydrating mask for dry skin"
    )
    
    ProcedureDetailsView(procedureId: sampleProcedure.id, appState: AppState())
}
