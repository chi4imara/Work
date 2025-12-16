import SwiftUI

struct FontTestView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Font Test")
                        .font(AppFonts.largeTitle(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Large Title Bold")
                            .font(AppFonts.largeTitle(.bold))
                        
                        Text("Title SemiBold")
                            .font(AppFonts.title(.semiBold))
                        
                        Text("Title2 Medium")
                            .font(AppFonts.title2(.medium))
                        
                        Text("Headline Regular")
                            .font(AppFonts.headline(.regular))
                        
                        Text("Body Regular")
                            .font(AppFonts.body(.regular))
                        
                        Text("Caption SemiBold")
                            .font(AppFonts.caption(.semiBold))
                        
                        Text("Custom Font Test")
                            .font(AppFonts.title(.bold))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .padding()
                    .background(AppColors.cardBackground)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("System Fonts (Fallback)")
                            .font(.title.bold())
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("System Large Title")
                            .font(.largeTitle)
                        
                        Text("System Title")
                            .font(.title)
                        
                        Text("System Body")
                            .font(.body)
                    }
                    .padding()
                    .background(AppColors.surfaceBackground)
                    .cornerRadius(16)
                }
                .padding()
            }
        }
    }
}

#Preview {
    FontTestView()
}
