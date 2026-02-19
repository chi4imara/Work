import SwiftUI

struct EventDetailView: View {
    let eventId: UUID
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var event: Event? {
        viewModel.getEvent(by: eventId)
    }
    
    var body: some View {
        Group {
            if let event = event {
                ZStack {
                    AnimatedBackground()
                    
                    ScrollView {
                        VStack(spacing: 40) {
                            VStack(spacing: 30) {
                                VStack(spacing: 12) {
                                    Text("Event")
                                        .font(.custom("PlayfairDisplay-Medium", size: 16))
                                        .foregroundColor(ColorTheme.textSecondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(event.text)
                                        .font(.custom("PlayfairDisplay-Regular", size: 20))
                                        .foregroundColor(ColorTheme.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(ColorTheme.cardBackground)
                                        .cornerRadius(12)
                                        .shadow(color: ColorTheme.shadowColor, radius: 4, x: 0, y: 2)
                                }
                                
                                VStack(spacing: 12) {
                                    Text("Time")
                                        .font(.custom("PlayfairDisplay-Medium", size: 16))
                                        .foregroundColor(ColorTheme.textSecondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(ColorTheme.primaryBlue)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(event.formattedTime)
                                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                                .foregroundColor(ColorTheme.textPrimary)
                                            
                                            Text(event.formattedDate)
                                                .font(.custom("PlayfairDisplay-Regular", size: 14))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: ColorTheme.shadowColor, radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Edit")
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [ColorTheme.primaryBlue, ColorTheme.accentYellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete")
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorTheme.deleteRed)
                                .cornerRadius(25)
                                .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
                .navigationTitle("Event")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingEditView) {
                    EditEventView(event: event, viewModel: viewModel)
                }
                .alert("Delete Event", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let eventToDelete = viewModel.getEvent(by: eventId) {
                            viewModel.deleteEvent(eventToDelete)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to delete this event? This action cannot be undone.")
                }
            } else {
                ZStack {
                    AnimatedBackground()
                    
                    VStack {
                        Text("Event not found")
                            .font(.custom("PlayfairDisplay-Medium", size: 18))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
                .navigationTitle("Event")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
