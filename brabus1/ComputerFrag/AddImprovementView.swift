import SwiftUI

struct AddImprovementView: View {
    let deviceId: UUID
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedStatus: ImprovementStatus = .planned
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text("New Improvement")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: saveImprovement) {
                Text("Save")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isFormValid ? ColorTheme.primaryText : ColorTheme.secondaryText)
            }
            .disabled(!isFormValid)
        }
        .padding(.top, 20)
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
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveImprovement() {
        let newImprovement = Improvement(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            status: selectedStatus,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            deviceId: deviceId
        )
        
        viewModel.addImprovement(newImprovement, to: deviceId)
        presentationMode.wrappedValue.dismiss()
    }
}

struct StatusSelectionRow: View {
    let status: ImprovementStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 20, height: 20)
                
                Text(status.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorTheme.accentYellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.accentYellow.opacity(0.2) : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var statusColor: Color {
        switch status {
        case .planned:
            return ColorTheme.warning
        case .completed:
            return ColorTheme.success
        }
    }
}

#Preview {
    AddImprovementView(deviceId: UUID(), viewModel: DeviceViewModel())
}
