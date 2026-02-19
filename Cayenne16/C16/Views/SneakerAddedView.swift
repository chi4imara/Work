import SwiftUI

struct SneakerAddedView: View {
    let sneaker: Sneaker
    let onDismiss: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(ColorManager.successGreen.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(ColorManager.successGreen)
                }
                
                Text("Pair Added")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Model", value: sneaker.model)
                    DetailRow(title: "Purchase Date", value: dateFormatter.string(from: sneaker.purchaseDate))
                    DetailRow(title: "Condition", value: sneaker.condition.rawValue)
                    DetailRow(
                        title: "Comment",
                        value: sneaker.comment.isEmpty ? "No comment added." : sneaker.comment
                    )
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardGradient)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Text("Done")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(ColorManager.primaryText)
        }
    }
}

#Preview {
    SneakerAddedView(
        sneaker: Sneaker(
            model: "Nike Air Max 270",
            purchaseDate: Date(),
            condition: .new,
            comment: "Great for running"
        )
    ) {
        print("Dismissed")
    }
}
