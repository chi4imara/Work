import SwiftUI
import PhotosUI

struct EditEntryView: View {
    @State private var entry: DiaryEntry
    @ObservedObject var diaryViewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedEmotions: Set<MoodType>
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showingPhotoPicker = false
    
    init(entry: DiaryEntry, diaryViewModel: DiaryViewModel) {
        self._entry = State(initialValue: entry)
        self.diaryViewModel = diaryViewModel
        self._selectedEmotions = State(initialValue: Set(entry.emotions))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your thoughts")
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.accentText)
                            
                            TextField("What's on your mind?", text: $entry.text, axis: .vertical)
                                .font(.ubuntuBody())
                                .padding(16)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .lineLimit(5...15)
                        }
                        .padding(20)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                        
                        PhotoEditSection(
                            photoData: $entry.photoData,
                            showingPhotoPicker: $showingPhotoPicker
                        )
                        
                        EmotionsEditView(selectedEmotions: $selectedEmotions)
                        
                        FavoriteEditToggle(isFavorite: $entry.isFavorite)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.accentText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.ubuntuHeadline())
                    .foregroundColor(canSave ? ColorTheme.primaryBlue : ColorTheme.secondaryText)
                    .disabled(!canSave)
                }
            }
        }
        .photosPicker(isPresented: $showingPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    entry.photoData = data
                }
            }
        }
    }
    
    private var canSave: Bool {
        !entry.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        entry.emotions = Array(selectedEmotions)
        diaryViewModel.updateEntry(entry)
        dismiss()
    }
}

struct PhotoEditSection: View {
    @Binding var photoData: Data?
    @Binding var showingPhotoPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photo")
                .font(.ubuntuBody())
                .foregroundColor(ColorTheme.accentText)
            
            if let imageData = photoData, let uiImage = UIImage(data: imageData) {
                VStack(spacing: 12) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    
                    HStack {
                        Button("Change Photo") {
                            showingPhotoPicker = true
                        }
                        .font(.ubuntuCaption())
                        .foregroundColor(ColorTheme.primaryBlue)
                        
                        Spacer()
                        
                        Button("Remove") {
                            photoData = nil
                        }
                        .font(.ubuntuCaption())
                        .foregroundColor(ColorTheme.softPink)
                    }
                }
            } else {
                Button(action: { showingPhotoPicker = true }) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        Text("Tap to add photo")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.primaryBlue, style: StrokeStyle(lineWidth: 2, dash: [8]))
                    )
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct EmotionsEditView: View {
    @Binding var selectedEmotions: Set<MoodType>
    
    private let emotions = MoodType.allCases
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emotions")
                .font(.ubuntuBody())
                .foregroundColor(ColorTheme.accentText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(emotions, id: \.self) { emotion in
                    Button(action: {
                        if selectedEmotions.contains(emotion) {
                            selectedEmotions.remove(emotion)
                        } else {
                            selectedEmotions.insert(emotion)
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: emotion.icon)
                                .font(.title3)
                                .foregroundColor(selectedEmotions.contains(emotion) ? .white : emotion.color)
                            
                            Text(emotion.displayName)
                                .font(.ubuntuBody())
                                .foregroundColor(selectedEmotions.contains(emotion) ? .white : ColorTheme.primaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(selectedEmotions.contains(emotion) ? emotion.color : Color.white.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(emotion.color, lineWidth: selectedEmotions.contains(emotion) ? 0 : 1)
                        )
                    }
                    .scaleEffect(selectedEmotions.contains(emotion) ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: selectedEmotions.contains(emotion))
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct FavoriteEditToggle: View {
    @Binding var isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { isFavorite.toggle() }) {
                HStack(spacing: 12) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? ColorTheme.softPink : ColorTheme.secondaryText)
                    
                    Text("Favorite")
                        .font(.ubuntuBody())
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
            }
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    EditEntryView(entry: DiaryEntry.sampleEntries[0], diaryViewModel: DiaryViewModel())
}
