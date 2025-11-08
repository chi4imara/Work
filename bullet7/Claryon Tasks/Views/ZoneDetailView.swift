import SwiftUI

struct ZoneDetailView: View {
    let zoneId: UUID
    @ObservedObject var viewModel: CleaningZoneViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingMenu = false
    
    var zoneO: CleaningZone? {
        if let index = viewModel.filteredAndSortedZones.first(where: { $0.id == zoneId }) {
            index
        } else {
            nil
        }
    }
    
    var body: some View {
        NavigationView {
            if let zone = zoneO {
                ZStack {
                    Color.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text(zone.name)
                                .font(.titleLarge)
                                .foregroundColor(.primaryWhite)
                                .multilineTextAlignment(.leading)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.bodySmall)
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                
                                Text(zone.category.isEmpty ? "No category" : zone.category)
                                    .font(.bodyLarge)
                                    .foregroundColor(.primaryWhite)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.bodySmall)
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                
                                Text(zone.description.isEmpty ? "No description" : zone.description)
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryWhite)
                                    .lineSpacing(4)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.bodySmall)
                                    .foregroundColor(.secondaryText)
                                    .textCase(.uppercase)
                                
                                HStack {
                                    Image(systemName: zone.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(zone.isCompleted ? .successGreen : .accentYellow)
                                    
                                    Text(zone.formattedLastCleanedDate)
                                        .font(.bodyMedium)
                                        .foregroundColor(.primaryWhite)
                                }
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .navigationTitle("Zone Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentYellow)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingMenu = true }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.accentYellow)
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    AddEditZoneView(viewModel: viewModel, zoneToEdit: zone)
                }
                .confirmationDialog(zone.name, isPresented: $showingMenu) {
                    Button("Edit") { showingEditView = true }
                    Button("Delete", role: .destructive) { showingDeleteAlert = true }
                    Button("Cancel", role: .cancel) { }
                }
                .alert("Delete Zone", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteZone(zone)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete \"\(zone.name)\"?")
                    
                }
            }
        }
    }
}
