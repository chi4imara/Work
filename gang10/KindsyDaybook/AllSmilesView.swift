import SwiftUI

struct AllSmilesView: View {
    @StateObject private var viewModel = AllSmilesViewModel()
    @State private var bubbles: [MovingBubble] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
            
            VStack {
                HStack {
                    Text("All Smiles")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showingFilter = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
                
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.groupedSmiles, id: \.0) { date, smiles in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(dateString(from: date))
                                            .font(.ubuntu(18, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Text("\(smiles.count) smile\(smiles.count == 1 ? "" : "s")")
                                            .font(.ubuntu(14, weight: .regular))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    ForEach(smiles) { smile in
                                        SmileCardView(smile: smile) {
                                            viewModel.showingSmileDetail = SmileDetailID(id: smile.id)
                                        }
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .onAppear {
            generateBubbles()
        }
        .sheet(isPresented: $viewModel.showingFilter) {
            FilterView(filter: $viewModel.filter) {
                viewModel.applyFilter()
            } onReset: {
                viewModel.resetFilter()
            }
        }
        .sheet(item: $viewModel.showingSmileDetail) { smileDetailID in
            if let smile = viewModel.groupedSmiles.flatMap(\.1).first(where: { $0.id == smileDetailID.id }) {
                SmileDetailView(smile: smile) { updatedSmile in
                } onDelete: { smileToDelete in
                    viewModel.deleteSmile(smileToDelete)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sun.max")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 12) {
                Text("No saved smiles yet.")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start capturing those beautiful moments that make you smile.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: AddEditSmileView()) {
                Text("Add First Smile")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.skyBlue)
                    .frame(width: 200, height: 50)
                    .background(AppColors.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func generateBubbles() {
        bubbles = (0..<8).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...45),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 15...30)
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

struct FilterView: View {
    @Binding var filter: SmileFilter
    let onApply: () -> Void
    let onReset: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Period")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        VStack(spacing: 8) {
                            ForEach(SmileFilter.Period.allCases, id: \.self) { period in
                                Button(action: {
                                    filter.period = period
                                }) {
                                    HStack {
                                        Text(period.title)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        if filter.period == period {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(AppColors.yellow)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.white.opacity(filter.period == period ? 0.3 : 0.1))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Search")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Search by keywords...", text: $filter.searchText)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(AppColors.white.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            onApply()
                            dismiss()
                        }) {
                            Text("Apply")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.skyBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.white)
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            onReset()
                            dismiss()
                        }) {
                            Text("Reset")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.white.opacity(0.2))
                                .cornerRadius(25)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    AllSmilesView()
}
