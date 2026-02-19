import SwiftUI

struct DecisionDetailView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let decisionId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var decision: Decision? {
        viewModel.getDecision(byId: decisionId)
    }
    
    var body: some View {
        Group {
            if let decision = decision {
                ZStack {
                    AnimatedBackground()
                    
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(DesignSystem.Colors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("Decision")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                            
                            Spacer()
                            
                            Menu {
                                Button(action: { showingEditView = true }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title2)
                                    .foregroundColor(DesignSystem.Colors.yellow)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                    Text("Date")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundColor(DesignSystem.Colors.yellow)
                                        .textCase(.uppercase)
                                        .tracking(1)
                                    
                                    Text(decision.formattedDate)
                                        .font(DesignSystem.Typography.title2)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                    Text("Situation")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundColor(DesignSystem.Colors.yellow)
                                        .textCase(.uppercase)
                                        .tracking(1)
                                    
                                    Text(decision.situation)
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                        .lineSpacing(4)
                                        .padding(DesignSystem.Spacing.md)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(DesignSystem.Colors.cardBackground)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                    Text("Chosen Option")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundColor(DesignSystem.Colors.yellow)
                                        .textCase(.uppercase)
                                        .tracking(1)
                                    
                                    Text(decision.chosenOption)
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                        .lineSpacing(4)
                                        .padding(DesignSystem.Spacing.md)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(DesignSystem.Colors.cardBackground)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    Button(action: { showingEditView = true }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                            Text("Edit")
                                        }
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(DesignSystem.Gradients.buttonGradient)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .shadow(color: DesignSystem.Shadows.button, radius: 4, x: 0, y: 2)
                                    }
                                    
                                    Button(action: { showingDeleteAlert = true }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete")
                                        }
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.error)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(DesignSystem.Colors.cardBackground)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .stroke(DesignSystem.Colors.error.opacity(0.5), lineWidth: 1)
                                        )
                                    }
                                    
                                    Divider()
                                        .background(DesignSystem.Colors.secondaryText.opacity(0.3))
                                        .padding(.vertical, DesignSystem.Spacing.sm)
                                    
                                    VStack(spacing: DesignSystem.Spacing.sm) {
                                        HStack {
                                            Image(systemName: "clock")
                                                .font(.caption)
                                                .foregroundColor(DesignSystem.Colors.yellow)
                                            
                                            Text("Created")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Spacer()
                                            
                                            Text(formatCreatedDate(decision.createdAt))
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.primaryText)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "doc.text")
                                                .font(.caption)
                                                .foregroundColor(DesignSystem.Colors.yellow)
                                            
                                            Text("Characters")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Spacer()
                                            
                                            Text("\(decision.situation.count + decision.chosenOption.count)")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.primaryText)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                                .font(.caption)
                                                .foregroundColor(DesignSystem.Colors.yellow)
                                            
                                            Text("Days ago")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Spacer()
                                            
                                            Text("\(daysSince(decision.createdAt))")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.primaryText)
                                        }
                                    }
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.cardBackground.opacity(0.5))
                                    .cornerRadius(DesignSystem.CornerRadius.small)
                                }
                                .padding(.bottom, DesignSystem.Spacing.lg)
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.top, DesignSystem.Spacing.lg)
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditDecisionView(decisionId: decisionId)
                        .environmentObject(viewModel)
                }
                .alert("Delete Decision", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteDecision()
                    }
                } message: {
                    Text("Are you sure you want to delete this decision? This action cannot be undone.")
                }
            } else {
                Text("Decision not found")
                    .foregroundColor(DesignSystem.Colors.primaryText)
            }
        }
    }
    
    private func deleteDecision() {
        viewModel.deleteDecision(byId: decisionId)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatCreatedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        return components.day ?? 0
    }
}

#Preview {
    let viewModel = DecisionViewModel()
    let testDecision = Decision(situation: "Should I take the new job offer?", chosenOption: "Accept the offer and start next month")
    viewModel.addDecision(testDecision)
    return DecisionDetailView(decisionId: testDecision.id)
        .environmentObject(viewModel)
}
