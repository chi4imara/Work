import SwiftUI

struct TripDetailView: View {
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    let trip: Trip
    
    @State private var showingEditForm = false
    @State private var showingArchiveAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    if !trip.notes.isEmpty {
                        notesSection
                    }
                    
                    if !trip.places.isEmpty {
                        placesSection
                    } else {
                        emptyPlacesSection
                    }
                    
                    if !trip.impressions.isEmpty {
                        impressionsSection
                    } else {
                        emptyImpressionsSection
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditForm = true }) {
                        Label("Edit Trip", systemImage: "pencil")
                    }
                    
                    Button(action: { showingArchiveAlert = true }) {
                        Label("Delete Trip", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(ColorTheme.primaryText)
                }
            }
        }
        .sheet(isPresented: $showingEditForm) {
            TripFormView(trip: trip)
        }
        .alert("Delete Trip", isPresented: $showingArchiveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.archiveTrip(trip)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This trip information will be permanently deleted.")
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(trip.title)
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(trip.locationString)
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.secondaryText)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(ColorTheme.accent)
                
                Text(trip.dateString)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notes")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(trip.notes)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var placesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Places Visited")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(trip.places.enumerated()), id: \.offset) { index, place in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1).")
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.accent)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(place)
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var emptyPlacesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Places Visited")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Text("No places added yet. Add them in editing mode.")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText.opacity(0.7))
                .italic()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var impressionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Impressions")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(trip.impressions.sorted(by: { $0.createdAt > $1.createdAt })) { impression in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 12))
                            .foregroundColor(ColorTheme.accent)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(impression.text)
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(formatDate(impression.createdAt))
                                .font(FontManager.small)
                                .foregroundColor(ColorTheme.secondaryText.opacity(0.7))
                        }
                    }
                    .padding(12)
                    .background(
                        ColorTheme.cardBackground
                            .cornerRadius(8)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var emptyImpressionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Impressions")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Text("No impressions added yet. Add them in editing mode.")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText.opacity(0.7))
                .italic()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        TripDetailView(trip: Trip(
            title: "Paris Adventure",
            country: "France",
            city: "Paris",
            startDate: Date(),
            endDate: Date(),
            notes: "Amazing trip to the city of lights!",
            places: ["Eiffel Tower", "Louvre Museum", "Notre Dame"],
            impressions: [
                Impression(text: "The Eiffel Tower was breathtaking at sunset!"),
                Impression(text: "Best croissants ever at the local bakery.")
            ]
        ))
    }
}

