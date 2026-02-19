import SwiftUI

struct EditImprovementView: View {
    let improvementId: UUID
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedStatus: ImprovementStatus = .planned
    @State private var description: String = ""
    @State private var showingDeleteAlert = false
    
    private var improvement: Improvement? {
        viewModel.getImprovement(by: improvementId)
    }
    
    private var currentImprovement: Improvement {
        improvement ?? Improvement(name: "", status: .planned, description: "", deviceId: UUID())
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    if improvement != nil {
                        formView
                        
                        deleteButton
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let improvement = improvement {
                name = improvement.name
                selectedStatus = improvement.status
                description = improvement.description
            }
        }
        .alert("Delete Improvement", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteImprovement()
            }
        } message: {
            Text("Are you sure you want to delete this improvement? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text("Edit Improvement")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: saveChanges) {
                Text("Save")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isFormValid ? ColorTheme.primaryText : ColorTheme.secondaryText)
            }
            .disabled(!isFormValid)
        }
        .padding(.top, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Improvement Name") {
                TextField("Enter improvement name", text: $name)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .cardStyle()
            }
            
            FormField(title: "Status") {
                VStack(spacing: 12) {
                    ForEach(ImprovementStatus.allCases, id: \.self) { status in
                        StatusSelectionRow(
                            status: status,
                            isSelected: selectedStatus == status
                        ) {
                            selectedStatus = status
                        }
                    }
                }
            }
            
            FormField(title: "Description") {
                TextField("Enter description (optional)", text: $description, axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .cardStyle()
                    .lineLimit(3...6)
            }
            
            metadataView
        }
    }
    
    private var metadataView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Information")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
            HStack {
                Text("Device:")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Spacer()
                
                Text(viewModel.getDeviceName(for: currentImprovement.deviceId))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            HStack {
                Text("Created:")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Spacer()
                
                Text(currentImprovement.createdAt, style: .date)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            if currentImprovement.updatedAt != currentImprovement.createdAt {
                HStack {
                    Text("Updated:")
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text(currentImprovement.updatedAt, style: .date)
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.primaryText)
                }
            }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            HStack {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Delete Improvement")
                    .font(.ubuntu(16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(ColorTheme.error)
            .cornerRadius(12)
        }
        .padding(.top, 20)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        guard var updatedImprovement = improvement else { return }
        updatedImprovement.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedImprovement.status = selectedStatus
        updatedImprovement.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedImprovement.updatedAt = Date()
        
        viewModel.updateImprovement(updatedImprovement)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteImprovement() {
        guard let improvement = improvement else { return }
        viewModel.deleteImprovement(improvement)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        EditImprovementView(
            improvementId: UUID(),
            viewModel: DeviceViewModel()
        )
    }
}
