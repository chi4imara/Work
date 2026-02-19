import SwiftUI

struct StyleJewelryView: View {
    let styleName: String
    @ObservedObject var viewModel: JewelryViewModel
    
    private var jewelriesForStyle: [Jewelry] {
        viewModel.getJewelriesForStyle(styleName)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if jewelriesForStyle.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    jewelryList
                }
            }
        }
        .navigationTitle(styleName)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.accent)
            
            Text("No jewelry in this style yet.")
                .font(.playfairDisplay(20, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Add jewelry pieces with the \(styleName) style to see them here.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var jewelryList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(jewelriesForStyle) { jewelry in
                    NavigationLink(destination: JewelryDetailView(jewelry: jewelry, viewModel: viewModel)) {
                        StyleJewelryCard(jewelry: jewelry)
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

struct StyleJewelryCard: View {
    let jewelry: Jewelry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(jewelry.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                Text(jewelry.type.displayName)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.accentText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorTheme.orange.opacity(0.2))
                    .cornerRadius(8)
                
                if !jewelry.note.isEmpty {
                    Text(jewelry.note)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack {
                if jewelry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ColorTheme.orange)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTheme.secondaryText)
                    .font(.system(size: 14))
            }
        }
        .padding(16)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        StyleJewelryView(styleName: "Minimalism", viewModel: JewelryViewModel.shared)
    }
}
