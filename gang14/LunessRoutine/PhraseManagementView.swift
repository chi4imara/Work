import SwiftUI

struct PhraseManagementView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddPhrase = false
    @State private var showingDeleteAlert = false
    @State private var phraseToDelete: DailyPhrase?
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                headerSection
                
                ScrollView {
                    VStack(spacing: 24) {
                        addPhraseSection
                        
                        allPhrasesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingAddPhrase) {
            AddPhraseView { phraseText in
                viewModel.addCustomPhrase(phraseText)
            }
        }
        .alert("Delete Phrase", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let phrase = phraseToDelete {
                    viewModel.removePhrase(phrase)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this phrase? This action cannot be undone.")
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(0.2))
                    )
            }
            
            Spacer()
            
            Text("Manage Phrases")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var addPhraseSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.accentPurple)
                
                Text("Add New Phrase")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
            }
            
            Text("Create your own relaxing phrases to personalize your evening ritual.")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.leading)
            
            Button(action: {
                showingAddPhrase = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Custom Phrase")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.backgroundWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
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
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var allPhrasesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "text.book.closed.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Text("All Phrases (\(viewModel.allPhrases.count))")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
            }
            
            if viewModel.allPhrases.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.allPhrases) { phrase in
                        PhraseManagementCard(
                            phrase: phrase,
                            isCurrent: viewModel.currentPhrase?.id == phrase.id,
                            onDelete: {
                                phraseToDelete = phrase
                                showingDeleteAlert = true
                            },
                            onSetCurrent: {
                                viewModel.currentPhrase = phrase
                            }
                        )
                    }
                }
            }
        }
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.bubble")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.textLight)
            
            Text("No phrases yet")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
            
            Text("Add your first custom phrase to get started.")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textLight)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
    }
}

struct PhraseManagementCard: View {
    let phrase: DailyPhrase
    let isCurrent: Bool
    let onDelete: () -> Void
    let onSetCurrent: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if isCurrent {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorTheme.primaryYellow)
                        Text("Current")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryYellow)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorTheme.primaryYellow.opacity(0.1))
                    )
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: phrase.dateAdded))
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textLight)
            }
            
            Text(phrase.text)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
            
            HStack(spacing: 12) {
                if !isCurrent {
                    Button(action: onSetCurrent) {
                        Text("Set as Current")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorTheme.lightBlue.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.warmOrange)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(ColorTheme.warmOrange.opacity(0.1))
                        )
                }
            }
        }
        .padding(.all, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrent ? ColorTheme.primaryBlue.opacity(0.05) : ColorTheme.lightBlue.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCurrent ? ColorTheme.primaryBlue.opacity(0.2) : ColorTheme.lightBlue.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    PhraseManagementView(viewModel: MainViewModel())
}
