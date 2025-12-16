import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: NoticeViewModel
    @State private var currentText: String = ""
    @State private var selectedTimeOfDay: TimeOfDay = .morning
    @FocusState private var isTextFieldFocused: Bool
    @State private var cardScale: CGFloat = 0.9
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.accentGold.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .offset(x: -10, y: -5)
                            
                            Circle()
                                .fill(Color.theme.primaryPurple.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .offset(x: 15, y: 8)
                            
                            Image(systemName: "house")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        
                        Text("Mindful Moments")
                            .font(.ubuntu(28, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            Text(selectedTimeOfDay.title)
                                .font(.ubuntu(24, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "quote.opening")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(Color.theme.accentGold.opacity(0.6))
                                
                                Text(QuoteManager.shared.randomDailyQuote())
                                    .font(.ubuntuItalic(16, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                
                                Image(systemName: "quote.closing")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(Color.theme.accentGold.opacity(0.6))
                            }
                        }
                        
                        VStack(spacing: 16) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.theme.cardBackground, Color.theme.cardBackground.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.theme.cardBorder, Color.theme.cardBorder.opacity(0.5)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    .shadow(
                                        color: Color.theme.primaryPurple.opacity(0.1),
                                        radius: 15,
                                        x: 0,
                                        y: 8
                                    )
                                    .frame(minHeight: 140)
                                
                                if currentText.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(selectedTimeOfDay.placeholder)
                                            .font(.ubuntu(16, weight: .light))
                                            .foregroundColor(Color.theme.placeholderText)
                                        
                                        Text("Start typing...")
                                            .font(.ubuntu(14, weight: .light))
                                            .foregroundColor(Color.theme.placeholderText.opacity(0.7))
                                    }
                                    .padding(.top, 16)
                                    .padding(.leading, 16)
                                }
                                
                                TextEditor(text: $currentText)
                                    .font(.ubuntu(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .background(Color.clear)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .focused($isTextFieldFocused)
                                    .onChange(of: currentText) { newValue in
                                        viewModel.updateEntry(text: newValue, for: selectedTimeOfDay)
                                    }
                                    .scrollContentBackground(.hidden)
                            }
                            .scaleEffect(cardScale)
                            .animation(.easeOut(duration: 0.3), value: cardScale)
                            
                            if !currentText.isEmpty {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color.theme.accentGold)
                                    
                                    Text("Recorded. You noticed life today.")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(Color.theme.accentGold)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.theme.accentGold.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.theme.accentGold.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    TimeOfDaySelector(
                        selectedTimeOfDay: $selectedTimeOfDay,
                        viewModel: viewModel
                    ) { timeOfDay in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTimeOfDay = timeOfDay
                            currentText = viewModel.getEntry(for: timeOfDay)
                        }
                    }
                    
                    if currentText.isEmpty && !isTextFieldFocused {
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentGold.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "heart")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Begin Your Journey")
                                    .font(.ubuntu(20, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text("Every day consists of three moments. Start with one — simply notice what you liked.")
                                    .font(.ubuntu(16, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            selectedTimeOfDay = viewModel.currentTimeOfDay
            currentText = viewModel.getEntry(for: selectedTimeOfDay)
            
            withAnimation(.easeOut(duration: 0.5)) {
                cardScale = 1.0
                animationOffset = 0
            }
        }
        .onChange(of: viewModel.currentTimeOfDay) { newTimeOfDay in
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTimeOfDay = newTimeOfDay
                currentText = viewModel.getEntry(for: newTimeOfDay)
            }
        }
    }
}

struct TimeOfDaySelector: View {
    @Binding var selectedTimeOfDay: TimeOfDay
    let viewModel: NoticeViewModel
    let onSelection: (TimeOfDay) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(TimeOfDay.allCases, id: \.self) { timeOfDay in
                TimeOfDayButton(
                    timeOfDay: timeOfDay,
                    isSelected: selectedTimeOfDay == timeOfDay,
                    hasEntry: !viewModel.getEntry(for: timeOfDay).isEmpty
                ) {
                    onSelection(timeOfDay)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TimeOfDayButton: View {
    let timeOfDay: TimeOfDay
    let isSelected: Bool
    let hasEntry: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.theme.primaryPurple.opacity(0.3) : Color.theme.cardBackground)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: timeOfDay.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? Color.theme.primaryWhite : Color.theme.secondaryText)
                }
                
                Text(timeOfDay.title.components(separatedBy: " ").first ?? "")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.primaryWhite : Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    if hasEntry {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.theme.accentGold)
                    } else {
                        Circle()
                            .stroke(Color.theme.placeholderText, lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? 
                          LinearGradient(
                              colors: [Color.theme.primaryPurple.opacity(0.4), Color.theme.primaryPurple.opacity(0.2)],
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing
                          ) :
                          LinearGradient(
                              colors: [Color.theme.cardBackground, Color.theme.cardBackground.opacity(0.8)],
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing
                          )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                isSelected ? 
                                LinearGradient(
                                    colors: [Color.theme.primaryWhite.opacity(0.6), Color.theme.primaryWhite.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.theme.cardBorder, Color.theme.cardBorder.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.theme.primaryPurple.opacity(0.2) : Color.theme.primaryPurple.opacity(0.1),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView(viewModel: NoticeViewModel())
}
