import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Text("Statistics")
                            .font(.bellGothicBold(size: 32))
                            .foregroundColor(Color.theme.textWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 20) {
                        Text("Overview")
                            .font(.bellGothicBold(size: 24))
                            .foregroundColor(Color.theme.textWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 15) {
                            StatCard(
                                title: "Total Bags",
                                value: "\(viewModel.bags.count)",
                                icon: "bag.fill",
                                color: Color.theme.primaryBlue
                            )
                            
                            StatCard(
                                title: "Favorites",
                                value: "\(viewModel.favoriteBags().count)",
                                icon: "heart.fill",
                                color: Color.theme.errorRed
                            )
                        }
                        
                        Text("By Scenario")
                            .font(.bellGothicBold(size: 24))
                            .foregroundColor(Color.theme.textWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 15) {
                            StatCard(
                                title: "Day",
                                value: "\(viewModel.bagCount(for: .day))",
                                icon: "sun.max.fill",
                                color: Color.theme.accentYellow
                            )
                            
                            StatCard(
                                title: "Evening",
                                value: "\(viewModel.bagCount(for: .evening))",
                                icon: "moon.stars.fill",
                                color: Color.theme.darkBlue
                            )
                            
                            StatCard(
                                title: "Travel",
                                value: "\(viewModel.bagCount(for: .travel))",
                                icon: "airplane",
                                color: Color.theme.successGreen
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.bellGothicBold(size: 32))
                .foregroundColor(Color.theme.textWhite)
            
            Text(title)
                .font(.bellGothicRegular(size: 14))
                .foregroundColor(Color.theme.textGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
}

#Preview {
    StatisticsView(viewModel: BagViewModel())
}
