import SwiftUI

struct AddPrincipleView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var principleText = ""
    @State private var animateContent = false
    @FocusState private var isTextFieldFocused: Bool
    
    private var isValidText: Bool {
        !principleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.1)
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("New Principle")
                                    .font(.playfairDisplay(28, weight: .bold))
                                    .foregroundColor(Color.appTextBlue)
                                
                                Text("Write a short, clear statement that reflects how you choose to live and act.")
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
                                    
                                    if principleText.isEmpty {
                                        Text("Enter your principle here...")
                                            .font(.playfairDisplay(16, weight: .regular))
                                            .foregroundColor(Color.appDarkGray.opacity(0.5))
                                            .padding(.horizontal, 16)
                                            .padding(.top, 16)
                                    }
                                    
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
                                    Spacer()
                                    Text("\(principleText.count) characters")
                                        .font(.playfairDisplay(12, weight: .regular))
                                        .foregroundColor(Color.appDarkGray.opacity(0.6))
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    actionButtonsView
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
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
    
    private var actionButtonsView: some View {
        VStack(spacing: 15) {
            Button(action: savePrinciple) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Save")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isValidText ? AppColors.buttonGradient : 
                    LinearGradient(gradient: Gradient(colors: [Color.appLightGray, Color.appLightGray]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(
                    color: isValidText ? Color.appTextBlue.opacity(0.3) : Color.clear,
                    radius: isValidText ? 8 : 0,
                    x: 0, y: 4
                )
                .animation(.easeInOut(duration: 0.2), value: isValidText)
            }
            .disabled(!isValidText)
            
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
    
    private func savePrinciple() {
        guard isValidText else { return }
        
        viewModel.addPrinciple(principleText)
        dismiss()
    }
}

#Preview {
    AddPrincipleView(viewModel: PrinciplesViewModel())
}
