import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var gratitudeText = ""
    @State private var showingMenu = false
    @State private var showingSaveConfirmation = false
    @State private var showingDeleteAlert = false
    @State private var showingTipsView = false
    @State private var showingRandomView = false
    @State private var showingJournalView = false
    @State private var selectedEntry: GratitudeEntry?
    @State private var showInputForm = false
    
    var onTabChange: ((Int) -> Void)?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 30) {
                        questionSection
                        
                        if let todaysEntry = viewModel.getTodaysEntry() {
                            todaysGratitudeCard(todaysEntry)
                        } else {
                            if viewModel.entriesCount == 0 && !showInputForm {
                                emptyStateView
                            } else {
                                inputFormView
                            }
                        }
                        
                        hintSection
                    }
                    .animation(.easeInOut(duration: 0.3), value: showInputForm)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert("Entry Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your gratitude has been saved successfully.")
        }
        .alert("Delete Today's Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let todaysEntry = viewModel.getTodaysEntry() {
                    viewModel.deleteEntry(todaysEntry)
                }
            }
        } message: {
            Text("Are you sure you want to delete today's gratitude entry?")
        }
        .sheet(item: $selectedEntry) { entry in
            EditGratitudeView(viewModel: viewModel, entry: entry)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Gratitude Helper")
                    .font(.builderSans(.bold, size: 24))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("One day — one thank you")
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Menu {
                Button("Gratitude Journal") {
                    onTabChange?(1)
                }
                Button("Tips for Inspiration") {
                    onTabChange?(3)
                }
                Button("Random Thank You") {
                    onTabChange?(2)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.backgroundWhite.opacity(0.8))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var questionSection: some View {
        VStack(spacing: 16) {
            Text("What are you grateful for today?")
                .font(.builderSans(.semiBold, size: 26))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("You can write briefly — the main thing is from the heart.")
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }
    
    private var inputFormView: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                gratitudeText.isEmpty ? AppColors.textLight.opacity(0.3) :
                                gratitudeText.count > 180 ? AppColors.accentOrange.opacity(0.7) :
                                AppColors.primaryBlue.opacity(0.5),
                                lineWidth: 2
                            )
                    }
                    .frame(height: 300)
                
                if gratitudeText.isEmpty {
                    Text("Write a moment, person, event, or feeling...")
                        .font(.builderSans(.regular, size: 16))
                        .foregroundColor(AppColors.textLight)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }
                
                TextEditor(text: $gratitudeText)
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .onChange(of: gratitudeText) { newValue in
                        if newValue.count > 200 {
                            gratitudeText = String(newValue.prefix(200))
                        }
                    }
            }
            
            HStack {
                Spacer()
                Text("\(gratitudeText.count) / 200")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(gratitudeText.count > 180 ? AppColors.accentOrange : AppColors.textLight)
            }
            
            Button(action: saveGratitude) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                    Text("Save")
                        .font(.builderSans(.semiBold, size: 18))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(gratitudeText.isEmpty ? AppColors.textLight : AppColors.primaryBlue)
                )
            }
            .disabled(gratitudeText.isEmpty)
        }
        .padding(.top, 20)
    }
    
    private func todaysGratitudeCard(_ entry: GratitudeEntry) -> some View {
        VStack(spacing: 20) {
            Text("Your thank you today")
                .font(.builderSans(.semiBold, size: 18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                Text(entry.text)
                    .font(.builderSans(.medium, size: 18))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Added: \(entry.displayDate), \(entry.displayTime)")
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(AppColors.textSecondary)
                
                if entry.edited {
                    Text("Edited")
                        .font(.builderSans(.medium, size: 10))
                        .foregroundColor(AppColors.primaryYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(AppColors.primaryYellow.opacity(0.2))
                        )
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.textLight.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            
            HStack(spacing: 16) {
                Button(action: {
                    selectedEntry = entry
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.primaryBlue, lineWidth: 1.5)
                    )
                }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(AppColors.accentOrange)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.accentOrange, lineWidth: 1.5)
                    )
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.stars")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            Text("Every day is an opportunity to say 'thank you'. Start today.")
                .font(.builderSans(.medium, size: 18))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showInputForm = true
                }
            } label: {
                Text("Add First Gratitude")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.primaryBlue)
                    )
            }
        }
        .padding(.top, 40)
    }
    
    private var hintSection: some View {
        Text("Sometimes gratitude is just a moment of warmth. Write it down.")
            .font(.builderSans(.regular, size: 14))
            .foregroundColor(AppColors.textLight)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.top, 40)
    }
    
    private func saveGratitude() {
        guard !gratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        viewModel.saveEntry(gratitudeText)
        gratitudeText = ""
        showingSaveConfirmation = true
    }
}

#Preview {
    HomeView(viewModel: GratitudeViewModel(), onTabChange: nil)
}
