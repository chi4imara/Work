import SwiftUI

struct PlaceDetailView: View {
    let placeId: UUID
    @ObservedObject var placeStore: PlaceStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var place: Place? {
        placeStore.places.first { $0.id == placeId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                if let place = place {
                    ScrollView {
                        VStack(spacing: 30) {
                            VStack(spacing: 20) {
                                Text(place.name)
                                    .font(AppTheme.titleFont)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                
                                Text(place.category.displayName)
                                    .font(AppTheme.bodyFont)
                                    .foregroundColor(AppTheme.primaryBlue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.lightBlue.opacity(0.3))
                                    .cornerRadius(20)
                            }
                            .padding(.top, 30)
                            
                            VStack(spacing: 20) {
                                InfoRow(
                                    title: "Date Added",
                                    value: DateFormatter.displayDate.string(from: place.dateAdded),
                                    icon: "calendar"
                                )
                                
                                if !place.description.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "text.alignleft")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(AppTheme.primaryBlue)
                                                .frame(width: 24)
                                            
                                            Text("Description")
                                                .font(AppTheme.headlineFont)
                                                .foregroundColor(AppTheme.textPrimary)
                                            
                                            Spacer()
                                        }
                                        
                                        Text(place.description)
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.textSecondary)
                                            .lineSpacing(4)
                                            .padding(.leading, 36)
                                    }
                                    .padding(20)
                                    .cardStyle()
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 120)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete")
                                }
                                .font(AppTheme.buttonFont)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(AppTheme.buttonCornerRadius)
                                .shadow(color: Color.red.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Edit")
                                }
                                .font(AppTheme.buttonFont)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.buttonGradient)
                                .cornerRadius(AppTheme.buttonCornerRadius)
                                .shadow(color: AppTheme.buttonShadow, radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Place Not Found")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text("This place may have been deleted")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                }
            }
            .navigationTitle("Place Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showingEditView) {
                if let place = place {
                    AddEditPlaceView(placeStore: placeStore, editingPlace: place)
                }
            }
            .alert("Delete Place", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let place = place {
                        placeStore.deletePlace(place)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                if let place = place {
                    Text("Are you sure you want to delete '\(place.name)'? This action cannot be undone.")
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.primaryBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.textSecondary)
                
                Text(value)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
        }
        .padding(20)
        .cardStyle()
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(
            placeId: Place.sampleData[0].id,
            placeStore: PlaceStore.shared
        )
    }
}
