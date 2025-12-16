import SwiftUI

struct DayMapView: View {
    @ObservedObject var viewModel: NoticeViewModel
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    @State private var cardScale: CGFloat = 0.9
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.accentGold.opacity(0.2))
                                .frame(width: 70, height: 70)
                                .offset(x: -15, y: -8)
                            
                            Circle()
                                .fill(Color.theme.primaryPurple.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .offset(x: 12, y: 10)
                            
                            Image(systemName: "map")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        
                        Text("Day Map")
                            .font(.ubuntu(28, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Today's Progress")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Text("\(viewModel.getTodayEntry().completedPeriodsCount)/3")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.accentGold)
                        }
                        .padding(.horizontal, 20)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.cardBackground)
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.theme.accentGold, Color.theme.primaryPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * (CGFloat(viewModel.getTodayEntry().completedPeriodsCount) / 3.0), height: 8)
                                    .animation(.easeInOut(duration: 0.5), value: viewModel.getTodayEntry().completedPeriodsCount)
                            }
                        }
                        .frame(height: 8)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 16) {
                        ForEach(Array(TimeOfDay.allCases.enumerated()), id: \.element) { index, timeOfDay in
                            DayMapBlock(
                                timeOfDay: timeOfDay,
                                entry: viewModel.getEntry(for: timeOfDay),
                                hasEntry: !viewModel.getEntry(for: timeOfDay).isEmpty,
                                index: index
                            ) {
                                withAnimation {
                                    selectedTab = .home
                                }
                            }
                            .scaleEffect(cardScale)
                            .offset(y: animationOffset)
                            .animation(
                                .easeOut(duration: 0.3)
                                .delay(Double(index) * 0.1),
                                value: cardScale
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        if viewModel.getTodayEntry().hasAnyEntry {
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(Color.theme.accentGold)
                                
                                Text("Great progress!")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                            }
                        }
                        
                        Text(viewModel.getTodayEntry().hasAnyEntry ? 
                             "Every day — three chances to notice life. Fill them with attention." :
                             "All three blocks are still empty. The day is waiting to be noticed.")
                            .font(.ubuntu(16, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                cardScale = 1.0
                animationOffset = 0
            }
        }
    }
}

struct DayMapBlock: View {
    let timeOfDay: TimeOfDay
    let entry: String
    let hasEntry: Bool
    let index: Int
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var hoverOffset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(hasEntry ? Color.theme.accentGold.opacity(0.2) : Color.theme.cardBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: timeOfDay.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(hasEntry ? Color.theme.accentGold : Color.theme.secondaryText)
                }
            
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(timeOfDay.title)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        if hasEntry {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.theme.accentGold)
                        } else {
                            Circle()
                                .stroke(Color.theme.placeholderText, lineWidth: 2)
                                .frame(width: 16, height: 16)
                        }
                    }
                    
                    if hasEntry {
                        Text(entry)
                            .font(.ubuntu(14, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("— not recorded yet —")
                            .font(.ubuntu(14, weight: .light))
                            .foregroundColor(Color.theme.placeholderText)
                            .italic()
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .rotationEffect(.degrees(isPressed ? 90 : 0))
                    .animation(.easeInOut(duration: 0.15), value: isPressed)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(hasEntry ? 
                          LinearGradient(
                              colors: [Color.theme.accentGold.opacity(0.1), Color.theme.accentGold.opacity(0.05)],
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
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                hasEntry ? 
                                LinearGradient(
                                    colors: [Color.theme.accentGold.opacity(0.4), Color.theme.accentGold.opacity(0.2)],
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
                        color: hasEntry ? Color.theme.accentGold.opacity(0.2) : Color.theme.primaryPurple.opacity(0.1),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .offset(y: hoverOffset)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DayMapView(viewModel: NoticeViewModel(), selectedTab: .constant(.dayMap))
}
