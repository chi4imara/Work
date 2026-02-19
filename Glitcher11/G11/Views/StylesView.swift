import SwiftUI

struct StylesView: View {
    @ObservedObject private var viewModel = JewelryViewModel.shared
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.styleGroups.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    stylesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Styles")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintbrush")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.accent)
            
            Text("Styles will appear after adding jewelry.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Add your first jewelry piece to see styles organized here.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var stylesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.styleGroups.keys.sorted()), id: \.self) { styleName in
                    let jewelries = viewModel.styleGroups[styleName] ?? []
                    let count = jewelries.count
                    
                    NavigationLink(destination: StyleJewelryView(styleName: styleName, viewModel: viewModel)) {
                        StyleCard(styleName: styleName, count: count)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct StyleCard: View {
    let styleName: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: styleIcon(for: styleName))
                    .font(.title2)
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(styleName)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("\(count) \(count == 1 ? "jewelry" : "jewelries")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(ColorTheme.secondaryText)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func styleIcon(for styleName: String) -> String {
        switch styleName.lowercased() {
        case "minimalism":
            return "circle"
        case "classic":
            return "crown"
        case "boho":
            return "leaf"
        case "romantic":
            return "heart"
        case "modern":
            return "square.stack.3d.up"
        default:
            return "sparkles"
        }
    }
}

#Preview {
    StylesView()
}
