import SwiftUI

struct TipsView: View {
    @State private var selectedCategory: TipCategory = .general
    @State private var expandedTips: Set<UUID> = []
    
    enum TipCategory: String, CaseIterable {
        case general = "General"
        case washing = "Washing"
        case styling = "Styling"
        case maintenance = "Maintenance"
        case products = "Products"
        
        var icon: String {
            switch self {
            case .general:
                return "lightbulb.fill"
            case .washing:
                return "drop.fill"
            case .styling:
                return "wand.and.stars"
            case .maintenance:
                return "scissors"
            case .products:
                return "sparkles"
            }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                categoryFilterView
                
                tipsContentView
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Hair Care Tips")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TipCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, -20)
    }
    
    private var tipsContentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(getTipsForCategory(selectedCategory)) { tip in
                    TipCard(
                        tip: tip,
                        isExpanded: expandedTips.contains(tip.id)
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if expandedTips.contains(tip.id) {
                                expandedTips.remove(tip.id)
                            } else {
                                expandedTips.insert(tip.id)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private func getTipsForCategory(_ category: TipCategory) -> [HairCareTip] {
        return HairCareTip.allTips.filter { $0.category == category }
    }
}

struct CategoryButton: View {
    let category: TipsView.TipCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14))
                
                Text(category.rawValue)
                    .font(AppFonts.callout)
            }
            .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.yellow : AppColors.cardBackground)
            )
        }
    }
}

struct HairCareTip: Identifiable {
    let id = UUID()
    let category: TipsView.TipCategory
    let title: String
    let description: String
    let details: String
    let icon: String
    
