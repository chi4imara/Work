import SwiftUI

struct EventDetailView: View {
    let event: Event
    @ObservedObject var eventStore: EventStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        EventHeaderSection(event: event, eventStore: eventStore)
                        
                        if !event.note.isEmpty {
                            EventDescriptionSection(note: event.note)
                        }
                        
                        if !event.giftIdeas.isEmpty {
                            GiftIdeasSection(giftIdeas: event.giftIdeas)
                        }
                        
                        if event.note.isEmpty && event.giftIdeas.isEmpty {
                            EmptyContentSection()
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { 
                            eventStore.toggleFavorite(event)
                        }) {
                            Image(systemName: event.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(event.isFavorite ? AppColors.accent : AppColors.secondaryText)
                        }
                        
                        Menu {
                            Button("Edit Event") {
                                showingEditView = true
                            }
                            
                            Button("Delete Event", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditEventView(eventStore: eventStore, eventToEdit: event)
        }
        .alert("Delete Event", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                eventStore.archiveEvent(event)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This movie will be permanently deleted.")
        }
    }
}

struct EventHeaderSection: View {
    let event: Event
    @ObservedObject var eventStore: EventStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: event.type.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 60, height: 60)
                    .background(AppColors.accent.opacity(0.1))
                    .cornerRadius(30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.type.displayName)
                        .font(FontManager.small)
                        .foregroundColor(AppColors.background)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.accent)
                        .cornerRadius(12)
                    
                    Text(event.dateString)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                }
                
                Spacer()
                
                if event.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            Text(event.title)
                .font(FontManager.title)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct EventDescriptionSection: View {
    let note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.accent)
                
                Text("Description")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(note)
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct GiftIdeasSection: View {
    let giftIdeas: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "gift")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.accent)
                
                Text("Gift Ideas")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(giftIdeas.enumerated()), id: \.offset) { index, idea in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1).")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.accent)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(idea)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct EmptyContentSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 40))
                .foregroundColor(AppColors.accent.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No additional details")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("You can add description and gift ideas by editing this event")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    EventDetailView(
        event: Event(
            title: "John's Birthday",
            type: .birthday,
            date: Date(),
            note: "Don't forget to bring the birthday cake and decorations. John loves chocolate cake with vanilla frosting.",
            giftIdeas: ["Chocolate cake", "New book", "Gift card"],
            isFavorite: true
        ),
        eventStore: EventStore()
    )
}
