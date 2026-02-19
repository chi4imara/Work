import SwiftUI

private struct PrincipleDetailDestination: Identifiable {
    var id: UUID { principleId }
    let principleId: UUID
}

struct PrinciplesListView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @State private var showingAddPrinciple = false
    @State private var selectedDetailDestination: PrincipleDetailDestination?
    @State private var animateItems = false
    
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
                    principlesListView
                }
            }
            VStack {
                Spacer()
                
                addButtonView
            }
        }
        .sheet(isPresented: $showingAddPrinciple) {
            AddPrincipleView(viewModel: viewModel)
        }
        .sheet(item: $selectedDetailDestination) { destination in
            PrincipleDetailView(principleId: destination.principleId, viewModel: viewModel)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateItems = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Principles")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.appLightGray)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "quote.bubble")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(Color.appTextBlue.opacity(0.6))
            }
            .scaleEffect(animateItems ? 1.0 : 0.5)
            .opacity(animateItems ? 1.0 : 0.0)
            
            VStack(spacing: 15) {
                Text("Your principles will appear here.")
                    .font(.playfairDisplay(20, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                
                Text("Add the first one to begin.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.appDarkGray)
            }
            .multilineTextAlignment(.center)
            .opacity(animateItems ? 1.0 : 0.0)
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .animation(.easeOut(duration: 0.8), value: animateItems)
    }
    
    private var principlesListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(Array(viewModel.principles.enumerated()), id: \.element.id) { index, principle in
                    PrincipleCardView(principle: principle) {
                        selectedDetailDestination = PrincipleDetailDestination(principleId: principle.id)
                    }
                    .scaleEffect(animateItems ? 1.0 : 0.8)
                    .opacity(animateItems ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateItems)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 160)
        }
    }
    
    private var addButtonView: some View {
        Button(action: {
            showingAddPrinciple = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Add principle")
                    .font(.playfairDisplay(18, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(AppColors.buttonGradient)
            .cornerRadius(25)
            .shadow(color: Color.appTextBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .scaleEffect(animateItems ? 1.0 : 0.8)
        .opacity(animateItems ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateItems)
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
}

struct PrincipleCardView: View {
    let principle: Principle
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(principle.shortDisplayText)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    Spacer()
                    
                    Text(principle.createdAt, style: .date)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(Color.appDarkGray.opacity(0.7))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    PrinciplesListView(viewModel: PrinciplesViewModel())
}
