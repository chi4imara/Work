import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: WatchViewModel
    @State private var selectedWatch: Watch?
    @State private var showingWatchDetails = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Collection")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                if viewModel.watches.isEmpty {
                    VStack(spacing: 30) {
                        Image(systemName: "applewatch.slash")
                            .font(.system(size: 80, weight: .thin))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("You haven't added any watches yet.")
                            .font(.playfairDisplay(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.watches) { watch in
                                WatchCard(watch: watch) {
                                    selectedWatch = watch
                                    showingWatchDetails = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedWatch) { watch in
            WatchDetailsView(
                watch: watch,
                viewModel: viewModel,
                isPresented: $showingWatchDetails
            )
        }
    }
}

struct WatchCard: View {
    let watch: Watch
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: "applewatch")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(ColorManager.lightBlue.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(watch.name)
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .lineLimit(2)
                    
                    Text("Added \(formatDate(watch.purchaseDate))")
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                DetailBadge(title: "Style", value: watch.style.displayName, color: ColorManager.lightBlue)
                DetailBadge(title: "Condition", value: watch.condition.displayName, color: ColorManager.orange)
            }
            
            Button(action: onTap) {
                HStack {
                    Text("Open")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(ColorManager.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [ColorManager.lightBlue, ColorManager.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(22)
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.playfairDisplay(size: 10, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
                .textCase(.uppercase)
            
            Text(value)
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    CollectionView(viewModel: WatchViewModel())
}
