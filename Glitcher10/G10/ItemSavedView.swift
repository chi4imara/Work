import SwiftUI

struct ItemSavedView: View {
    let item: ShoppingItem
    let onDone: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(ColorManager.success.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(ColorManager.success)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                }
                .animation(
                    Animation.spring(response: 0.6, dampingFraction: 0.8)
                        .delay(0.2),
                    value: isAnimating
                )
                
                Text("Item Saved")
                    .font(FontManager.ubuntu(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: isAnimating)
                
                VStack(alignment: .leading, spacing: 16) {
                    ItemDetailRow(title: "Name", value: item.name)
                    ItemDetailRow(title: "Category", value: item.category)
                    ItemDetailRow(title: "Quantity", value: item.quantity)
                    ItemDetailRow(
                        title: "Comment",
                        value: item.comment.isEmpty ? "No comment added." : item.comment
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorManager.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: isAnimating)
                
                Spacer()
                
                Button(action: onDone) {
                    HStack {
                        Text("Done")
                        Image(systemName: "arrow.right")
                    }
                    .font(FontManager.ubuntu(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(ColorManager.orangeGradient)
                    .cornerRadius(16)
                    .shadow(color: ColorManager.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.8), value: isAnimating)
            }
            .padding(.top, 20)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ItemDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(FontManager.ubuntu(size: 14, weight: .medium))
                .foregroundColor(ColorManager.lightBlue)
            
            Text(value)
                .font(FontManager.ubuntu(size: 16))
                .foregroundColor(ColorManager.white)
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ItemSavedView(
        item: ShoppingItem(
            name: "Motor Oil 5W-30",
            category: "Oils",
            quantity: "1",
            comment: "For winter maintenance"
        )
    ) {
        print("Done tapped")
    }
}
