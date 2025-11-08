import SwiftUI

struct EditVictoryView: View {
    let victory: Victory
    let onDismiss: () -> Void
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var editedText: String
    @State private var showSuccessMessage = false
    
    private let maxCharacters = 200
    
    init(victory: Victory, onDismiss: @escaping () -> Void) {
        self.victory = victory
        self.onDismiss = onDismiss
        self._editedText = State(initialValue: victory.text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Edit Victory")
                                    .font(AppFonts.title1)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text(victory.dateString)
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Victory Text")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.white)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 0)
                                        .stroke(AppColors.primary, lineWidth: 2)
                                    }
                                    .frame(minHeight: 120)
                                
                                if editedText.isEmpty {
                                    Text("Enter your victory...")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textSecondary.opacity(0.6))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                }
                                
                                TextEditor(text: $editedText)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.clear)
                                    .onChange(of: editedText) { newValue in
                                        if newValue.count > maxCharacters {
                                            editedText = String(newValue.prefix(maxCharacters))
                                        }
                                    }
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(editedText.count)/\(maxCharacters)")
                                    .font(AppFonts.caption1)
                                    .foregroundColor(editedText.count > maxCharacters - 20 ? AppColors.warning : AppColors.textSecondary)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            PixelButton(
                                "Save Changes",
                                icon: "checkmark.circle.fill",
                                style: editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .primary
                            ) {
                                saveChanges()
                            }
                            .disabled(editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            
                            PixelButton("Cancel", style: .secondary) {
                                onDismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .overlay(
            VStack {
                if showSuccessMessage {
                    HStack {
                        PixelSuccessView(size: 20)
                        Text("Victory updated!")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppColors.cardGradient)
                    .cornerRadius(0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(AppColors.success, lineWidth: 2)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .padding(.top, 50)
            .animation(.easeInOut(duration: 0.5), value: showSuccessMessage)
        )
    }
    
    private func saveChanges() {
        let text = editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        viewModel.updateVictory(victory, text: text)
        
        showSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showSuccessMessage = false
            onDismiss()
        }
    }
}

#Preview {
    EditVictoryView(victory: Victory.sampleVictories[0]) {
        print("Dismissed")
    }
    .environmentObject(VictoryViewModel())
}
