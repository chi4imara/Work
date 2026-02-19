import SwiftUI

struct RandomProductPickerView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedProduct: Product?
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    
    var suitableProducts: [Product] {
        productStore.suitableProducts
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🎲 Random Product Picker")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            if suitableProducts.isEmpty {
                VStack(spacing: 12) {
                    Text("No suitable products available")
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("Add some suitable products to use the random picker")
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                VStack(spacing: 20) {
                    if let product = selectedProduct {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(product.category.color.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Text(product.category.icon)
                                    .font(.system(size: 50))
                            }
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(isSpinning ? .linear(duration: 0.1).repeatForever(autoreverses: false) : .spring(), value: rotationAngle)
                            
                            VStack(spacing: 8) {
                                Text(product.name)
                                    .font(.playfairDisplay(size: 22, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(product.category.rawValue)
                                    .font(.playfairDisplay(size: 14, weight: .medium))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        VStack(spacing: 12) {
                            Text("🎲")
                                .font(.system(size: 60))
                            
                            Text("Tap to pick a random product")
                                .font(.playfairDisplay(size: 14, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                    
                    Button(action: pickRandomProduct) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text(selectedProduct == nil ? "Pick Random Product" : "Pick Another")
                        }
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(ColorManager.whiteText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.buttonGradient)
                        )
                    }
                    .disabled(isSpinning)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func pickRandomProduct() {
        guard !suitableProducts.isEmpty else { return }
        
        isSpinning = true
        rotationAngle = 0
        
        withAnimation(.linear(duration: 0.1).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            selectedProduct = suitableProducts.randomElement()
            isSpinning = false
            rotationAngle = 0
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
