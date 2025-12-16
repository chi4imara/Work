import SwiftUI

struct GratitudeView: View {
    @ObservedObject var dailyEntryViewModel: DailyEntryViewModel
    @State private var gratitudeText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 20)
                    
                    VStack(spacing: 15) {
                        Text("What are you grateful for today?")
                            .font(.ubuntu(24, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Text("Sometimes one word is enough.")
                            .font(.ubuntu(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 20) {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppColors.cardBackground)
                                .frame(minHeight: 120)
                            
                            if gratitudeText.isEmpty {
                                Text("Write briefly: what do you want to say \"thank you\" for...")
                                    .font(.ubuntu(16, weight: .light))
                                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $gratitudeText)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                                .background(Color.clear)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .focused($isTextFieldFocused)
                                .onChange(of: gratitudeText) { newValue in
                                    dailyEntryViewModel.updateGratitude(newValue)
                                }
                        }
                        .padding(.horizontal, 20)
                        
                        if !gratitudeText.isEmpty {
                            VStack(spacing: 10) {
                                Text("Thank you for today.")
                                    .font(.ubuntu(18, weight: .light))
                                    .foregroundColor(AppColors.softGreen)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<5) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textYellow.opacity(0.6))
                                    }
                                }
                                .transition(.opacity.combined(with: .scale))
                            }
                        }
                    }
                    
                    VStack(spacing: 15) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppColors.lightPink)
                        
                        Text("Gratitude turns what we have into enough.")
                            .font(.ubuntuItalic(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .opacity(gratitudeText.isEmpty ? 1 : 0.6)
                    .animation(.easeInOut(duration: 0.5), value: gratitudeText.isEmpty)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            gratitudeText = dailyEntryViewModel.todayGratitude
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    GratitudeView(dailyEntryViewModel: DailyEntryViewModel())
}
