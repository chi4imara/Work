import SwiftUI

struct MoodSelectorSheet: View {
    @Binding var selectedMood: Mood?
    @Binding var moodNote: String
    let viewModel: MoodViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempSelectedMood: Mood?
    @State private var tempNote = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: AppSpacing.lg) {
                    VStack(spacing: AppSpacing.sm) {
                        Text("How are you feeling?")
                            .font(AppFonts.playfairBold(size: 24))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Select the mood that best describes how you feel right now")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AppSpacing.lg)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: AppSpacing.md) {
                        ForEach(Mood.allMoods) { mood in
                            MoodButton(
                                mood: mood,
                                isSelected: tempSelectedMood?.emotion == mood.emotion,
                                action: {
                                    withAnimation(AppAnimations.bouncy) {
                                        tempSelectedMood = mood
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    if tempSelectedMood != nil {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Add a note (optional)")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("What's on your mind?", text: $tempNote, axis: .vertical)
                                .font(AppFonts.playfairRegular(size: 14))
                                .padding(AppSpacing.md)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.md)
                                .lineLimit(3...6)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    if tempSelectedMood != nil {
                        Button(action: {
                            saveMood()
                        }) {
                            HStack {
                                Text("Save Mood")
                                    .font(AppFonts.playfairSemiBold(size: 18))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primary, AppColors.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(AppRadius.lg)
                            .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, AppSpacing.lg)
                
                if showSuccessMessage {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.success)
                            
                            Text("Thank you for tracking your mood!")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding(AppSpacing.md)
                        .background(AppColors.success.opacity(0.1))
                        .cornerRadius(AppRadius.md)
                        .shadow(radius: 10)
                        .padding(.horizontal, AppSpacing.md)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.playfairMedium(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .onAppear {
            tempSelectedMood = selectedMood
            tempNote = moodNote
        }
    }
    
    private func saveMood() {
        guard let mood = tempSelectedMood else { return }
        
        let moodToSave = Mood(emotion: mood.emotion, note: tempNote, date: Date(), photoData: nil)
        selectedMood = moodToSave
        moodNote = tempNote
        viewModel.updateTodayMood(moodToSave, note: tempNote)
        
        withAnimation(AppAnimations.smooth) {
            showSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    private var moodColor: Color { mood.emotion.color }
    
    var body: some View {
        Button(action: {
            withAnimation(AppAnimations.quick) {
                isPressed = true
            }
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: mood.emotion.systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(moodColor)
                    .scaleEffect(isPressed ? 1.2 : (isSelected ? 1.1 : 1.0))
                
                Text(mood.emotion.displayName)
                    .font(AppFonts.playfairMedium(size: 12))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.sm)
            .background(
                isSelected ? moodColor.opacity(0.1) : AppColors.cardBackground
            )
            .cornerRadius(AppRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(isSelected ? moodColor : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: isSelected ? moodColor.opacity(0.2) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .animation(AppAnimations.bouncy, value: isSelected)
        .animation(AppAnimations.quick, value: isPressed)
    }
}

#Preview {
    MoodSelectorSheet(
        selectedMood: .constant(nil),
        moodNote: .constant(""),
        viewModel: MoodViewModel()
    )
}
