import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    private var forgottenProducts: [Product] {
        appViewModel.allProducts
            .filter { product in
                guard let lastUsed = product.lastUsedDate else {
                    let daysSinceCreated = Calendar.current.dateComponents([.day], from: product.createdAt, to: Date()).day ?? 0
                    return daysSinceCreated > 30
                }
                let daysSinceLastUse = Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
                return daysSinceLastUse > 60
            }
            .sorted { product1, product2 in
                let days1 = product1.lastUsedDate != nil ? 
                    Calendar.current.dateComponents([.day], from: product1.lastUsedDate!, to: Date()).day ?? 0 :
                    Calendar.current.dateComponents([.day], from: product1.createdAt, to: Date()).day ?? 0
                let days2 = product2.lastUsedDate != nil ?
                    Calendar.current.dateComponents([.day], from: product2.lastUsedDate!, to: Date()).day ?? 0 :
                    Calendar.current.dateComponents([.day], from: product2.createdAt, to: Date()).day ?? 0
                return days1 > days2
            }
            .prefix(10)
            .map { $0 }
    }
    
    private var expiringProducts: [Product] {
        appViewModel.allProducts
            .filter { $0.isExpiringSoon && !$0.isExpired }
            .sorted { product1, product2 in
                guard let date1 = product1.expirationDate, let date2 = product2.expirationDate else {
                    return false
                }
                return date1 < date2
            }
            .prefix(10)
            .map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if !expiringProducts.isEmpty {
                RecommendationsSection(
                    title: "Expiring Soon",
                    icon: "exclamationmark.triangle.fill",
                    color: AppColors.warningRed,
                    products: expiringProducts,
                    message: "These products are expiring soon. Use them before they expire!"
                )
            }
            
            if !forgottenProducts.isEmpty {
                RecommendationsSection(
                    title: "Forgotten Products",
                    icon: "clock.badge.questionmark",
                    color: AppColors.primaryYellow,
                    products: forgottenProducts,
                    message: "You haven't used these products in a while. Maybe it's time to rediscover them?"
                )
            }
            
            if expiringProducts.isEmpty && forgottenProducts.isEmpty {
                EmptyRecommendationsView()
            }
        }
    }
}

struct RecommendationsSection: View {
    let title: String
    let icon: String
    let color: Color
    let products: [Product]
    let message: String
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                    
                    Text("\(products.count) products")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.darkText)
                }
                
                Spacer()
            }
            
            Text(message)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(AppColors.darkText)
                .padding(.leading, 56)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products, id: \.id) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            RecommendationCard(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(20)
        .background(AppColors.cardBackground.opacity(0.9))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct RecommendationCard: View {
    let product: Product
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: categoryIcon(for: product.category))
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(2)
                
                Text(product.brand)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.accentPurple)
            }
            
            if product.isExpiringSoon {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.warningRed)
                    
                    if let expirationDate = product.expirationDate {
                        Text("Expires: \(DateFormatter.shortDate.string(from: expirationDate))")
                            .font(.ubuntu(10, weight: .medium))
                            .foregroundColor(AppColors.warningRed)
                    }
                }
            } else if let lastUsed = product.lastUsedDate {
                HStack {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                    
                    let days = Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
                    Text("\(days) days ago")
                        .font(.ubuntu(10, weight: .medium))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                }
            } else {
                let days = Calendar.current.dateComponents([.day], from: product.createdAt, to: Date()).day ?? 0
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                    
                    Text("Added \(days) days ago")
                        .font(.ubuntu(10, weight: .medium))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                }
            }
            
            Button(action: {
                appViewModel.markProductAsUsed(product)
            }) {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                    Text("Use Now")
                        .font(.ubuntu(11, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(AppColors.buttonBackground)
                .cornerRadius(8)
            }
        }
        .padding(12)
        .frame(width: 140)
        .frame(maxHeight: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .lipstick, .lipgloss: return "mouth.fill"
        case .foundation, .concealer: return "face.smiling.fill"
        case .eyeshadow: return "eye.fill"
        case .mascara, .eyeliner: return "eye.trianglebadge.exclamationmark.fill"
        case .blush, .bronzer: return "face.dashed.fill"
        case .highlighter: return "sparkles"
        case .primer, .powder: return "circle.fill"
        case .skincare: return "drop.fill"
        case .other: return "star.fill"
        }
    }
}

struct EmptyRecommendationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(AppColors.successGreen)
            
            VStack(spacing: 8) {
                Text("All Good!")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("No products need attention right now.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, 40)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    RecommendationsView()
        .environmentObject(AppViewModel())
}
