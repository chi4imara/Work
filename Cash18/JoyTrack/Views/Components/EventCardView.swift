import SwiftUI

struct EventCardView: View {
    let event: Event
    @ObservedObject var eventStore: EventStore
    @State private var showingDetails = false
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            HStack {
                HStack {
                    Image(systemName: "archivebox.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text("Archive")
                        .font(FontManager.small)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(AppColors.error)
                .cornerRadius(16)
                .opacity(offset.width < -50 ? 1 : 0)
                
                Spacer()
                
                HStack {
                    Image(systemName: event.isFavorite ? "star.slash.fill" : "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text(event.isFavorite ? "Unfavorite" : "Favorite")
                        .font(FontManager.small)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(AppColors.warning)
                .cornerRadius(16)
                .opacity(offset.width > 50 ? 1 : 0)
            }
            
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: event.type.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.accent)
                        .frame(width: 40, height: 40)
                        .background(AppColors.accent.opacity(0.1))
                        .cornerRadius(20)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(event.title)
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if event.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.accent)
                        }
                    }
                    
                    HStack {
                        Text(event.type.displayName)
                            .font(FontManager.small)
                            .foregroundColor(AppColors.background)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.accent.opacity(0.8))
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    
                    Text(event.dateString)
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    
                    if !event.shortNote.isEmpty {
                        Text(event.shortNote)
                            .font(FontManager.small)
                            .foregroundColor(AppColors.secondaryText.opacity(0.8))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            EventDetailView(event: event, eventStore: eventStore)
        }
        .alert("Archive Event", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    eventStore.archiveEvent(event)
                }
            }
        } message: {
            Text("This movie will be permanently deleted.")
        }
    }
}

#Preview {
    VStack {
        EventCardView(
            event: Event(
                title: "John's Birthday",
                type: .birthday,
                date: Date(),
                note: "Don't forget the cake!",
                isFavorite: true
            ),
            eventStore: EventStore()
        )
        .padding()
    }
    .background(AppColors.backgroundGradient)
}
