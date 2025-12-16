import SwiftUI

struct RepotFormView: View {
    @StateObject private var formViewModel = RepotFormViewModel()
    @ObservedObject var viewModel: RepotJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingRecord: RepotRecord?
    
    init(viewModel: RepotJournalViewModel, editingRecord: RepotRecord? = nil) {
        self.viewModel = viewModel
        self.editingRecord = editingRecord
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormSection(title: "Plant Name", isRequired: true) {
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("e.g. Ficus Benjamina", text: $formViewModel.plantName)
                                    .font(AppFonts.body(.regular))
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .onChange(of: formViewModel.plantName) { _ in
                                        formViewModel.validateFields()
                                    }
                                
                                if !formViewModel.plantNameError.isEmpty {
                                    Text(formViewModel.plantNameError)
                                        .font(AppFonts.caption(.medium))
                                        .foregroundColor(AppColors.error)
                                }
                            }
                        }
                        
                        FormSection(title: "Repot Date", isRequired: true) {
                            DatePicker("", selection: $formViewModel.repotDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .font(AppFonts.body(.regular))
                                .foregroundColor(AppColors.textPrimary)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 16) {
                            FormSection(title: "Pot Diameter (cm)") {
                                VStack(alignment: .leading, spacing: 8) {
                                    TextField("Ø, cm", text: $formViewModel.potDiameter)
                                        .font(AppFonts.body(.regular))
                                        .foregroundColor(AppColors.textPrimary)
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                        .onChange(of: formViewModel.potDiameter) { _ in
                                            formViewModel.validateFields()
                                        }
                                    
                                    if !formViewModel.potDiameterError.isEmpty {
                                        Text(formViewModel.potDiameterError)
                                            .font(AppFonts.caption(.medium))
                                            .foregroundColor(AppColors.error)
                                    }
                                }
                            }
                            
                            FormSection(title: "Pot Height (cm)") {
                                VStack(alignment: .leading, spacing: 8) {
                                    TextField("Height, cm", text: $formViewModel.potHeight)
                                        .font(AppFonts.body(.regular))
                                        .foregroundColor(AppColors.textPrimary)
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                        .onChange(of: formViewModel.potHeight) { _ in
                                            formViewModel.validateFields()
                                        }
                                    
                                    if !formViewModel.potHeightError.isEmpty {
                                        Text(formViewModel.potHeightError)
                                            .font(AppFonts.caption(.medium))
                                            .foregroundColor(AppColors.error)
                                    }
                                }
                            }
                        }
                        
                        FormSection(title: "Soil Type") {
                            TextField("e.g. Universal, with perlite", text: $formViewModel.soilType)
                                .font(AppFonts.body(.regular))
                                .foregroundColor(AppColors.textPrimary)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        FormSection(title: "Drainage") {
                            Toggle("Has drainage", isOn: $formViewModel.hasDrainage)
                                .font(AppFonts.body(.regular))
                                .foregroundColor(AppColors.textPrimary)
                                .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryBlue))
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        FormSection(title: "Care Note") {
                            VStack(alignment: .leading, spacing: 8) {
                                TextEditor(text: $formViewModel.careNote)
                                    .font(AppFonts.body(.regular))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(minHeight: 100)
                                    .padding(8)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                
                                Text("Watering, lighting, fertilizers, observations")
                                    .font(AppFonts.caption(.regular))
                                    .foregroundColor(AppColors.textTertiary)
                            }
                        }
                        
                        if formViewModel.isEditing {
                            Button(action: { formViewModel.showDeleteAlert() }) {
                                Text("Delete Record")
                                    .font(AppFonts.headline(.semiBold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.error)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(formViewModel.navigationTitle)
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
                        saveRecord()
                    }
                    .foregroundColor(formViewModel.isValid ? AppColors.primaryBlue : AppColors.textTertiary)
                    .disabled(!formViewModel.isValid)
                }
            }
        }
        .onAppear {
            if let record = editingRecord {
                formViewModel.loadRecord(record)
            }
        }
        .alert("Delete Record", isPresented: $formViewModel.showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let record = editingRecord {
                    viewModel.deleteRecord(record)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this record?")
        }
    }
    
    private func saveRecord() {
        guard let record = formViewModel.createRecord() else { return }
        
        if formViewModel.isEditing {
            viewModel.updateRecord(record)
        } else {
            viewModel.addRecord(record)
        }
        
        dismiss()
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(AppFonts.headline(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                if isRequired {
                    Text("*")
                        .font(AppFonts.headline(.semiBold))
                        .foregroundColor(AppColors.error)
                }
                
                Spacer()
            }
            
            content
        }
    }
}

#Preview {
    RepotFormView(viewModel: RepotJournalViewModel())
}
