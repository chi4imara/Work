import SwiftUI

struct FontDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text("Custom Fonts Demo")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Poppins Bold - Large Title")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins SemiBold - Title")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins SemiBold - Title 2")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins SemiBold - Headline")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Body")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Callout")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Subheadline")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Footnote")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Caption")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Medium - Button")
                        .font(AppFonts.button)
                        .foregroundColor(AppColors.primaryOrange)
                    
                    Text("Poppins Bold - Navigation Title")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins SemiBold - Card Title")
                        .font(AppFonts.cardTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Poppins Regular - Card Subtitle")
                        .font(AppFonts.cardSubtitle)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.backgroundGradient)
        .ignoresSafeArea()
    }
}

#Preview {
    FontDemoView()
}
