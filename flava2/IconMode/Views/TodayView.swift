import SwiftUI

struct TodayView: View {
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var inputText = ""
    @State private var isEditing = false
    @State private var showSuccessMessage = false
    @State private var showMenu = false
    
    @Binding var selectedTabFirst: Int
    
    private let maxCharacters = 200
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        if let todayVictory = viewModel.todayVictory, !isEditing {
                            victoryCardView(todayVictory)
                        } else {
                            inputView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .overlay(
            successMessageOverlay
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Victory")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { showMenu.toggle() }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardGradient)
                    .cornerRadius(0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(AppColors.primary, lineWidth: 2)
                    )
            }
            .confirmationDialog("Menu", isPresented: $showMenu) {
                Button("History") { withAnimation { selectedTabFirst = 2 } }
                Button("Favorites") { withAnimation { selectedTabFirst = 3 } }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    private var inputView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                HStack {
                    Text("What did you accomplish today?")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 0)
                            .stroke(AppColors.primary, lineWidth: 2)
                        }
                        .frame(minHeight: 120)
                    
                    if inputText.isEmpty {
                        Text("Write about your victory...")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary.opacity(0.6))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    
                    TextEditor(text: $inputText)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.clear)
                        .onChange(of: inputText) { newValue in
                            if newValue.count > maxCharacters {
                                inputText = String(newValue.prefix(maxCharacters))
                            }
                        }
                }
                
                HStack {
                    Spacer()
                    Text("\(inputText.count)/\(maxCharacters)")
                        .font(AppFonts.caption1)
                        .foregroundColor(inputText.count > maxCharacters - 20 ? AppColors.warning : AppColors.textSecondary)
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
            )
            
            PixelButton(
                "Save Victory",
                icon: "checkmark.circle.fill",
                style: inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .primary
            ) {
                saveVictory()
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            if isEditing {
                Button("Cancel") {
                    isEditing = false
                    inputText = ""
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            }
        }
    }
    
    private func victoryCardView(_ victory: Victory) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.accent)
                    
                    Text("Today's Victory")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { viewModel.toggleFavorite(victory) }) {
                        Image(systemName: victory.isFavorite ? "star.fill" : "star")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(victory.isFavorite ? AppColors.accent : AppColors.textSecondary)
                    }
                }
                
                Text(victory.text)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(victory.dateString)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
            )
            
            PixelButton("Edit", icon: "pencil", style: .secondary) {
                startEditing()
            }
            
            VStack(spacing: 8) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.secondary)
                
                Text("Tomorrow you can add a new victory")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
        }
    }
    
    private var successMessageOverlay: some View {
        VStack {
            if showSuccessMessage {
                HStack {
                    PixelSuccessView(size: 24)
                    Text("Victory saved!")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textPrimary)
                    
                    ParticleBurst(particleCount: 6)
                        .frame(width: 30, height: 30)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppColors.cardGradient)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(AppColors.success, lineWidth: 2)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            Spacer()
        }
        .padding(.top, 50)
        .animation(.easeInOut(duration: 0.5), value: showSuccessMessage)
    }
    
    private func saveVictory() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        if isEditing, let todayVictory = viewModel.todayVictory {
            viewModel.updateVictory(todayVictory, text: text)
        } else {
            viewModel.addVictory(text: text)
        }
        
        inputText = ""
        isEditing = false
        
        showSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSuccessMessage = false
        }
    }
    
    private func startEditing() {
        if let todayVictory = viewModel.todayVictory {
            inputText = todayVictory.text
            isEditing = true
        }
    }
}

