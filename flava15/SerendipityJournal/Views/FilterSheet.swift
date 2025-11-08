import SwiftUI

struct FilterSheet: View {
    @ObservedObject var meetingStore: MeetingStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeriod: FilterPeriod
    @State private var selectedLocation: String
    
    init(meetingStore: MeetingStore) {
        self.meetingStore = meetingStore
        self._selectedPeriod = State(initialValue: meetingStore.selectedPeriod)
        self._selectedLocation = State(initialValue: meetingStore.selectedLocation)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Time Period")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Divider()
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 8) {
                                ForEach(FilterPeriod.allCases, id: \.self) { period in
                                    FilterOptionRow(
                                        title: period.localizedString,
                                        isSelected: selectedPeriod == period
                                    ) {
                                        selectedPeriod = period
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Location")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Divider()
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 8) {
                                FilterOptionRow(
                                    title: "All locations",
                                    isSelected: selectedLocation == "All locations"
                                ) {
                                    selectedLocation = "All locations"
                                }
                                
                                ForEach(meetingStore.uniqueLocations, id: \.self) { location in
                                    FilterOptionRow(
                                        title: location,
                                        isSelected: selectedLocation == location
                                    ) {
                                        selectedLocation = location
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Button("Apply Filters") {
                                meetingStore.applyFilters(period: selectedPeriod, location: selectedLocation)
                                dismiss()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Reset Filters") {
                                selectedPeriod = .all
                                selectedLocation = "All locations"
                                meetingStore.resetFilters()
                                dismiss()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryPurple)
                }
            }
        }
    }
}

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.theme.primaryBlue.opacity(0.1) : Color.white.opacity(0.6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.theme.primaryBlue : Color.gray.opacity(0.7), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.theme.buttonText)
            .foregroundColor(Color.theme.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.buttonBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.theme.buttonText)
            .foregroundColor(Color.theme.primaryPurple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.primaryPurple, lineWidth: 1)
                    .background(Color.white.opacity(0.8))
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    FilterSheet(meetingStore: MeetingStore())
}
