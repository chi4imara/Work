import SwiftUI

struct MainIntentionView: View {
    @ObservedObject var dailyEntryViewModel: DailyEntryViewModel
    @State private var intentionText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    @State private var sunOffset: CGFloat = 0
    @State private var sparkleRotation: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 30) {
                        ZStack {
                            ForEach(0..<6) { index in
                                Image(systemName: "sparkle")
                                    .font(.system(size: 12 + CGFloat(index * 2)))
                                    .foregroundColor(AppColors.textYellow.opacity(0.7))
                                    .offset(
                                        x: cos(Double(index) * 60 * .pi / 180 + sparkleRotation) * 50,
                                        y: sin(Double(index) * 60 * .pi / 180 + sparkleRotation) * 50
                                    )
                                    .animation(
                                        .linear(duration: 8)
                                        .repeatForever(autoreverses: false),
                                        value: sparkleRotation
                                    )
                            }
                            
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppColors.textYellow)
                                .offset(y: sunOffset)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sunOffset)
                        }
                        .frame(height: 100)
                        
                        ZStack {
                            ForEach(0..<3) { index in
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
                                    .frame(width: 200 + CGFloat(index * 80), height: 200 + CGFloat(index * 80))
                                    .rotationEffect(.degrees(rotationAngle + Double(index * 45)))
                                    .animation(
                                        .linear(duration: 20 + Double(index * 5))
                                        .repeatForever(autoreverses: false),
                                        value: rotationAngle
                                    )
                            }
                            
                            VStack(spacing: 20) {
                                Text(dailyEntryViewModel.todayReminder.isEmpty ? 
                                     "Start your day with breathing and silence." : 
                                     dailyEntryViewModel.todayReminder)
                                    .font(.ubuntu(26, weight: .light))
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                    .scaleEffect(scale)
                                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
                                
                                Text("Morning reminder")
                                    .font(.ubuntu(16, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 30)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.elementPurple.opacity(0.3),
                                                        AppColors.warmOrange.opacity(0.3)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(
                                        color: AppColors.elementPurple.opacity(0.2),
                                        radius: 10,
                                        x: 0,
                                        y: 5
                                    )
                            )
                            .scaleEffect(pulseScale)
                            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: pulseScale)
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    VStack(spacing: 25) {
                        Text("What do I want from this day?")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        VStack(spacing: 20) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardBackground)
                                    .frame(minHeight: 140)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.elementPurple.opacity(0.4),
                                                        AppColors.warmOrange.opacity(0.3)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(
                                        color: AppColors.elementPurple.opacity(0.2),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )
                                
                                if intentionText.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Write briefly:")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text("What do you expect from the day?")
                                            .font(.ubuntu(16, weight: .light))
                                            .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 20)
                                }
                                
                                TextEditor(text: $intentionText)
                                    .font(.ubuntu(18, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .background(Color.clear)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .focused($isTextFieldFocused)
                                    .onChange(of: intentionText) { newValue in
                                        dailyEntryViewModel.updateIntention(newValue)
                                    }
                                    .scrollContentBackground(.hidden)
                            }
                            .padding(.horizontal, 20)
                            
                            if !intentionText.isEmpty {
                                VStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.softGreen.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                            .scaleEffect(1.2)
                                            .animation(.easeInOut(duration: 0.5), value: !intentionText.isEmpty)
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(AppColors.softGreen)
                                    }
                                    
                                    Text("Recorded. May this day be kind.")
                                        .font(.ubuntu(18, weight: .light))
                                        .foregroundColor(AppColors.softGreen)
                                        .multilineTextAlignment(.center)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            } else {
                                VStack(spacing: 10) {
                                    Text("Sometimes one intention makes the day meaningful.")
                                        .font(.ubuntu(16, weight: .light))
                                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30)
                                    
                                    HStack(spacing: 12) {
                                        ForEach(0..<5) { index in
                                            Circle()
                                                .fill(AppColors.textYellow.opacity(0.4))
                                                .frame(width: 6, height: 6)
                                                .offset(y: sin(Double(index) * 0.8 + rotationAngle * 0.1) * 3)
                                                .animation(
                                                    .easeInOut(duration: 2)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(Double(index) * 0.2),
                                                    value: rotationAngle
                                                )
                                        }
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 25) {
                        HStack(spacing: 20) {
                            ForEach(0..<7) { index in
                                Circle()
                                    .fill(AppColors.textYellow.opacity(0.4))
                                    .frame(width: 8, height: 8)
                                    .offset(
                                        x: sin(Double(index) * 0.8 + rotationAngle * 0.05) * 15,
                                        y: cos(Double(index) * 0.6 + rotationAngle * 0.05) * 8
                                    )
                                    .animation(
                                        .easeInOut(duration: 2.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: rotationAngle
                                    )
                            }
                        }
                        
                        Text("Your morning intention sets the tone for the day")
                            .font(.ubuntuItalic(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            intentionText = dailyEntryViewModel.todayIntention
            
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.05
                sunOffset = 10
                sparkleRotation = 360
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    MainIntentionView(dailyEntryViewModel: DailyEntryViewModel())
}
