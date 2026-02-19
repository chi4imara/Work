import SwiftUI

struct MainTabView: View {
    @StateObject private var proceduresViewModel = ProceduresViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NewProcedureView(viewModel: proceduresViewModel)
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("New")
                    }
                    .tag(0)
                
                HistoryView(viewModel: proceduresViewModel)
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
                    .tag(1)
                
                ProductsView(viewModel: proceduresViewModel)
                    .tabItem {
                        Image(systemName: "drop.triangle")
                        Text("Products")
                    }
                    .tag(2)
                
                StatisticsView(viewModel: proceduresViewModel)
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Stats")
                    }
                    .tag(3)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(4)
            }
            .accentColor(AppColors.orange)
            .preferredColorScheme(.dark)
            
            if proceduresViewModel.showingProcedureSaved,
               let savedProcedure = proceduresViewModel.savedProcedure {
                ProcedureSavedView(procedure: savedProcedure) {
                    proceduresViewModel.showingProcedureSaved = false
                    proceduresViewModel.savedProcedure = nil
                }
                .transition(.opacity.combined(with: .scale))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: proceduresViewModel.showingProcedureSaved)
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: ProceduresViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.procedures.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.lightBlue.opacity(0.6))
                        
                        Text("No data available for statistics.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            StatCard(
                                title: "Total Procedures",
                                value: "\(viewModel.procedures.count)",
                                icon: "scissors",
                                color: AppColors.orange
                            )
                            
                            if let mostUsedProduct = viewModel.getProductStatistics().first {
                                StatCard(
                                    title: "Most Used Product",
                                    value: mostUsedProduct.name,
                                    subtitle: "\(mostUsedProduct.usageCount) times",
                                    icon: "drop.fill",
                                    color: AppColors.lightBlue
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Procedure Types")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.white)
                                
                                ForEach(ProcedureType.allCases, id: \.self) { type in
                                    let count = viewModel.procedures.filter { $0.type == type }.count
                                    if count > 0 {
                                        HStack {
                                            Text(type.displayName)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.white)
                                            
                                            Spacer()
                                            
                                            Text("\(count)")
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(AppColors.orange)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardGradient)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var subtitle: String? = nil
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}
