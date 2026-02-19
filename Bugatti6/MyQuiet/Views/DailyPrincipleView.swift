import SwiftUI

private struct DetailSheetItem: Identifiable {
    let id: UUID
}

struct DailyPrincipleView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @State private var displayedPrincipleId: UUID?
    @State private var animateContent = false
    @State private var detailSheetItem: DetailSheetItem?
    
    private var displayedPrinciple: Principle? {
        guard let id = displayedPrincipleId else { return nil }
        return viewModel.getPrinciple(by: id)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.15)
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    mainContent
                }
                
                Spacer()
            }
        }
        .onAppear {
            pickRandomPrinciple()
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateContent = true
            }
        }
        .onChange(of: viewModel.principles.count) { _ in
            if displayedPrincipleId == nil || viewModel.getPrinciple(by: displayedPrincipleId!) == nil {
                pickRandomPrinciple()
            }
        }
        .sheet(item: $detailSheetItem) { item in
            PrincipleDetailView(principleId: item.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Daily Focus")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.appLightGray)
                    .frame(width: 100, height: 100)
                Image(systemName: "quote.bubble")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(Color.appTextBlue.opacity(0.6))
            }
            Text("Add principles to see one here for reflection.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(Color.appTextBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 30) {
            Text("A principle to reflect on today")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(Color.appDarkGray)
            
            ForEach(Array([displayedPrinciple].compactMap { $0 }), id: \.id) { principle in
                principleCard(principle: principle)
            }
        }
        .padding(.top, 20)
    }
    
    private func principleCard(principle: Principle) -> some View {
        VStack(spacing: 20) {
            Text(principle.displayText)
                .font(.playfairDisplay(22, weight: .medium))
                .foregroundColor(Color.appTextBlue)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardGradient)
                        .shadow(color: Color.appTextBlue.opacity(0.15), radius: 16, x: 0, y: 8)
                )
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6), value: animateContent)
            
            HStack(spacing: 16) {
                Button(action: {
                            if let id = displayedPrincipleId {
                                detailSheetItem = DetailSheetItem(id: id)
                            }
                        }) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                        Text("View full")
                            .font(.playfairDisplay(14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.buttonGradient)
                    .cornerRadius(20)
                }
                
                Button(action: pickRandomPrinciple) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Another")
                            .font(.playfairDisplay(14, weight: .semibold))
                    }
                    .foregroundColor(Color.appTextBlue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.appTextBlue.opacity(0.12))
                    .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func pickRandomPrinciple() {
        guard !viewModel.principles.isEmpty else {
            displayedPrincipleId = nil
            return
        }
        displayedPrincipleId = viewModel.principles.randomElement()?.id
    }
}

#Preview {
    DailyPrincipleView(viewModel: PrinciplesViewModel())
}
