import SwiftUI

enum DetailSheetItem: Identifiable {
    case editPlace(Place)
    
    var id: String {
        switch self {
        case .editPlace(let place):
            return "editPlace_\(place.id)"
        }
    }
}

struct PlaceDetailView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    let place: Place
    var category: Category? = nil
    var shouldDismissParent: Bool = false
    var onEditPlace: ((Place) -> Void)? = nil
    
    @State private var showingDeleteAlert = false
    @State private var sheetItem: DetailSheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(place.name)
                                    .font(FontManager.title)
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text(place.category)
                                    .font(FontManager.subheadline)
                                    .foregroundColor(ColorTheme.blueText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(ColorTheme.lightBlue.opacity(0.3))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleFavorite(for: place)
                            }) {
                                Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 24))
                                    .foregroundColor(place.isFavorite ? ColorTheme.accentOrange : ColorTheme.secondaryText)
                                    .scaleEffect(place.isFavorite ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: place.isFavorite)
                            }
                        }
                        
                        if place.isFavorite {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorTheme.accentOrange)
                                
                                Text("Favorite Place")
                                    .font(FontManager.caption)
                                    .foregroundColor(ColorTheme.accentOrange)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorTheme.cardGradient)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    
                    if !place.address.isEmpty {
                        DetailSectionView(
                            title: "Address",
                            content: place.address,
                            icon: "location.fill"
                        )
                    } else {
                        DetailSectionView(
                            title: "Address",
                            content: "Address not specified",
                            icon: "location.fill",
                            isEmpty: true
                        )
                    }
                    
                    if !place.note.isEmpty {
                        DetailSectionView(
                            title: "Note",
                            content: place.note,
                            icon: "note.text"
                        )
                    } else {
                        DetailSectionView(
                            title: "Note",
                            content: "Note not added",
                            icon: "note.text",
                            isEmpty: true
                        )
                    }
                    
                    DetailSectionView(
                        title: "Date Added",
                        content: DateFormatter.displayFormatter.string(from: place.dateAdded),
                        icon: "calendar"
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: HStack(spacing: 16) {
                Button("Edit") {
                    if shouldDismissParent {
                        onEditPlace?(place)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        sheetItem = .editPlace(place)
                    }
                }
                .foregroundColor(ColorTheme.primaryBlue)
                
                Button("Delete") {
                    showingDeleteAlert = true
                }
                .foregroundColor(.red)
            }
        )
        .sheet(item: $sheetItem) { item in
            switch item {
            case .editPlace(let place):
                AddEditPlaceView(viewModel: viewModel, placeToEdit: place)
            }
        }
        .alert("Delete Place", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deletePlace(place)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(place.name)'? This action cannot be undone.")
        }
    }
}

struct DetailSectionView: View {
    let title: String
    let content: String
    let icon: String
    var isEmpty: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 20)
                
                Text(title)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Text(content)
                .font(FontManager.body)
                .foregroundColor(isEmpty ? ColorTheme.secondaryText : ColorTheme.primaryText)
                .italic(isEmpty)
                .padding(.leading, 28)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

