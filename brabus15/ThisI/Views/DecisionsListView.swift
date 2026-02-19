import SwiftUI

struct IdentifiableUUID: Identifiable {
    let id: UUID
}

struct DecisionsListView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var showingAddDecision = false
    @State private var selectedDecisionId: UUID?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Decisions")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = 2
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(DesignSystem.Colors.yellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.decisions.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "doc.text.below.ecg")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.yellow.opacity(0.7))
                        
                        Text("Here will appear your made decisions. Add the first one to record your choice.")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DesignSystem.Spacing.xl)
                        
                        Button(action: {
                            withAnimation {
                                selectedTab = 2
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Decision")
                            }
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.Gradients.buttonGradient)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                            .shadow(color: DesignSystem.Shadows.button, radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.xl)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(viewModel.decisions.sorted { $0.date > $1.date }) { decision in
                                DecisionRowView(decision: decision) {
                                    selectedDecisionId = decision.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, DesignSystem.Spacing.lg)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddDecision) {
            AddDecisionView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
        }
        .sheet(item: Binding(
            get: { selectedDecisionId.map { IdentifiableUUID(id: $0) } },
            set: { selectedDecisionId = $0?.id }
        )) { item in
            DecisionDetailView(decisionId: item.id)
                .environmentObject(viewModel)
        }
    }
}

struct DecisionRowView: View {
    let decision: Decision
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                HStack {
                    Text(decision.formattedDate)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.yellow)
                    
                    Spacer()
                }
                
                Text(decision.shortDescription)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text("Choice: \(decision.chosenOption)")
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
