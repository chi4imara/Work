import SwiftUI

struct ExtraView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                contentView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Discover")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.yellowAccent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                breathingTipsSection
                
                wellnessSection
                
                mindfulnessSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var breathingTipsSection: some View {
        ExtraSectionView(
            title: "Breathing Tips",
            icon: "lungs.fill",
            iconColor: AppColors.primaryPurple
        ) {
            VStack(spacing: 16) {
                TipCardView(
                    icon: "clock",
                    title: "Best Times to Practice",
                    description: "Morning sessions help set a calm tone for the day, while evening practice promotes better sleep.",
                    color: AppColors.blueText
                )
                
                TipCardView(
                    icon: "location",
                    title: "Find Your Space",
                    description: "Choose a quiet, comfortable spot where you won't be disturbed. Consistency in location helps build the habit.",
                    color: AppColors.yellowAccent
                )
                
                TipCardView(
                    icon: "figure.seated.side",
                    title: "Proper Posture",
                    description: "Sit or lie down comfortably with your spine straight. Relax your shoulders and close your eyes if it helps you focus.",
                    color: AppColors.primaryPurple
                )
            }
        }
    }
    
    private var wellnessSection: some View {
        ExtraSectionView(
            title: "Wellness Benefits",
            icon: "heart.fill",
            iconColor: .red
        ) {
            VStack(spacing: 16) {
                BenefitCardView(
                    icon: "brain.head.profile",
                    title: "Stress Reduction",
                    description: "Regular breathing exercises activate the parasympathetic nervous system, naturally reducing stress hormones."
                )
                
                BenefitCardView(
                    icon: "bed.double",
                    title: "Better Sleep",
                    description: "Deep breathing before bed helps calm the mind and prepare your body for restful sleep."
                )
                
                BenefitCardView(
                    icon: "target",
                    title: "Improved Focus",
                    description: "Controlled breathing increases oxygen flow to the brain, enhancing concentration and mental clarity."
                )
            }
        }
    }
    
    private var mindfulnessSection: some View {
        ExtraSectionView(
            title: "Mindfulness Quotes",
            icon: "quote.bubble.fill",
            iconColor: AppColors.mediumText
        ) {
            VStack(spacing: 16) {
                QuoteCardView(
                    quote: "Breath is the bridge which connects life to consciousness, which unites your body to your thoughts.",
                    author: "Thich Nhat Hanh"
                )
                
                QuoteCardView(
                    quote: "The present moment is the only time over which we have dominion.",
                    author: "Thich Nhat Hanh"
                )
                
                QuoteCardView(
                    quote: "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.",
                    author: "Thich Nhat Hanh"
                )
            }
        }
    }
}

struct ExtraSectionView<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.playfairDisplay(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
            }
            
            content
        }
    }
}

struct TipCardView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text(description)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct BenefitCardView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.primaryPurple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text(description)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct QuoteCardView: View {
    let quote: String
    let author: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple.opacity(0.6))
                
                Text(quote)
                    .font(.playfairDisplayItalic(size: 16, weight: .regular))
                    .foregroundColor(AppColors.darkText)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("— \(author)")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.mediumText)
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.primaryPurple.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ExtraView()
}
