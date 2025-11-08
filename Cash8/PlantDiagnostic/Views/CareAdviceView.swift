import SwiftUI

struct CareAdviceView: View {
    @State private var careAdvice: [CareAdvice] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if isLoading {
                        loadingView
                    } else if careAdvice.isEmpty {
                        emptyStateView
                    } else {
                        adviceListView
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadAdvice()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Care Tips")
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.accentGreen)
            
            Text("Loading tips...")
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText)
            
            Text("Tips not available")
                .font(.titleMedium)
                .foregroundColor(.primaryText)
            
            Button("Refresh") {
                loadAdvice()
            }
            .font(.buttonText)
            .foregroundColor(.buttonText)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppGradients.buttonGradient)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var adviceListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(careAdvice) { advice in
                    NavigationLink(destination: CareAdviceDetailView(advice: advice)) {
                        CareAdviceCardView(advice: advice)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private func loadAdvice() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            careAdvice = CareAdviceDataManager.shared.getAllAdvice()
            isLoading = false
        }
    }
}

struct CareAdviceCardView: View {
    let advice: CareAdvice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon(advice.category))
                    .font(.system(size: 24))
                    .foregroundColor(categoryColor(advice.category))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(advice.title)
                        .font(.titleSmall)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(advice.description)
                        .font(.bodySmall)
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
            }
            
            HStack {
                Text(advice.category.rawValue)
                    .font(.caption)
                    .foregroundColor(categoryColor(advice.category))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor(advice.category).opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    private func categoryIcon(_ category: CareAdvice.Category) -> String {
        switch category {
        case .watering:
            return "drop.fill"
        case .repotting:
            return "arrow.up.and.down.and.arrow.left.and.right"
        case .fertilizing:
            return "leaf.arrow.circlepath"
        case .lighting:
            return "sun.max.fill"
        case .diseases:
            return "cross.fill"
        case .general:
            return "info.circle.fill"
        }
    }
    
    private func categoryColor(_ category: CareAdvice.Category) -> Color {
        switch category {
        case .watering:
            return .accentBlue
        case .repotting:
            return .accentOrange
        case .fertilizing:
            return .accentGreen
        case .lighting:
            return .yellow
        case .diseases:
            return .red
        case .general:
            return .accentPurple
        }
    }
}

#Preview {
    CareAdviceView()
}


