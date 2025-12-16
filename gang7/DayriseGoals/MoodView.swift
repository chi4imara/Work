import SwiftUI

struct MoodView: View {
    @ObservedObject var dailyEntryViewModel: DailyEntryViewModel
    @State private var selectedMood: String = ""
    @State private var showConfirmation = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    @State private var cloudOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 25) {
                        HStack {
                            ForEach(0..<3) { index in
                                Image(systemName: "cloud.fill")
                                    .font(.system(size: 20 + CGFloat(index * 5)))
                                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
                                    .offset(
                                        x: cloudOffset + CGFloat(index * 30),
                                        y: sin(Double(index) * 0.5 + cloudOffset * 0.01) * 10
                                    )
                                    .animation(
                                        .easeInOut(duration: 3 + Double(index))
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.5),
                                        value: cloudOffset
                                    )
                            }
                        }
                        
                        Text("What kind of morning do you have today?")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .scaleEffect(scale)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
                        
                        Text("Choose the word that's closest to your state.")
                            .font(.ubuntu(18, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    ZStack {
                        ForEach(0..<6) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.2),
                                            AppColors.warmOrange.opacity(0.2),
                                            AppColors.softGreen.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                                .frame(width: 150 + CGFloat(index * 30), height: 150 + CGFloat(index * 30))
                                .rotationEffect(.degrees(rotationAngle + Double(index * 30)))
                                .animation(
                                    .linear(duration: 15 + Double(index * 2))
                                    .repeatForever(autoreverses: false),
                                    value: rotationAngle
                                )
                        }
                        
                        VStack(spacing: 25) {
                            HStack(spacing: 20) {
                                ForEach(0..<4) { index in
                                    if index < AppData.moodOptions.count {
                                        MoodCard(
                                            mood: AppData.moodOptions[index],
                                            isSelected: selectedMood == AppData.moodOptions[index].title,
                                            onTap: {
                                                selectMood(AppData.moodOptions[index].title)
                                            }
                                        )
                                        .rotationEffect(.degrees(Double(index - 1) * 5))
                                        .offset(y: sin(Double(index) * 0.3 + rotationAngle * 0.1) * 5)
                                    }
                                }
                            }
                            
                            HStack(spacing: 20) {
                                ForEach(4..<8) { index in
                                    if index < AppData.moodOptions.count {
                                        MoodCard(
                                            mood: AppData.moodOptions[index],
                                            isSelected: selectedMood == AppData.moodOptions[index].title,
                                            onTap: {
                                                selectMood(AppData.moodOptions[index].title)
                                            }
                                        )
                                        .rotationEffect(.degrees(Double(index - 5) * -5))
                                        .offset(y: sin(Double(index) * 0.3 + rotationAngle * 0.1) * 5)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: pulseScale)
                    }
                    .frame(height: 400)
                    .padding(.horizontal, 20)
                    
                    if showConfirmation {
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.softGreen.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .scaleEffect(showConfirmation ? 1.2 : 0.8)
                                    .animation(.easeInOut(duration: 0.5), value: showConfirmation)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.softGreen)
                            }
                            
                            Text("Mood saved. May the day be kind.")
                                .font(.ubuntu(20, weight: .light))
                                .foregroundColor(AppColors.softGreen)
                                .multilineTextAlignment(.center)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        .padding(.top, 20)
                    }
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            ForEach(0..<6) { index in
                                Circle()
                                    .fill(AppColors.textYellow.opacity(0.5))
                                    .frame(width: 6, height: 6)
                                    .offset(y: sin(Double(index) * 0.8 + rotationAngle * 0.05) * 8)
                                    .animation(
                                        .easeInOut(duration: 2.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.3),
                                        value: rotationAngle
                                    )
                            }
                        }
                        
                        Text("Your morning mood sets the tone for the day")
                            .font(.ubuntuItalic(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 30)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            selectedMood = dailyEntryViewModel.todayMood
            showConfirmation = !selectedMood.isEmpty
            
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.05
                cloudOffset = 50
            }
        }
    }
    
    private func selectMood(_ mood: String) {
        selectedMood = mood
        dailyEntryViewModel.updateMood(mood)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showConfirmation = false
            }
        }
    }
}

struct MoodCard: View {
    let mood: MoodOption
    let isSelected: Bool
    let onTap: () -> Void
    @State private var glowIntensity: Double = 0.3
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            RadialGradient(
                                colors: [
                                    AppColors.warmOrange.opacity(glowIntensity),
                                    AppColors.elementPurple.opacity(glowIntensity * 0.5),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 87, height: 70)
                        .blur(radius: 8)
                }
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isSelected ? [
                                        AppColors.warmOrange,
                                        AppColors.elementPurple
                                    ] : [
                                        AppColors.cardBackground,
                                        AppColors.cardBackground.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: iconForMood(mood.title))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isSelected ? .white : AppColors.primaryText)
                    }
                    
                    Text(mood.title)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(width: 65, height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSelected ? 
                            LinearGradient(
                                colors: [AppColors.warmOrange, AppColors.elementPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [AppColors.cardBackground, AppColors.cardBackground.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    isSelected ? 
                                    LinearGradient(
                                        colors: [AppColors.warmOrange, AppColors.elementPurple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [AppColors.elementPurple.opacity(0.3), AppColors.warmOrange.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: isSelected ? AppColors.warmOrange.opacity(0.6) : AppColors.elementPurple.opacity(0.3),
                            radius: isSelected ? 8 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2
                        )
                )
                .scaleEffect(isPressed ? 0.9 : (isSelected ? 1.1 : 1.0))
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    glowIntensity = 0.8
                }
            }
        }
        .onChange(of: isSelected) { selected in
            if selected {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    glowIntensity = 0.8
                }
            } else {
                glowIntensity = 0.3
            }
        }
    }
    
    private func iconForMood(_ mood: String) -> String {
        switch mood {
        case "Peaceful":
            return "leaf"
        case "Joyful":
            return "sun.max"
        case "Sleepy":
            return "moon"
        case "Fresh":
            return "sparkles"
        case "Quiet":
            return "cloud"
        case "Bright":
            return "lightbulb"
        case "Serious":
            return "book"
        case "Gentle":
            return "heart"
        default:
            return "circle"
        }
    }
}

#Preview {
    MoodView(dailyEntryViewModel: DailyEntryViewModel())
}
