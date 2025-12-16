import SwiftUI

struct ShoppingTipsView: View {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                    .frame(width: CGFloat.random(in: 25...55))
                    .position(
                        x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                        y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                headerView
                
                tipsListView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Shopping Tips")
                .font(FontManager.ubuntuBold(28))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 24))
                .foregroundColor(ColorManager.primaryYellow)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var tipsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ShoppingTip.tips) { tip in
                    TipCardView(tip: tip)
                }
                
                Button(action: {
                    withAnimation {
                        appViewModel.selectedTab = 0
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Back to List")
                            .font(FontManager.ubuntuMedium(18))
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .concaveCard(cornerRadius: 25, depth: 4, color: ColorManager.primaryYellow)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct TipCardView: View {
    let tip: ShoppingTip
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(tip.title)
                        .font(FontManager.ubuntuBold(18))
                        .foregroundColor(ColorManager.primaryBlue)
                        .multilineTextAlignment(.leading)
                    
                    if isExpanded {
                        Text(tip.description)
                            .font(FontManager.ubuntu(15))
                            .foregroundColor(ColorManager.primaryBlue.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.primaryBlue)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .concaveCard(cornerRadius: 12, depth: 3, color: ColorManager.cardBackground)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        }
    }
}

