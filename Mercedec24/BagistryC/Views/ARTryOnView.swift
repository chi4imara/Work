import SwiftUI
import UIKit
import Photos

struct ARTryOnView: View {
    let bagId: UUID
    @EnvironmentObject private var bagViewModel: BagViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isRecording = false
    @State private var recordingSeconds: Int = 0
    @State private var recordingTimer: Timer?
    @State private var isCameraFlipped = false
    @State private var showingRating = false
    @State private var rating = 0
    @State private var notes = ""
    @State private var showingSavedAlert = false
    @State private var showingSnapshotAlert = false
    @State private var showingSnapshotError = false
    @State private var showingRecordingSavedAlert = false
    @State private var showingRecordingSaveError = false
    @State private var lastRecordingDuration = "00:00"
    @State private var savedToCollection = false
    
    private var bag: Bag? {
        bagViewModel.getBag(by: bagId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    if let bag = bag {
                        tryOnContent(bag: bag)
                    } else {
                        bagNotFoundContent
                    }
                }
            }
            .navigationTitle("Try On")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        stopRecordingIfNeeded()
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
            }
            .toolbarBackground(Color.theme.cardBackground, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingRating) {
            if let bag = bag {
                RatingView(
                    bag: bag,
                    rating: $rating,
                    notes: $notes,
                    onSave: { savedRating, savedNotes in
                        let session = TryOnSession(bag: bag, rating: savedRating, notes: savedNotes.isEmpty ? nil : savedNotes)
                        userViewModel.addTryOnSession(session)
                        showingRating = false
                        dismiss()
                    }
                )
            }
        }
        .alert("Saved to Collection", isPresented: $showingSavedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This bag has been added to My Collection.")
        }
        .alert("Snapshot Saved", isPresented: $showingSnapshotAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The snapshot has been saved to your photo library.")
        }
        .alert("Snapshot Failed", isPresented: $showingSnapshotError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Allow photo library access in Settings to save snapshots.")
        }
        .alert("Recording Saved", isPresented: $showingRecordingSavedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Video saved to your photo library. Duration: \(lastRecordingDuration)")
        }
        .alert("Recording Save Failed", isPresented: $showingRecordingSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Allow photo library access in Settings to save recordings.")
        }
        .onAppear {
            if let bag = bag {
                savedToCollection = bag.isFavorite
            }
        }
    }
    
    private func tryOnContent(bag: Bag) -> some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
                    .frame(height: 400)
                
                VStack(spacing: 16) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 60))
                        .foregroundColor(Color.theme.accentYellow)
                    
                    Text("AR Try-On")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(isCameraFlipped ? "Front camera" : "Back camera")
                        .font(.ubuntu(14))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("Position the bag in the camera view")
                        .font(.ubuntu(16))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    bagInfoOverlay(bag: bag)
                }
            }
            .overlay(recordingOverlay)
            
            controlsSection(bag: bag)
            
            actionButtonsSection(bag: bag)
            
            Spacer()
        }
        .padding()
    }
    
    private func bagInfoOverlay(bag: Bag) -> some View {
        VStack(spacing: 4) {
            if !bag.imageURL.isEmpty, let image = BagPhotoStorage.loadImage(filename: bag.imageURL) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Text(bag.name)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(bag.brand)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(Color.theme.accentText)
            
            Text("\(bag.category.rawValue) · \(bag.size.rawValue)")
                .font(.ubuntu(12))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(12)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
    }
    
    private var recordingOverlay: some View {
        VStack {
            HStack {
                if isRecording {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                            .opacity(0.9)
                        
                        Text(recordingTimeString)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
    
    private var recordingTimeString: String {
        let min = recordingSeconds / 60
        let sec = recordingSeconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    private func controlsSection(bag: Bag) -> some View {
        HStack(spacing: 20) {
            Button(action: {
                isCameraFlipped.toggle()
            }) {
                Image(systemName: "camera.rotate")
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                    .frame(width: 50, height: 50)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(25)
            }
            
            Button(action: toggleRecording) {
                Image(systemName: isRecording ? "stop.circle.fill" : "record.circle")
                    .font(.system(size: 40))
                    .foregroundColor(isRecording ? Color.red : Color.theme.accentYellow)
            }
            
            Button(action: captureSnapshot) {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                    .frame(width: 50, height: 50)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(25)
            }
        }
    }
    
    private func actionButtonsSection(bag: Bag) -> some View {
        HStack(spacing: 12) {
            Button(action: { showingRating = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                    Text("Rate Try-On")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.theme.primaryButton)
                .cornerRadius(25)
            }
            
            Button(action: { saveToCollection(bag: bag) }) {
                HStack(spacing: 8) {
                    Image(systemName: savedToCollection ? "heart.fill" : "heart")
                    Text(savedToCollection ? "In Collection" : "Save")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(savedToCollection ? Color.theme.secondaryButton : Color.theme.secondaryButton)
                .cornerRadius(25)
            }
            .disabled(savedToCollection)
            .opacity(savedToCollection ? 0.7 : 1.0)
        }
    }
    
    private var bagNotFoundContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "handbag")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("Bag not found")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("This bag may have been removed.")
                .font(.ubuntu(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: { dismiss() }) {
                Text("Close")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.theme.primaryButton)
                    .cornerRadius(25)
            }
        }
        .padding()
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            recordingSeconds = 0
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                recordingSeconds += 1
            }
            RunLoop.main.add(recordingTimer!, forMode: .common)
        } else {
            let duration = recordingSeconds
            lastRecordingDuration = recordingTimeString
            stopRecordingIfNeeded()
            guard let bag = bag else {
                showingRecordingSaveError = true
                return
            }
            let image = TryOnSnapshotHelper.makeSnapshotImage(bag: bag, isFrontCamera: isCameraFlipped)
            DispatchQueue.global(qos: .userInitiated).async {
                guard let videoURL = TryOnVideoHelper.makeVideo(from: image, durationSeconds: duration) else {
                    DispatchQueue.main.async { [self] in
                        showingRecordingSaveError = true
                    }
                    return
                }
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    DispatchQueue.main.async { [self] in
                        guard status == .authorized || status == .limited else {
                            try? FileManager.default.removeItem(at: videoURL)
                            showingRecordingSaveError = true
                            return
                        }
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                        }) { success, _ in
                            try? FileManager.default.removeItem(at: videoURL)
                            DispatchQueue.main.async {
                                if success {
                                    showingRecordingSavedAlert = true
                                } else {
                                    showingRecordingSaveError = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func stopRecordingIfNeeded() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        if isRecording {
            isRecording = false
        }
    }
    
    private func captureSnapshot() {
        guard let bag = bag else { return }
        let image = TryOnSnapshotHelper.makeSnapshotImage(bag: bag, isFrontCamera: isCameraFlipped)
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async { [self] in
                guard status == .authorized || status == .limited else {
                    showingSnapshotError = true
                    return
                }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, _ in
                    DispatchQueue.main.async {
                        if success {
                            showingSnapshotAlert = true
                        } else {
                            showingSnapshotError = true
                        }
                    }
                }
            }
        }
    }
    
    private func saveToCollection(bag: Bag) {
        guard !savedToCollection else { return }
        bagViewModel.toggleFavorite(bag)
        savedToCollection = true
        showingSavedAlert = true
    }
}

struct RatingView: View {
    let bag: Bag
    @Binding var rating: Int
    @Binding var notes: String
    let onSave: (Int, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(bag.name)
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text(bag.brand)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.accentText)
                    }
                    
                    VStack(spacing: 16) {
                        Text("How did you like this bag?")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: { rating = star }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 30))
                                        .foregroundColor(star <= rating ? Color.theme.accentYellow : Color.theme.secondaryText)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (optional)")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("Add your thoughts about this bag...", text: $notes, axis: .vertical)
                            .font(.ubuntu(14))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(12)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            .lineLimit(3...6)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onSave(rating, notes)
                    }) {
                        Text("Save Try-On")
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.theme.primaryButton)
                            .cornerRadius(25)
                    }
                    .disabled(rating == 0)
                    .opacity(rating == 0 ? 0.6 : 1.0)
                }
                .padding()
            }
            .navigationTitle("Rate Try-On")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
            }
            .toolbarBackground(Color.theme.cardBackground, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ARTryOnView(bagId: UUID())
        .environmentObject(BagViewModel())
        .environmentObject(UserViewModel())
}
