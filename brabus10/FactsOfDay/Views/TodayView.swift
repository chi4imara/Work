import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State private var showingNewEvent = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Today")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.todayEvents.isEmpty {
                    EmptyStateView()
                } else {
                    EventsList(events: viewModel.todayEvents, viewModel: viewModel)
                }
            }
            
            VStack {
                Spacer()
                
                Button(action: { showingNewEvent = true }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Add")
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
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingNewEvent) {
            NewEventView(viewModel: viewModel)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock.badge.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Your day appears here as simple facts.")
                    .font(.custom("PlayfairDisplay-Medium", size: 18))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add the first event to start the timeline.")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct EventsList: View {
    let events: [Event]
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(eventId: event.id, viewModel: viewModel)) {
                        EventCard(event: event)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(event.formattedTime)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            .frame(width: 70)
            
            Text(event.text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorTheme.shadowColor, radius: 4, x: 0, y: 2)
    }
}
