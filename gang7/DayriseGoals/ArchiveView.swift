import SwiftUI

struct ArchiveView: View {
    @ObservedObject var dailyEntryViewModel: DailyEntryViewModel
    @State private var selectedEntry: DailyEntry?
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if dailyEntryViewModel.entries.isEmpty {
                EmptyArchiveView()
            } else {
                ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            VStack(spacing: 25) {
                                Spacer(minLength: 20)
                                
                                HStack(spacing: 30) {
                                    ForEach(0..<4) { index in
                                        Image(systemName: "book.closed")
                                            .font(.system(size: 16 + CGFloat(index * 2)))
                                            .foregroundColor(AppColors.secondaryText.opacity(0.6))
                                            .offset(
                                                x: sin(Double(index) * 0.8 + rotationAngle * 0.1) * 10,
                                                y: cos(Double(index) * 0.6 + rotationAngle * 0.1) * 8
                                            )
                                            .animation(
                                                .easeInOut(duration: 3 + Double(index) * 0.5)
                                                .repeatForever(autoreverses: true)
                                                .delay(Double(index) * 0.3),
                                                value: rotationAngle
                                            )
                                    }
                                }
                                
                                Text("Archive")
                                    .font(.ubuntu(32, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .scaleEffect(scale)
                                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
                                
                                Text("Your journey through mindful mornings")
                                    .font(.ubuntu(18, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .padding(.bottom, 30)
                            
                            ZStack {
                                ForEach(0..<5) { index in
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    AppColors.elementPurple.opacity(0.1),
                                                    AppColors.warmOrange.opacity(0.1),
                                                    AppColors.softGreen.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                        .frame(width: 100 + CGFloat(index * 50), height: 100 + CGFloat(index * 50))
                                        .offset(
                                            x: sin(Double(index) * 0.5 + rotationAngle * 0.05) * 20,
                                            y: cos(Double(index) * 0.7 + rotationAngle * 0.05) * 15
                                        )
                                        .animation(
                                            .easeInOut(duration: 4 + Double(index) * 0.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.4),
                                            value: rotationAngle
                                        )
                                }
                                
                                LazyVStack(spacing: 20) {
                                    ForEach(Array(dailyEntryViewModel.entries.enumerated()), id: \.element.id) { index, entry in
                                        ArchiveEntryCard(
                                            entry: entry,
                                            index: index,
                                            onTap: {
                                                selectedEntry = entry
                                            }
                                        )
                                        .offset(y: sin(Double(index) * 0.3 + floatingOffset * 0.1) * 3)
                                        .animation(
                                            .easeInOut(duration: 2.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.2),
                                            value: floatingOffset
                                        )
                                    }
                                }
                                .scaleEffect(pulseScale)
                                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: pulseScale)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 25) {
                                HStack(spacing: 15) {
                                    ForEach(0..<6) { index in
                                        Circle()
                                            .fill(AppColors.textYellow.opacity(0.4))
                                            .frame(width: 6, height: 6)
                                            .offset(
                                                x: sin(Double(index) * 0.8 + rotationAngle * 0.05) * 12,
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
                                
                                Text("Every entry is a step towards inner peace")
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
            }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry)
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.02
                floatingOffset = 50
            }
        }
    }
}

struct ArchiveEntryCard: View {
    let entry: DailyEntry
    let index: Int
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.elementPurple.opacity(glowIntensity),
                                AppColors.warmOrange.opacity(glowIntensity * 0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 60
                        )
                    )
                    .frame(height: 140)
                    .blur(radius: 8)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.dateString)
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Morning Entry")
                                .font(.ubuntu(12, weight: .light))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.8),
                                            AppColors.warmOrange.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 35, height: 35)
                            
                            Image(systemName: "sunrise")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(entry.reminder)
                        .font(.ubuntu(14, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if !entry.intention.isEmpty {
                        Text(entry.intention)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Text("Open")
                                .font(.ubuntu(14, weight: .medium))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.elementPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppColors.cardBackground.opacity(0.8))
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.3),
                                            AppColors.warmOrange.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: AppColors.elementPurple.opacity(0.2),
                            radius: isPressed ? 4 : 8,
                            x: 0,
                            y: isPressed ? 2 : 4
                        )
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowIntensity = 0.6
            }
        }
    }
}

struct EmptyArchiveView: View {
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                ForEach(0..<5) { index in
                    Image(systemName: "doc.text")
                        .font(.system(size: 12 + CGFloat(index * 2)))
                        .foregroundColor(AppColors.secondaryText.opacity(0.4))
                        .offset(
                            x: sin(Double(index) * 0.8 + rotationAngle * 0.1) * 30,
                            y: cos(Double(index) * 0.6 + rotationAngle * 0.1) * 20
                        )
                        .rotationEffect(.degrees(Double(index) * 15))
                        .animation(
                            .easeInOut(duration: 3 + Double(index) * 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: rotationAngle
                        )
                }
                
                Image(systemName: "book.closed")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
            }
            .frame(width: 120, height: 120)
            
            VStack(spacing: 20) {
                Text("You haven't left any morning thoughts yet.")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Try writing your first one tomorrow morning.")
                    .font(.ubuntu(18, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 15) {
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(AppColors.textYellow.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .offset(
                                x: sin(Double(index) * 0.8 + floatingOffset * 0.1) * 10,
                                y: cos(Double(index) * 0.6 + floatingOffset * 0.1) * 5
                            )
                            .animation(
                                .easeInOut(duration: 2.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: floatingOffset
                            )
                    }
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                floatingOffset = 50
            }
        }
    }
}

struct EntryDetailView: View {
    let entry: DailyEntry
    @Environment(\.dismiss) private var dismiss
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        Spacer(minLength: 20)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColors.elementPurple.opacity(0.8),
                                        AppColors.warmOrange.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .overlay(
                                Text(entry.dateString)
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: AppColors.elementPurple.opacity(0.4),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                            .scaleEffect(scale)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Morning Reminder")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(entry.reminder)
                                .font(.ubuntu(18, weight: .light))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Capsule()
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    Capsule()
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
                                    radius: 6,
                                    x: 0,
                                    y: 3
                                )
                        )
                        
                        if !entry.intention.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Morning Intention")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Text(entry.intention)
                                    .font(.ubuntu(18, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Capsule()
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.softGreen.opacity(0.4),
                                                        AppColors.elementPurple.opacity(0.3)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(
                                        color: AppColors.softGreen.opacity(0.2),
                                        radius: 6,
                                        x: 0,
                                        y: 3
                                    )
                            )
                        }
                        
                        if let mood = entry.mood, !mood.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Morning Mood")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Text(mood)
                                    .font(.ubuntu(18, weight: .regular))
                                    .foregroundColor(AppColors.warmOrange)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Capsule()
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.warmOrange.opacity(0.4),
                                                        AppColors.textYellow.opacity(0.3)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(
                                        color: AppColors.warmOrange.opacity(0.2),
                                        radius: 6,
                                        x: 0,
                                        y: 3
                                    )
                            )
                        }
                        
                        Text("Every morning is a reflection of inner movement.")
                            .font(.ubuntuItalic(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(AppColors.cardBackground.opacity(0.6))
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        AppColors.elementPurple.opacity(0.2),
                                                        AppColors.warmOrange.opacity(0.2)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .scaleEffect(pulseScale)
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: pulseScale)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .navigationTitle("Entry")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryText)
                    }
                }
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.02
            }
        }
    }
}

#Preview {
    ArchiveView(dailyEntryViewModel: DailyEntryViewModel())
}
