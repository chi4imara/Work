import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Statistics")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.vertical, 10)
                
                if viewModel.projects.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.primaryText.opacity(0.5))
                        
                        Text("No statistics available yet.")
                            .font(.ubuntu(18))
                            .foregroundColor(ColorManager.primaryText.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                        Text("Create your first project to see statistics.")
                            .font(.ubuntu(14))
                            .foregroundColor(ColorManager.primaryText.opacity(0.5))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            StatisticsCard(
                                title: "Total Projects",
                                value: "\(viewModel.projects.count)",
                                icon: "folder",
                                color: ColorManager.lightBlue
                            )
                            
                            StatisticsCard(
                                title: "Completed Projects",
                                value: "\(completedProjectsCount)",
                                icon: "checkmark.circle",
                                color: ColorManager.success
                            )
                            
                            StatisticsCard(
                                title: "In Progress",
                                value: "\(inProgressProjectsCount)",
                                icon: "clock",
                                color: ColorManager.orange
                            )
                            
                            StatisticsCard(
                                title: "Categories",
                                value: "\(categoriesCount)",
                                icon: "tag",
                                color: ColorManager.lightBlue.opacity(0.8)
                            )
                            
                            if !viewModel.getCategoriesWithCount().isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Category Breakdown")
                                        .font(.ubuntu(20, weight: .bold))
                                        .foregroundColor(ColorManager.primaryText)
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(viewModel.getCategoriesWithCount(), id: \.category) { categoryInfo in
                                        CategoryStatRow(
                                            category: categoryInfo.category,
                                            count: categoryInfo.count,
                                            total: viewModel.projects.count
                                        )
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
    
    private var completedProjectsCount: Int {
        viewModel.projects.filter { !$0.result.isEmpty }.count
    }
    
    private var inProgressProjectsCount: Int {
        viewModel.projects.filter { $0.result.isEmpty }.count
    }
    
    private var categoriesCount: Int {
        Set(viewModel.projects.map { $0.category }).count
    }
}

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText.opacity(0.8))
                
                Text(value)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.capitalized)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(count) project\(count == 1 ? "" : "s")")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorManager.primaryText.opacity(0.7))
                
                Text("(\(Int(percentage * 100))%)")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorManager.primaryText.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorManager.lightBlue, ColorManager.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StatisticsView(viewModel: ProjectViewModel())
}
