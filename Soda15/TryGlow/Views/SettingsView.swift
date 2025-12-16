import SwiftUI
import StoreKit

struct SettingsView: View {
    private let colorManager = ColorManager.shared
    @State private var selectedCard: Int? = nil
    
    private let settingsItems: [(icon: String, title: String, subtitle: String, action: () -> Void)] = [
        (icon: "star.fill", title: "Rate App", subtitle: "Love the app? Rate us!", action: {}),
        (icon: "envelope.fill", title: "Contact Us", subtitle: "Get in touch", action: {}),
        (icon: "shield.fill", title: "Privacy Policy", subtitle: "Your data protection", action: {}),
        (icon: "doc.text.fill", title: "Terms of Use", subtitle: "User agreement", action: {})
    ]
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 20) {
                            ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                                SettingsCard(
                                    icon: item.icon,
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    index: index,
                                    selectedCard: $selectedCard
                                ) {
                                    handleAction(for: index)
                                }
                            }
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func handleAction(for index: Int) {
        switch index {
        case 0:
            requestAppReview()
        case 1:
            openURL("https://www.termsfeed.com/live/9df2f2bd-4cbb-423a-9612-7920a06399ef")
        case 2:
            openURL("https://www.termsfeed.com/live/9df2f2bd-4cbb-423a-9612-7920a06399ef")
        case 3:
            openURL("https://www.termsfeed.com/live/f3c840e3-f9d5-4abb-8639-c93a48b71dbc")
        default:
            break
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.custom("PlayfairDisplay-Bold", size: 28))
                .foregroundColor(colorManager.primaryWhite)
            
            Spacer()
            
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 24))
                .foregroundColor(colorManager.primaryWhite.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let index: Int
    @Binding var selectedCard: Int?
    let action: () -> Void
    
    private let colorManager = ColorManager.shared
    @State private var isPressed = false
    
    private var isSelected: Bool {
        selectedCard == index
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                selectedCard = index
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                    selectedCard = nil
                }
                action()
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected ? colorManager.accentGradient : 
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    colorManager.primaryPurple.opacity(0.3),
                                    colorManager.secondaryPink.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? Color.clear : colorManager.primaryWhite.opacity(0.2),
                                    lineWidth: 2
                                )
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(
                            isSelected ? colorManager.primaryWhite : colorManager.accentText
                        )
                }
                
                VStack(spacing: 6) {
                    Text(title)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 15))
                        .foregroundColor(colorManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(subtitle)
                        .font(.custom("PlayfairDisplay-Regular", size: 11))
                        .foregroundColor(colorManager.secondaryText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(colorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(
                                isSelected ? colorManager.primaryPurple.opacity(0.5) : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: isSelected ? colorManager.primaryPurple.opacity(0.3) : .black.opacity(0.1),
                        radius: isSelected ? 12 : 8,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.92 : (isSelected ? 1.02 : 1.0))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    private let colorManager = ColorManager.shared
    
    private var totalDiscoveries: Int {
        viewModel.products.count
    }
    
    private var totalNotes: Int {
        viewModel.allComments().count
    }
    
    private var averageRating: Double {
        guard !viewModel.products.isEmpty else { return 0 }
        let sum = viewModel.products.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(viewModel.products.count)
    }
    
    private var categoryCounts: [(category: ProductCategory, count: Int)] {
        ProductCategory.allCases.map { category in
            (category: category, count: viewModel.productsByCategory(category).count)
        }
    }
    
    private var topRatedProducts: [BeautyProduct] {
        viewModel.products.sorted { $0.rating > $1.rating }.prefix(3).map { $0 }
    }
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    headerView
                    
                    overviewCards
                    
                    categoryStatsView
                    
                    if !topRatedProducts.isEmpty {
                        topRatedView
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Statistics")
                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                    .foregroundColor(colorManager.primaryWhite)
                
                Text("Your beauty journey insights")
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(colorManager.primaryWhite.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 24))
                .foregroundColor(colorManager.primaryWhite.opacity(0.7))
        }
    }
    
    private var overviewCards: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatCard(
                    title: "Total Discoveries",
                    value: "\(totalDiscoveries)",
                    icon: "sparkles",
                    gradient: colorManager.accentGradient
                )
                
                StatCard(
                    title: "Average Rating",
                    value: String(format: "%.1f", averageRating),
                    icon: "star.fill",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [colorManager.primaryYellow, colorManager.secondaryOrange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
            
            HStack(spacing: 15) {
                StatCard(
                    title: "Total Notes",
                    value: "\(totalNotes)",
                    icon: "note.text",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [colorManager.primaryPurple, colorManager.secondaryPink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                StatCard(
                    title: "Categories",
                    value: "\(ProductCategory.allCases.count)",
                    icon: "folder.fill",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [colorManager.primaryBlue, colorManager.secondaryGreen]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
        }
    }
    
    private var categoryStatsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("By Category")
                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                .foregroundColor(colorManager.secondaryText)
            
            VStack(spacing: 12) {
                ForEach(categoryCounts, id: \.category) { item in
                    CategoryStatRow(
                        category: item.category,
                        count: item.count,
                        total: totalDiscoveries
                    )
                }
            }
        }
        .padding(20)
        .background(colorManager.cardGradient)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8)
    }
    
    private var topRatedView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Top Rated")
                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                .foregroundColor(colorManager.secondaryText)
            
            VStack(spacing: 12) {
                ForEach(Array(topRatedProducts.enumerated()), id: \.element.id) { index, product in
                    TopRatedRow(product: product, rank: index + 1)
                }
            }
        }
        .padding(20)
        .background(colorManager.cardGradient)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8)
    }
}

struct CategoryStatRow: View {
    let category: ProductCategory
    let count: Int
    let total: Int
    
    private let colorManager = ColorManager.shared
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 18))
                    .foregroundColor(colorManager.accentText)
                    .frame(width: 30)
                
                Text(category.rawValue)
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(colorManager.secondaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.custom("PlayfairDisplay-Bold", size: 16))
                    .foregroundColor(colorManager.accentText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorManager.primaryWhite.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorManager.accentGradient)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct TopRatedRow: View {
    let product: BeautyProduct
    let rank: Int
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colorManager.accentGradient)
                    .frame(width: 35, height: 35)
                
                Text("\(rank)")
                    .font(.custom("PlayfairDisplay-Bold", size: 14))
                    .foregroundColor(colorManager.primaryWhite)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 15))
                    .foregroundColor(colorManager.secondaryText)
                    .lineLimit(1)
                
                Text(product.category.rawValue)
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(colorManager.secondaryText.opacity(0.6))
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= product.rating ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundColor(star <= product.rating ? colorManager.primaryYellow : colorManager.secondaryText.opacity(0.3))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let gradient: LinearGradient
    
    private let colorManager = ColorManager.shared
    
    init(title: String, value: String, icon: String, gradient: LinearGradient? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.gradient = gradient ?? ColorManager.shared.accentGradient
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(colorManager.primaryWhite)
            }
            
            Text(value)
                .font(.custom("PlayfairDisplay-Bold", size: 24))
                .foregroundColor(colorManager.secondaryText)
            
            Text(title)
                .font(.custom("PlayfairDisplay-Regular", size: 12))
                .foregroundColor(colorManager.secondaryText.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(colorManager.cardGradient)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.1), radius: 8)
    }
}

#Preview {
    SettingsView()
}