    static let allTips: [HairCareTip] = [
        HairCareTip(
            category: .general,
            title: "Regular Trims",
            description: "Get your hair trimmed every 6-8 weeks to prevent split ends and maintain healthy growth.",
            details: "Regular trims help remove damaged ends, which can prevent breakage from traveling up the hair shaft. This keeps your hair looking healthy and promotes better growth.",
            icon: "scissors"
        ),
        HairCareTip(
            category: .general,
            title: "Protect from Heat",
            description: "Always use heat protectant before styling with hot tools to minimize damage.",
            details: "Heat protectants create a barrier between your hair and styling tools, reducing moisture loss and preventing protein damage. Apply evenly before using any heat styling tool.",
            icon: "flame.fill"
        ),
        HairCareTip(
            category: .general,
            title: "Healthy Diet",
            description: "A balanced diet rich in vitamins and proteins supports strong, healthy hair.",
            details: "Hair is made of protein, so ensure you're getting enough in your diet. Vitamins like biotin, vitamin E, and omega-3 fatty acids also contribute to hair health.",
            icon: "leaf.fill"
        ),
        
        HairCareTip(
            category: .washing,
            title: "Water Temperature",
            description: "Use lukewarm water instead of hot water to prevent stripping natural oils.",
            details: "Hot water can strip your scalp of natural oils, leading to dryness and irritation. Lukewarm water effectively cleanses without causing damage.",
            icon: "thermometer"
        ),
        HairCareTip(
            category: .washing,
            title: "Shampoo Technique",
            description: "Focus shampoo on your scalp, not the ends, and massage gently with your fingertips.",
            details: "The scalp produces the most oil and needs the most cleansing. The ends are older and more fragile, so they need gentler treatment. Massage in circular motions to stimulate blood flow.",
            icon: "hand.tap.fill"
        ),
        HairCareTip(
            category: .washing,
            title: "Conditioner Application",
            description: "Apply conditioner from mid-length to ends, avoiding the roots to prevent greasiness.",
            details: "The ends of your hair are the oldest and most damaged, so they benefit most from conditioning. Avoid roots to prevent weighing down your hair and creating an oily appearance.",
            icon: "drop.circle.fill"
        ),
        HairCareTip(
            category: .washing,
            title: "Washing Frequency",
            description: "Wash your hair based on your hair type and lifestyle, not a fixed schedule.",
            details: "Oily hair may need daily washing, while dry hair might only need 2-3 times per week. Listen to your hair's needs rather than following a rigid routine.",
            icon: "calendar"
        ),
        
        HairCareTip(
            category: .styling,
            title: "Air Dry When Possible",
            description: "Let your hair air dry naturally to reduce heat damage and maintain moisture.",
            details: "Air drying is the gentlest method. If you must use heat, use the lowest effective setting and always apply a heat protectant first.",
            icon: "wind"
        ),
        HairCareTip(
            category: .styling,
            title: "Brush Gently",
            description: "Start brushing from the ends and work your way up to prevent breakage.",
            details: "Brushing from the bottom up helps detangle without causing excessive pulling and breakage. Use a wide-tooth comb on wet hair for best results.",
            icon: "comb.fill"
        ),
        HairCareTip(
            category: .styling,
            title: "Protective Styles",
            description: "Use protective hairstyles like braids or buns to minimize daily manipulation.",
            details: "Protective styles reduce friction and breakage by keeping hair contained. They're especially beneficial for longer hair and during sleep.",
            icon: "star.fill"
        ),
        
        HairCareTip(
            category: .maintenance,
            title: "Deep Conditioning",
            description: "Use a deep conditioning treatment once a week to restore moisture and strength.",
            details: "Deep conditioners penetrate the hair shaft more effectively than regular conditioners. Leave on for 15-30 minutes with heat for maximum benefit.",
            icon: "sparkles"
        ),
        HairCareTip(
            category: .maintenance,
            title: "Scalp Care",
            description: "Massage your scalp regularly to stimulate blood flow and promote healthy growth.",
            details: "Scalp massages increase circulation, which brings nutrients to hair follicles. Do this for 5-10 minutes a few times per week for best results.",
            icon: "hand.point.up.left.fill"
        ),
        HairCareTip(
            category: .maintenance,
            title: "Night Protection",
            description: "Use a silk or satin pillowcase to reduce friction and prevent breakage while sleeping.",
            details: "Silk and satin create less friction than cotton, reducing tangles and breakage. You can also wrap your hair in a silk scarf for extra protection.",
            icon: "moon.fill"
        ),
        
        HairCareTip(
            category: .products,
            title: "Read Ingredients",
            description: "Look for products with beneficial ingredients like keratin, argan oil, and biotin.",
            details: "Understanding ingredients helps you choose products suited to your hair's needs. Avoid sulfates if you have dry or color-treated hair.",
            icon: "doc.text.magnifyingglass"
        ),
        HairCareTip(
            category: .products,
            title: "Patch Testing",
            description: "Test new products on a small section of hair before full application.",
            details: "Patch testing helps you identify any adverse reactions or incompatibilities before committing to a full treatment. Wait 24-48 hours to observe results.",
            icon: "checkmark.circle.fill"
        ),
        HairCareTip(
            category: .products,
            title: "Product Rotation",
            description: "Rotate products occasionally to prevent buildup and maintain effectiveness.",
            details: "Hair can become accustomed to products over time. Rotating every few months helps maintain results and prevents product buildup on the scalp.",
            icon: "arrow.triangle.2.circlepath"
        ),
        HairCareTip(
            category: .products,
            title: "Less is More",
            description: "Use the right amount of product - too much can weigh hair down and cause buildup.",
            details: "Start with a small amount and add more if needed. Most products are concentrated and work best when used sparingly.",
            icon: "gauge.with.dots.needle.67percent"
        )
    ]
}

struct TipCard: View {
    let tip: HairCareTip
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: tip.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                        .frame(width: 40, height: 40)
                        .background(AppColors.yellow.opacity(0.2))
                        .cornerRadius(20)
                    
                    Text(tip.title)
                        .font(AppFonts.bodyBold)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Text(tip.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
                
                if isExpanded {
                    Divider()
                        .background(AppColors.primaryText.opacity(0.2))
                    
                    Text(tip.details)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.primaryText.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TipsView()
}
