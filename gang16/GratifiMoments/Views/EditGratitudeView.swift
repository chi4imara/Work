import SwiftUI

struct EditGratitudeView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @Environment(\.dismiss) private var dismiss
    
    let entry: GratitudeEntry
    @State private var editedText: String
    @State private var showingSaveConfirmation = false
    
    init(viewModel: GratitudeViewModel, entry: GratitudeEntry) {
        self.viewModel = viewModel
        self.entry = entry
        self._editedText = State(initialValue: entry.text)
    }
    
    private var hasChanges: Bool {
        editedText.trimmingCharacters(in: .whitespacesAndNewlines) != entry.text &&
        !editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        entryInfoView
                        
                        editFormView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .alert("Changes Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your gratitude entry has been updated successfully.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.builderSans(.medium, size: 16))
                }
                .foregroundColor(AppColors.primaryBlue)
            }
            
            Spacer()
            
            Text("Edit Gratitude")
                .font(.builderSans(.semiBold, size: 18))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: saveChanges) {
                Text("Save")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(hasChanges ? AppColors.primaryBlue : AppColors.textLight)
            }
            .opacity(0)
            .disabled(!hasChanges)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(AppColors.backgroundWhite.opacity(0.9))
                .shadow(color: AppColors.textLight.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
    
    private var entryInfoView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Date:")
                    .font(.builderSans(.medium, size: 14))
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text(entry.displayDate)
                    .font(.builderSans(.semiBold, size: 14))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            if entry.edited {
                HStack {
                    Text("Previously edited:")
                        .font(.builderSans(.medium, size: 14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("Yes")
                        .font(.builderSans(.semiBold, size: 14))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.textLight.opacity(0.2), lineWidth: 1)
                }
        )
    }
    
    private var editFormView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your gratitude:")
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(AppColors.textPrimary)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 2)
                        }
                        .frame(height: 150)
                    
                    TextEditor(text: $editedText)
                        .font(.builderSans(.regular, size: 16))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                        .onChange(of: editedText) { newValue in
                            if newValue.count > 200 {
                                editedText = String(newValue.prefix(200))
                            }
                        }
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    if editedText.count > 200 {
                        Text("Character limit exceeded")
                            .font(.builderSans(.medium, size: 12))
                            .foregroundColor(AppColors.accentOrange)
                    }
                    
                    Spacer()
                    
                    Text("\(editedText.count) / 200")
                        .font(.builderSans(.regular, size: 12))
                        .foregroundColor(editedText.count > 200 ? AppColors.accentOrange : AppColors.textLight)
                }
                
                if editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accentOrange)
                        
                        Text("Gratitude text cannot be empty")
                            .font(.builderSans(.medium, size: 12))
                            .foregroundColor(AppColors.accentOrange)
                        
                        Spacer()
                    }
                }
            }
            
            Button(action: saveChanges) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                    Text("Save Changes")
                        .font(.builderSans(.semiBold, size: 18))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(hasChanges ? AppColors.primaryBlue : AppColors.textLight)
                )
            }
            .disabled(!hasChanges)
            .padding(.top, 20)
        }
    }
    
    private func saveChanges() {
        guard hasChanges else { return }
        guard editedText.count <= 200 else { return }
        
        viewModel.updateEntry(entry, with: editedText)
        showingSaveConfirmation = true
    }
}

#Preview {
    let viewModel = GratitudeViewModel()
    let sampleEntry = GratitudeEntry(text: "I'm grateful for the beautiful sunset today and the peaceful moment it brought me.")
    
    return EditGratitudeView(viewModel: viewModel, entry: sampleEntry)
}
