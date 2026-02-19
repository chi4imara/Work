import SwiftUI

struct EventDetailView: View {
    let eventId: UUID
    let eventStore: EventStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var event: Event? {
        eventStore.getEvent(by: eventId)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            if let event = event {
                detailContent(event: event)
            } else {
                eventNotFoundContent
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let event = event {
                EditEventView(event: event, eventStore: eventStore) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .alert("Delete Event", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let event = event {
                    eventStore.deleteEvent(event)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this event? This action cannot be undone.")
        }
    }
    
    private func detailContent(event: Event) -> some View {
        Group {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(AppFonts.body(16))
                        }
                        .foregroundColor(AppColors.primaryWhite)
                    }
                    
                    Spacer()
                    
                    Text("Event")
                        .font(AppFonts.title(24))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(AppFonts.body(16))
                    }
                    .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Event")
                                .font(AppFonts.caption(14))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                .textCase(.uppercase)
                            
                            Text(event.title)
                                .font(AppFonts.headline(20))
                                .foregroundColor(AppColors.primaryWhite)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(AppFonts.caption(14))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                .textCase(.uppercase)
                            
                            Text(event.formattedDate)
                                .font(AppFonts.headline(18))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 200)
                }
            }
            
            VStack(spacing: 16) {
                Spacer()
                
                Button(action: {
                    showingEditView = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Edit")
                            .font(AppFonts.headline(16))
                    }
                    .foregroundColor(AppColors.primaryBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(AppConstants.cornerRadius)
                }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Delete")
                            .font(AppFonts.headline(16))
                    }
                    .foregroundColor(AppColors.primaryWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColors.accentOrange.opacity(0.8))
                    .cornerRadius(AppConstants.cornerRadius)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    private var eventNotFoundContent: some View {
        VStack(spacing: 24) {
            Text("Event not found")
                .font(AppFonts.headline(18))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            
            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(AppFonts.body(16))
            .foregroundColor(AppColors.primaryYellow)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EventDetailSheetItem: Identifiable {
    var id: UUID { eventId }
    let eventId: UUID
}
