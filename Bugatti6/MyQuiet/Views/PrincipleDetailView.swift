import SwiftUI

struct PrincipleDetailView: View {
    let principleId: UUID
    @ObservedObject var viewModel: PrinciplesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var animateContent = false
    
    private var principle: Principle? {
        viewModel.getPrinciple(by: principleId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.1)
                
                if let principle = principle {
                    VStack(spacing: 0) {
                        ScrollView {
                            detailContent(principle: principle)
                        }
                        actionButtonsView(principle: principle)
                    }
                } else {
                    principleNotFoundView
                }
            }
            .navigationTitle("Principle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditPrincipleView(principleId: principleId, viewModel: viewModel)
        }
        .alert("Delete Principle", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let principle = principle {
                    viewModel.deletePrinciple(principle)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this principle? This action cannot be undone.")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
    
    private func detailContent(principle: Principle) -> some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Principle")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appDarkGray.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(principle.displayText)
                    .font(.playfairDisplay(22, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Created")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(Color.appDarkGray.opacity(0.7))
                    
                    Spacer()
                    
                    Text(principle.createdAt, style: .date)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.appDarkGray)
                }
                
                if principle.updatedAt != principle.createdAt {
                    HStack {
                        Text("Last updated")
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(Color.appDarkGray.opacity(0.7))
                        
                        Spacer()
                        
                        Text(principle.updatedAt, style: .date)
                            .font(.playfairDisplay(14, weight: .regular))
                            .foregroundColor(Color.appDarkGray)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appLightGray.opacity(0.5))
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var principleNotFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(Color.appDarkGray.opacity(0.5))
            Text("Principle not found")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(Color.appDarkGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func actionButtonsView(principle: Principle) -> some View {
        VStack(spacing: 15) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Edit")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.buttonGradient)
                .cornerRadius(12)
                .shadow(color: Color.appTextBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Delete")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.appErrorRed, Color.appErrorRed.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: Color.appErrorRed.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .scaleEffect(animateContent ? 1.0 : 0.9)
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateContent)
    }
}
