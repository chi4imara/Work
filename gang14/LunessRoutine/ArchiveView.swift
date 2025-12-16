import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject private var archiveViewModel = ArchiveViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingClearAlert = false
    @State private var selectedPhrase: DailyPhrase?
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                headerSection
                
                searchSection
                
                if filteredPhrases.isEmpty {
                    emptyStateSection
                } else {
                    phrasesListSection
                }
            }
        }
        .sheet(item: $selectedPhrase) { phrase in
            PhraseDetailView(
                phrase: phrase,
                onDelete: {
                    viewModel.removeFromArchive(phrase)
                    selectedPhrase = nil
                }
            )
        }
        .alert("Clear Archive", isPresented: $showingClearAlert) {
            Button("Delete All", role: .destructive) {
                viewModel.clearArchive()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all saved phrases?")
        }
    }
    
    private var filteredPhrases: [DailyPhrase] {
        archiveViewModel.filteredPhrases(viewModel.archivedPhrases)
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
            .opacity(0)
            .disabled(true)
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("Phrase Archive")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Phrases saved: \(viewModel.archivedPhrases.count)")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textLight)
            }
            
            Spacer()
            
            Button(action: {
                if !viewModel.archivedPhrases.isEmpty {
                    showingClearAlert = true
                }
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.archivedPhrases.isEmpty ? ColorTheme.textLight : ColorTheme.warmOrange)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(viewModel.archivedPhrases.isEmpty ? ColorTheme.softGray : ColorTheme.warmOrange.opacity(0.2))
                    )
            }
            .disabled(viewModel.archivedPhrases.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTheme.textLight)
            
            TextField("Search phrases...", text: $archiveViewModel.searchText)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "text.bubble")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.textLight)
            
            VStack(spacing: 8) {
                Text(archiveViewModel.searchText.isEmpty ? "Archive is empty" : "No phrases found")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                Text(archiveViewModel.searchText.isEmpty ? 
                     "Add your first phrase from the 'Home' section." :
                     "Try a different search term.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textLight)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var phrasesListSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredPhrases) { phrase in
                    PhraseCard(phrase: phrase) {
                        selectedPhrase = phrase
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}

struct PhraseCard: View {
    let phrase: DailyPhrase
    let onTap: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(ColorTheme.primaryYellow)
                        .font(.system(size: 14))
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: phrase.dateAdded))
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textLight)
                }
                
                Text(phrase.text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .lineLimit(3)
            }
            .padding(.all, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PhraseDetailView: View {
    let phrase: DailyPhrase
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.primaryBlue)
                    
                    Spacer()
                    
                    Text("Phrase Details")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Button("Delete") {
                        showingDeleteAlert = true
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.warmOrange)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 32) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(ColorTheme.primaryYellow)
                            Text("Added \(dateFormatter.string(from: phrase.dateAdded))")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.primaryYellow.opacity(0.1))
                        )
                        
                        VStack(spacing: 16) {
                            Text(phrase.text)
                                .font(.ubuntu(20, weight: .regular))
                                .foregroundColor(ColorTheme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 4) {
                                    Text("\(phrase.text.count)")
                                        .font(.ubuntu(18, weight: .bold))
                                        .foregroundColor(ColorTheme.primaryBlue)
                                    Text("Characters")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textLight)
                                }
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(spacing: 4) {
                                    Text("\(phrase.text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count)")
                                        .font(.ubuntu(18, weight: .bold))
                                        .foregroundColor(ColorTheme.accentPurple)
                                    Text("Words")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textLight)
                                }
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(spacing: 4) {
                                    Text("\(phrase.text.components(separatedBy: .newlines).count)")
                                        .font(.ubuntu(18, weight: .bold))
                                        .foregroundColor(ColorTheme.warmOrange)
                                    Text("Lines")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textLight)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 16) {
                            Text("Mood & Tone")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            HStack(spacing: 16) {
                                moodIndicator("Calm", isActive: phrase.text.lowercased().contains("calm") || phrase.text.lowercased().contains("peace"))
                                
                                Spacer()
                                
                                moodIndicator("Grateful", isActive: phrase.text.lowercased().contains("thank") || phrase.text.lowercased().contains("grateful"))
                                
                                Spacer()
                                
                                moodIndicator("Reflective", isActive: phrase.text.lowercased().contains("reflect") || phrase.text.lowercased().contains("think"))
                                
                                Spacer()
                                
                                moodIndicator("Hopeful", isActive: phrase.text.lowercased().contains("tomorrow") || phrase.text.lowercased().contains("hope"))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Text("Best Used")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            VStack(spacing: 12) {
                                usageSuggestion(
                                    icon: "moon.stars.fill",
                                    title: "Before Sleep",
                                    description: "Perfect for winding down and preparing for rest",
                                    color: ColorTheme.primaryBlue
                                )
                                
                                usageSuggestion(
                                    icon: "sunset.fill",
                                    title: "Evening Reflection",
                                    description: "Great for reflecting on the day's events",
                                    color: ColorTheme.warmOrange
                                )
                                
                                usageSuggestion(
                                    icon: "heart.fill",
                                    title: "Stress Relief",
                                    description: "Helpful when feeling overwhelmed or anxious",
                                    color: ColorTheme.accentPurple
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Delete Phrase", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove this phrase from your archive?")
        }
    }
}

func moodIndicator(_ title: String, isActive: Bool) -> some View {
    VStack(spacing: 4) {
        Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 17))
            .foregroundColor(isActive ? ColorTheme.primaryYellow : ColorTheme.textLight)
        
        Text(title)
            .font(.ubuntu(9, weight: .medium))
            .foregroundColor(isActive ? ColorTheme.textPrimary : ColorTheme.textLight)
    }
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(isActive ? ColorTheme.primaryYellow.opacity(0.1) : ColorTheme.lightBlue.opacity(0.1))
    )
}

func usageSuggestion(icon: String, title: String, description: String, color: Color) -> some View {
    HStack(spacing: 12) {
        Image(systemName: icon)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(color)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(color.opacity(0.15))
            )
        
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            Text(description)
                .font(.ubuntu(12, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .lineLimit(2)
        }
        
        Spacer()
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity)
    .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(ColorTheme.backgroundWhite)
            .shadow(color: color.opacity(0.1), radius: 4, x: 0, y: 2)
    )
}

#Preview {
    ArchiveView(viewModel: MainViewModel())
}
