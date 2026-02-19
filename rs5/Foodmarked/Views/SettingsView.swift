import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var showingClearAlert = false
    @State private var showingRateAlert = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Settings")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        SettingsSection(title: "Data Management") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "square.and.arrow.up",
                                    title: "Export List",
                                    subtitle: "Share your product list",
                                    iconColor: ColorManager.primaryBlue,
                                    isDisabled: productStore.products.isEmpty
                                ) {
                                    showingShareSheet = true
                                }
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "trash.circle",
                                    title: "Clear All Products",
                                    subtitle: "Remove all products from your list",
                                    iconColor: ColorManager.unsuitableRed,
                                    isDestructive: true,
                                    isDisabled: productStore.products.isEmpty
                                ) {
                                    showingClearAlert = true
                                }
                            }
                        }
                        
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "star.circle",
                                    title: "Rate App",
                                    subtitle: "Rate us on the App Store",
                                    iconColor: ColorManager.primaryYellow
                                ) {
                                    requestAppReview()
                                }
                                
                                Divider()
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "envelope.circle",
                                    title: "Contact Us",
                                    subtitle: "Send us your feedback",
                                    iconColor: ColorManager.primaryBlue
                                ) {
                                    openURL("https://www.termsfeed.com/live/6ddf6d82-8271-4af4-8395-74f2282f6d43")
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "doc.text.fill",
                                title: "Privacy Policy",
                                subtitle: "Read our privacy policy",
                                iconColor: ColorManager.secondaryText
                            ) {
                                openURL("https://www.termsfeed.com/live/6ddf6d82-8271-4af4-8395-74f2282f6d43")
                            }
                        }
                        
                        if !productStore.products.isEmpty {
                            SettingsSection(title: "Statistics") {
                                VStack(spacing: 16) {
                                    StatisticRow(
                                        title: "Total Products",
                                        value: "\(productStore.products.count)"
                                    )
                                    
                                    StatisticRow(
                                        title: "Suitable Products",
                                        value: "\(productStore.suitableProducts.count)"
                                    )
                                    
                                    StatisticRow(
                                        title: "Not Suitable Products",
                                        value: "\(productStore.unsuitableProducts.count)"
                                    )
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
        }
        .alert("Clear All Products", isPresented: $showingClearAlert) {
            Button("Clear All", role: .destructive) {
                productStore.clearAllProducts()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove all products from your list? This action cannot be undone.")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [productStore.exportProducts()])
        }
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

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let iconColor: Color
    let isDestructive: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        iconColor: Color,
        isDestructive: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.iconColor = iconColor
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isDisabled ? ColorManager.secondaryText.opacity(0.5) : iconColor)
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(isDisabled ? ColorManager.secondaryText.opacity(0.5) : 
                                       (isDestructive ? ColorManager.unsuitableRed : ColorManager.primaryText))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.playfairDisplay(size: 13, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText.opacity(isDisabled ? 0.5 : 1.0))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText.opacity(isDisabled ? 0.3 : 1.0))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .disabled(isDisabled)
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(size: 15, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(size: 15, weight: .bold))
                .foregroundColor(ColorManager.primaryBlue)
        }
        .padding(.horizontal, 20)
    }
}
