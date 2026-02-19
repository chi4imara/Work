import SwiftUI

struct EditPrincipleView: View {
    let principleId: UUID
    @ObservedObject var viewModel: PrinciplesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var principleText = ""
    @State private var animateContent = false
    @FocusState private var isTextFieldFocused: Bool
    
    private var principle: Principle? {
        viewModel.getPrinciple(by: principleId)
    }
    
    private var isValidText: Bool {
        !principleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let principle = principle else { return false }
        return principleText.trimmingCharacters(in: .whitespacesAndNewlines) != principle.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.1)
                
                if principle != nil {
                    VStack(spacing: 0) {
                        ScrollView {
                            editContent
                        }
                        actionButtonsView
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(Color.appDarkGray.opacity(0.5))
                        Text("Principle not found")
                            .font(.playfairDisplay(18, weight: .medium))
                            .foregroundColor(Color.appDarkGray)
                        Button("Close") { dismiss() }
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(Color.appTextBlue)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let p = principle {
                principleText = p.text
            }
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private var editContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Edit Principle")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(Color.appTextBlue)
                
                Text("Update your principle to better reflect your current thinking.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.appDarkGray)
                    .lineSpacing(2)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Principle")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appDarkGray.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isTextFieldFocused ? Color.appTextBlue : Color.appLightGray,
                                    lineWidth: isTextFieldFocused ? 2 : 1
                                )
                        }
                        .shadow(
                            color: isTextFieldFocused ? Color.appTextBlue.opacity(0.2) : Color.clear,
                            radius: isTextFieldFocused ? 8 : 0
                        )
                        .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
                    
                    TextEditor(text: $principleText)
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(Color.appTextBlue)
                        .focused($isTextFieldFocused)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                }
                .frame(minHeight: 120)
                
                HStack {
                    if hasChanges {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color.appAccentYellow)
                            
                            Text("Modified")
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(Color.appAccentYellow)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(principleText.count) characters")
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(Color.appDarkGray.opacity(0.6))
                }
            }
            
            if let principle = principle {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Original created")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(Color.appDarkGray.opacity(0.7))
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(principle.createdAt, style: .date)
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(Color.appDarkGray)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appLightGray.opacity(0.5))
                )
            }
            
            Spacer(minLength: 100)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 15) {
            Button(action: saveChanges) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Save changes")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    (isValidText && hasChanges) ? AppColors.buttonGradient : 
                    LinearGradient(gradient: Gradient(colors: [Color.appLightGray, Color.appLightGray]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(
                    color: (isValidText && hasChanges) ? Color.appTextBlue.opacity(0.3) : Color.clear,
                    radius: (isValidText && hasChanges) ? 8 : 0,
                    x: 0, y: 4
                )
                .animation(.easeInOut(duration: 0.2), value: isValidText && hasChanges)
            }
            .disabled(!isValidText || !hasChanges)
            
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .scaleEffect(animateContent ? 1.0 : 0.9)
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateContent)
    }
    
    private func saveChanges() {
        guard isValidText && hasChanges, let principle = principle else { return }
        viewModel.updatePrinciple(principle, with: principleText)
        dismiss()
    }
}
