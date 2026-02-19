import SwiftUI

struct EntryIdItem: Identifiable {
    let id: UUID
}

struct EntryDetailView: View {
    let entryId: UUID
    @ObservedObject var diaryViewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var entry: DiaryEntry? {
        diaryViewModel.entry(byId: entryId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                
                if let entry = entry {
                    entryContent(entry: entry)
                } else {
                    emptyState
                }
            }
            .navigationTitle("Entry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let entry = entry {
                EditEntryView(entry: entry, diaryViewModel: diaryViewModel)
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                diaryViewModel.deleteEntry(byId: entryId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(ColorTheme.secondaryText)
            Text("Entry not found")
                .font(.ubuntuHeadline())
                .foregroundColor(ColorTheme.primaryText)
            Text("It may have been deleted.")
                .font(.ubuntuBody())
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func entryContent(entry: DiaryEntry) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(entry.formattedDate)
                        .font(.ubuntuHeadline())
                        .foregroundColor(ColorTheme.accentText)
                    
                    if let mood = entry.mood {
                        HStack(spacing: 12) {
                            Image(systemName: mood.icon)
                                .font(.title2)
                                .foregroundColor(mood.color)
                            
                            Text(mood.displayName)
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.primaryText)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(ColorTheme.cardBackground)
                .cornerRadius(16)
                .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                
                if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 300)
                        .clipped()
                        .cornerRadius(16)
                        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                }
                
                if !entry.text.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your thoughts")
                            .font(.ubuntuBody())
                            .foregroundColor(ColorTheme.accentText)
                        
                        Text(entry.text)
                            .font(.ubuntuBody())
                            .foregroundColor(ColorTheme.primaryText)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                }
                
                if !entry.emotions.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Emotions")
                            .font(.ubuntuBody())
                            .foregroundColor(ColorTheme.accentText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(entry.emotions, id: \.self) { emotion in
                                HStack(spacing: 12) {
                                    Image(systemName: emotion.icon)
                                        .font(.title3)
                                        .foregroundColor(emotion.color)
                                    
                                    Text(emotion.displayName)
                                        .font(.ubuntuBody())
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(12)
                                .background(emotion.color.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                }
                
                VStack(spacing: 16) {
                    Button(action: { diaryViewModel.toggleFavorite(entry) }) {
                        HStack(spacing: 12) {
                            Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(entry.isFavorite ? ColorTheme.softPink : ColorTheme.secondaryText)
                            
                            Text(entry.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.cardShadow, radius: 4, x: 0, y: 2)
                    }
                    
                    Button(action: { showingEditView = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(ColorTheme.primaryBlue)
                            
                            Text("Edit Entry")
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.cardShadow, radius: 4, x: 0, y: 2)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundColor(ColorTheme.softPink)
                            
                            Text("Delete Entry")
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.softPink)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.cardShadow, radius: 4, x: 0, y: 2)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

#Preview {
    EntryDetailView(entryId: DiaryEntry.sampleEntries[0].id, diaryViewModel: DiaryViewModel())
}
