import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding(AppConstants.cardPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.mediumCornerRadius)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.mediumCornerRadius)
                        .stroke(AppColors.separatorColor, lineWidth: 1)
                )
        )
    }
}

#Preview {
    CardView {
        VStack {
            Text("Sample Card")
                .font(.ubuntu(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Text("This is a sample card content")
                .font(.ubuntu(.regular, size: 14))
                .foregroundColor(AppColors.secondaryText)
        }
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
