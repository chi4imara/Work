import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedSneaker: Sneaker?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Collection")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                
                if dataManager.sneakers.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "shippingbox")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("You haven't added any pairs yet.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(dataManager.sneakers) { sneaker in
                                SneakerCard(
                                    sneaker: sneaker,
                                    dateFormatter: dateFormatter
                                ) {
                                    selectedSneaker = sneaker
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedSneaker) { sneaker in
            SneakerDetailView(sneaker: sneaker)
        }
    }
}

struct SneakerCard: View {
    let sneaker: Sneaker
    let dateFormatter: DateFormatter
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(sneaker.model)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Purchase Date:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: sneaker.purchaseDate))
                        .font(.ubuntu(14))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                HStack {
                    Text("Condition:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Spacer()
                    
                    Text(sneaker.condition.rawValue)
                        .font(.ubuntu(14))
                        .foregroundColor(ColorManager.primaryText)
                }
            }
            
            Button(action: onTap) {
                Text("Open")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [ColorManager.lightBlue, ColorManager.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
}

#Preview {
    CollectionView()
        .environmentObject(DataManager.shared)
}
