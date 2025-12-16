import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var bubbles: [MovingBubble] = []
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    welcomeSection
                    
                    addSmileButton
                    
                    if viewModel.todaysSmiles.isEmpty {
                        emptyStateView
                    } else {
                        smilesListView
                        statisticsView
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            generateBubbles()
        }
        .sheet(isPresented: $viewModel.showingAddSmile) {
            AddEditSmileView()
        }
        .sheet(item: $viewModel.showingSmileDetail) { smileDetailID in
            if let smile = viewModel.todaysSmiles.first(where: { $0.id == smileDetailID.id }) {
                SmileDetailView(smile: smile) { updatedSmile in
                } onDelete: { smileToDelete in
                    viewModel.deleteSmile(smileToDelete)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Smile Diary")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Menu {
                Button("All Records") {
                    withAnimation {
                        selectedTab = 1
                    }
                }
                Button("My Thoughts") {
                    withAnimation {
                        selectedTab = 2
                    }
                }
                Button("Statistics") {
                    withAnimation {
                        selectedTab = 3
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(AppColors.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding(.top, 10)
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 12) {
            Text("Was there a reason to smile today?")
                .font(.ubuntu(22, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Record this moment — let it stay with you.")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var addSmileButton: some View {
        Button(action: {
            viewModel.showingAddSmile = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Add Smile")
                    .font(.ubuntu(16, weight: .medium))
            }
            .foregroundColor(AppColors.skyBlue)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var smilesListView: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.todaysSmiles) { smile in
                SmileCardView(smile: smile) {
                    viewModel.showingSmileDetail = SmileDetailID(id: smile.id)
                }
            }
        }
    }
    
    private var statisticsView: some View {
        Text("Today you noticed \(viewModel.todaysSmilesCount) smile\(viewModel.todaysSmilesCount == 1 ? "" : "s")")
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(AppColors.accentText)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(AppColors.white.opacity(0.2))
            .cornerRadius(12)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "face.smiling")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow)
            
            Text("You haven't recorded any smiles today yet.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: {
                viewModel.showingAddSmile = true
            }) {
                Text("Add First Smile")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.skyBlue)
                    .frame(width: 200, height: 44)
                    .background(AppColors.white)
                    .cornerRadius(22)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
    }
    
    private func generateBubbles() {
        bubbles = (0..<10).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...50),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 12...25)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
    }
}

struct SmileCardView: View {
    let smile: Smile
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "face.smiling")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(smile.shortText)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()
                }
                
                Spacer()
                
                Text(smile.timeString)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

