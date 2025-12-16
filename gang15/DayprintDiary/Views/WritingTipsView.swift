import SwiftUI

struct WritingTipsView: View {
    let onDismiss: () -> Void
    
    private let tips = [
        WritingTip(
            title: "How to Start",
            content: "Write the first thing that comes to mind. It can be a moment, smell, word, or feeling.",
            icon: "lightbulb.fill"
        ),
        WritingTip(
            title: "What You Can Remember",
            content: "A phrase, glance, rain, taste, place, meeting, sound, smile.",
            icon: "heart.fill"
        ),
        WritingTip(
            title: "Why Write",
            content: "Each entry is a small anchor. It holds the day when everything else is forgotten.",
            icon: "arrowshape.down.fill"
        ),
        WritingTip(
            title: "Example",
            content: "Today: conversation at the bus stop, smell of coffee and a short \"thank you\".",
            icon: "quote.bubble.fill"
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.orb1)
                        .frame(width: 35 + CGFloat(index * 10))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: 4 + Double(index))
                                .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.xl) {
                            headerView
                            
                            introductionView
                            
                            LazyVStack(spacing: AppTheme.Spacing.lg) {
                                ForEach(tips.indices, id: \.self) { index in
                                    tipCardView(tips[index])
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)
                                        ))
                                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: tips.count)
                                }
                            }
                            
                            bottomButtonView
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.lg)
                    }
            }
        }
    }
        
    private var headerView: some View {
        HStack {
            Text("Writing Tips")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
    }
        
    private var introductionView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Text("Need inspiration for your daily memory?")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Here are some gentle suggestions to help you capture the essence of your day.")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }
        
    private func tipCardView(_ tip: WritingTip) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: tip.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.Colors.accent.opacity(0.2))
                    .cornerRadius(AppTheme.CornerRadius.sm)
                
                Text(tip.title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
            }
            
            Text(tip.content)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(2)
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.lg)
    }
        
    private var bottomButtonView: some View {
        Button(action: onDismiss) {
            Text("Got It")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.primaryPurple)
                .cornerRadius(AppTheme.CornerRadius.md)
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
        
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.1, y: height * 0.2),
            CGPoint(x: width * 0.9, y: height * 0.35),
            CGPoint(x: width * 0.15, y: height * 0.7),
            CGPoint(x: width * 0.85, y: height * 0.85)
        ]
        
        return positions[index % positions.count]
    }
}

struct WritingTip {
    let title: String
    let content: String
    let icon: String
}

#Preview {
    WritingTipsView {
        print("Tips dismissed")
    }
}
