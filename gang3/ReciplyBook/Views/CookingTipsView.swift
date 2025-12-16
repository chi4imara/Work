import SwiftUI

struct CookingTipsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let cookingTips = [
        CookingTip(
            title: "Read the recipe completely before cooking",
            description: "This way you'll see all the steps in advance and won't forget anything during the process."
        ),
        CookingTip(
            title: "Prepare ingredients in advance",
            description: "Cut, measure and arrange everything before turning on the stove - cooking will become calmer."
        ),
        CookingTip(
            title: "Don't be afraid to improvise",
            description: "If you don't have the exact ingredient - replace it with a similar one. The main thing is to preserve the essence of the taste."
        ),
        CookingTip(
            title: "Clean kitchen is half the success",
            description: "Clean up as you cook - the finale is always more pleasant when nothing is cluttered."
        ),
        CookingTip(
            title: "Write down changes",
            description: "If you changed the amount of salt or added a new spice - immediately add it to the recipe so you don't forget."
        ),
        CookingTip(
            title: "Taste as you go",
            description: "Regular tasting helps you adjust flavors and catch problems early in the cooking process."
        ),
        CookingTip(
            title: "Use fresh ingredients",
            description: "Fresh herbs, spices, and produce make a significant difference in the final taste of your dish."
        ),
        CookingTip(
            title: "Let meat rest",
            description: "After cooking, let meat rest for a few minutes to redistribute juices for better flavor and texture."
        ),
        CookingTip(
            title: "Season in layers",
            description: "Add salt and seasonings gradually throughout cooking rather than all at once for better flavor distribution."
        ),
        CookingTip(
            title: "Keep your knives sharp",
            description: "Sharp knives are safer and make prep work faster and more enjoyable. Invest in good knife maintenance."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(cookingTips.enumerated()), id: \.offset) { index, tip in
                            CookingTipCard(tip: tip, index: index + 1)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 200)
                }
                .padding(.bottom, -100)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            Text("Cooking Tips")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var backButtonView: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Back to Recipe List")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

struct CookingTip {
    let title: String
    let description: String
}

struct CookingTipCard: View {
    let tip: CookingTip
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top, spacing: 15) {
                Text("\(index)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(tip.title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(tip.description)
                        .font(.ubuntu(15))
                        .foregroundColor(AppColors.darkGray)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CookingTipsView()
}
