import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MainViewModel()
    @State private var showingMenu = false
    @State private var showingPractice = false
    @State private var showingAbout = false
    @State private var showingArchive = false
    @State private var showingRepeatAlert = false
    @State private var showingAddPhrase = false
    @State private var showingPhraseManagement = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        BackgroundContainer {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    lightReminderBlock
                    
                    dailyPhraseBlock
                    
                    practiceBlock
                    
                    statusSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100) 
            }
        }
        .sheet(isPresented: $showingPractice) {
            PracticeView(
                isRepeat: viewModel.dailyState.completed,
                onComplete: {
                    viewModel.completePractice()
                    showingPractice = false
                },
                action: {
                    withAnimation {
                        selectedTab = 2
                        dismiss()
                    }
                }
            )
        }
        .sheet(isPresented: $showingAbout) {
            StatisticsView()
        }
        .sheet(isPresented: $showingArchive) {
            ArchiveView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddPhrase) {
            AddPhraseView { phraseText in
                viewModel.addCustomPhrase(phraseText)
            }
        }
        .sheet(isPresented: $showingPhraseManagement) {
            PhraseManagementView(viewModel: viewModel)
        }
        .alert("Practice Today", isPresented: $showingRepeatAlert) {
            Button("Yes") {
                showingPractice = true
            }
            Button("No", role: .cancel) { }
        } message: {
            Text("You already completed the practice today. Would you like to repeat it?")
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        }
        .confirmationDialog("Menu", isPresented: $showingMenu) {
            Button("New Phrase") {
                viewModel.selectRandomPhrase()
            }
            Button("Add Custom Phrase") {
                showingAddPhrase = true
            }
            Button("Manage Phrases") {
                showingPhraseManagement = true
            }
            Button("Phrase Archive") {
                withAnimation {
                    selectedTab = 1
                }
            }
            Button("Statistics") {
                withAnimation {
                    selectedTab = 2
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Evening Helper")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Text("Time to turn off the light")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
                
                Button(action: { showingMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(ColorTheme.lightBlue.opacity(0.3))
                        )
                }
            }
        }
    }
    
    private var lightReminderBlock: some View {
        VStack(spacing: 20) {
            Text("Evening Pause")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            Text(viewModel.lightStatusText)
                .font(.ubuntu(18, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.toggleLight()
                }
            }) {
                Image(systemName: viewModel.dailyState.lightOff ? "lightbulb.slash.fill" : "lightbulb.fill")
                    .font(.system(size: 40))
                    .foregroundColor(viewModel.dailyState.lightOff ? ColorTheme.textSecondary : ColorTheme.primaryYellow)
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(ColorTheme.backgroundWhite)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.lightBlue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorTheme.primaryBlue.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var dailyPhraseBlock: some View {
        VStack(spacing: 20) {
            Text("Relaxing Phrase")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            if let phrase = viewModel.currentPhrase {
                Text(phrase.text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.selectRandomPhrase()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                Text("New Phrase")
                            }
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorTheme.lightBlue.opacity(0.2))
                            )
                        }
                        
                        Button(action: {
                            viewModel.addCurrentPhraseToArchive()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                Text("Add to Archive")
                            }
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.backgroundWhite)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorTheme.primaryYellow)
                            )
                        }
                    }
                    
                    Button(action: {
                        showingAddPhrase = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add Custom Phrase")
                        }
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.accentPurple)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.accentPurple.opacity(0.1))
                        )
                    }
                }
            } else if viewModel.allPhrases.isEmpty {
                VStack(spacing: 16) {
                    Text("No phrases found.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Button(action: {
                        viewModel.restoreDefaultPhrases()
                    }) {
                        Text("Add Default Phrases")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.backgroundWhite)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorTheme.primaryBlue)
                            )
                    }
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var practiceBlock: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Practice \"Let Go of the Day\"")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                
                Text("Short ritual in 3 steps.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textLight)
            }
            
            Button(action: {
                if viewModel.dailyState.completed {
                    showingRepeatAlert = true
                } else {
                    showingPractice = true
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: viewModel.dailyState.completed ? "arrow.clockwise" : "play.fill")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(viewModel.dailyState.completed ? "Repeat Practice" : "Start Practice")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(ColorTheme.backgroundWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [ColorTheme.accentPurple, ColorTheme.primaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: ColorTheme.accentPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var statusSection: some View {
        Text(viewModel.todayStatusText)
            .font(.ubuntu(12, weight: .regular))
            .foregroundColor(ColorTheme.textLight)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
}
