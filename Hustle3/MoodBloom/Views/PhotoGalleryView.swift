import SwiftUI

struct PhotoGalleryView: View {
    @Binding var photoIds: [String]
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingFullScreenImage = false
    @State private var selectedPhotoId: PhotoIdWrapper?
    @State private var showingDeleteAlert = false
    @State private var photoToDelete: String?
    
    private let photoManager = PhotoManager.shared
    private let maxPhotos = 6
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Photos")
                    .font(FontManager.subheadline)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                if photoIds.count < maxPhotos {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.primaryBlue)
                    }
                }
            }
            
            if photoIds.isEmpty {
                emptyStateView
            } else {
                photoGridView
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(item: $selectedPhotoId) { photoIdWrapper in
            FullScreenPhotoView(photoId: photoIdWrapper.id, onDelete: {
                photoToDelete = photoIdWrapper.id
                showingDeleteAlert = true
            })
        }
        .alert("Delete Photo?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let photoId = photoToDelete {
                    deletePhoto(photoId)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                addPhoto(image)
                selectedImage = nil
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(Color.textSecondary.opacity(0.6))
            
            Text("No photos added")
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
            
            Button("Add Photo") {
                showingImagePicker = true
            }
            .font(FontManager.caption)
            .foregroundColor(Color.primaryBlue)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundGray.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryBlue.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
        )
    }
    
    private var photoGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(photoIds, id: \.self) { photoId in
                PhotoThumbnail(
                    photoId: photoId,
                    onTap: {
                        selectedPhotoId = PhotoIdWrapper(id: photoId)
                    },
                    onDelete: {
                        photoToDelete = photoId
                        showingDeleteAlert = true
                    }
                )
                .padding(.horizontal)
            }
        }
    }
    
    private func addPhoto(_ image: UIImage) {
        guard photoIds.count < maxPhotos else { return }
        
        if let photoId = photoManager.savePhoto(image) {
            photoIds.append(photoId)
        }
    }
    
    private func deletePhoto(_ photoId: String) {
        photoIds.removeAll { $0 == photoId }
        photoManager.deletePhoto(with: photoId)
        photoToDelete = nil
        selectedPhotoId = nil
    }
}

struct PhotoThumbnail: View {
    let photoId: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var image: UIImage?
    private let photoManager = PhotoManager.shared
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onTap) {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle()
                            .fill(Color.backgroundGray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(Color.textSecondary.opacity(0.5))
                            )
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.accentRed)
                            .frame(width: 20, height: 20)
                    )
            }
            .offset(x: 8, y: -8)
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        image = photoManager.loadPhoto(with: photoId)
    }
}

struct FullScreenPhotoView: View {
    let photoId: String
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var image: UIImage?
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    private let photoManager = PhotoManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .onTapGesture(count: 2) {
                            withAnimation(.spring()) {
                                scale = scale > 1.0 ? 1.0 : 2.0
                                offset = .zero
                            }
                        }
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        onDelete()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        image = photoManager.loadPhoto(with: photoId)
    }
}

struct PhotoIdWrapper: Identifiable {
    let id: String
}

#Preview {
    PhotoGalleryView(photoIds: .constant([]))
        .padding()
}
