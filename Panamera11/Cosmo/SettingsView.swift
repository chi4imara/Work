import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContent
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Customize your experience")
                    .font(.bellGothic(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.accentYellow)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 30) {
                settingsCardsGrid
                
                appInfoSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var settingsCardsGrid: some View {
        VStack(spacing: 20) {
            SettingsCard(
                title: "Privacy Policy",
                icon: "shield.checkerboard",
                gradient: LinearGradient(
                    colors: [AppColors.successGreen, AppColors.successGreen.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) {
                openURL("https://www.privacypolicies.com/live/0d188095-65d7-49c9-b6d1-5a3349320e52")
            }
            
            SettingsCard(
                title: "Contact Us",
                icon: "envelope.circle.fill",
                gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.lightBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) {
                openURL("https://www.privacypolicies.com/live/0d188095-65d7-49c9-b6d1-5a3349320e52")
            }
            
            SettingsCard(
                title: "Rate App",
                icon: "star.fill",
                gradient: LinearGradient(
                    colors: [AppColors.accentYellow, AppColors.brightYellow],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) {
                requestReview()
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Cosmo Beauty Catalog")
                    .font(.bellGothic(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Your personal beauty collection organizer")
                    .font(.bellGothic(12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                    )
            )
            
            HStack(spacing: 12) {
                ForEach(0..<5) { _ in
                    Circle()
                        .fill(AppColors.accentYellow.opacity(0.6))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryText.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Text(title)
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(gradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}


struct StatisticsView: View {
    @ObservedObject var viewModel: CosmeticsViewModel
    
    init(viewModel: CosmeticsViewModel? = nil) {
        if let viewModel = viewModel {
            self._viewModel = ObservedObject(wrappedValue: viewModel)
        } else {
            self._viewModel = ObservedObject(wrappedValue: CosmeticsViewModel())
        }
    }
    
    private var daysActive: Int {
        guard let firstProduct = viewModel.products.min(by: { $0.dateAdded < $1.dateAdded }) else {
            return 1
        }
        let days = Calendar.current.dateComponents([.day], from: firstProduct.dateAdded, to: Date()).day ?? 1
        return max(days, 1)
    }
    
    private var productsWithPhotos: Int {
        viewModel.products.filter { $0.hasImage }.count
    }
    
    private var topProductType: (type: ProductType, count: Int)? {
        let grouped = Dictionary(grouping: viewModel.products) { $0.productType }
        return grouped.max(by: { $0.value.count < $1.value.count })
            .map { (type: $0.key, count: $0.value.count) }
    }
    
    private var topTexture: (texture: Texture, count: Int)? {
        let grouped = Dictionary(grouping: viewModel.products) { $0.texture }
        return grouped.max(by: { $0.value.count < $1.value.count })
            .map { (texture: $0.key, count: $0.value.count) }
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    statsGrid
                    
                    distributionSection
                    
                    insightsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [AppColors.accentYellow, AppColors.brightYellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primaryText)
                )
                .shadow(color: AppColors.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 8) {
                Text("Your Statistics")
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Track your beauty collection")
                    .font(.bellGothic(16))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.top, 20)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Total Products",
                value: "\(viewModel.products.count)",
                icon: "sparkles",
                gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.lightBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            StatCard(
                title: "Favorites",
                value: "\(viewModel.favoriteProducts.count)",
                icon: "heart.fill",
                gradient: LinearGradient(
                    colors: [AppColors.errorRed.opacity(0.8), AppColors.errorRed],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            StatCard(
                title: "Categories",
                value: "\(viewModel.categories.count)",
                icon: "folder.fill",
                gradient: LinearGradient(
                    colors: [AppColors.successGreen.opacity(0.8), AppColors.successGreen],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            StatCard(
                title: "Days Active",
                value: "\(daysActive)",
                icon: "calendar",
                gradient: LinearGradient(
                    colors: [AppColors.warningOrange.opacity(0.8), AppColors.warningOrange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    private var distributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distribution")
                .font(.bellGothic(22, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 16) {
                if let topType = topProductType, viewModel.products.count > 0 {
                    DistributionCard(
                        title: "Most Popular Type",
                        value: topType.type.displayName,
                        count: topType.count,
                        total: viewModel.products.count,
                        icon: "star.fill"
                    )
                }
                
                if let topTexture = topTexture, viewModel.products.count > 0 {
                    DistributionCard(
                        title: "Most Popular Texture",
                        value: topTexture.texture.displayName,
                        count: topTexture.count,
                        total: viewModel.products.count,
                        icon: "paintbrush.fill"
                    )
                }
            }
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.bellGothic(22, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                InsightRow(
                    icon: "photo.fill",
                    title: "Products with Photos",
                    value: "\(productsWithPhotos) / \(viewModel.products.count)",
                    percentage: viewModel.products.isEmpty ? 0 : Double(productsWithPhotos) / Double(viewModel.products.count)
                )
                
                InsightRow(
                    icon: "heart.fill",
                    title: "Favorite Rate",
                    value: "\(viewModel.favoriteProducts.count) / \(viewModel.products.count)",
                    percentage: viewModel.products.isEmpty ? 0 : Double(viewModel.favoriteProducts.count) / Double(viewModel.products.count)
                )
                
                if viewModel.products.count > 0 {
                    InsightRow(
                        icon: "chart.pie.fill",
                        title: "Collection Growth",
                        value: "\(viewModel.products.count) items",
                        percentage: min(Double(viewModel.products.count) / 50.0, 1.0)
                    )
                }
            }
        }
    }
}

struct DistributionCard: View {
    let title: String
    let value: String
    let count: Int
    let total: Int
    let icon: String
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.accentYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.bellGothic(14))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                HStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.cardBackground)
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.accentYellow)
                                .frame(width: geometry.size.width * percentage, height: 6)
                        }
                    }
                    .frame(height: 6)
                    
                    Text("\(Int(percentage * 100))%")
                        .font(.bellGothic(12))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.bellGothic(24, weight: .bold))
                .foregroundColor(AppColors.accentYellow)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.bellGothic(14))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.cardBackground)
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.accentYellow, AppColors.brightYellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * percentage, height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.accentYellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient
    
    init(title: String, value: String, icon: String, gradient: LinearGradient = AppColors.cardGradient) {
        self.title = title
        self.value = value
        self.icon = icon
        self.gradient = gradient
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryText.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Text(value)
                .font(.bellGothic(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.bellGothic(12))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    SettingsView()
}
