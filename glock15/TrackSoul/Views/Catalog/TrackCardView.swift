import SwiftUI

struct TrackCardView: View {
    let track: TrackData
    let onTap: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.title)
                            .font(.appHeadline)
                            .foregroundColor(.appPrimaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Text(track.artist ?? "Unknown Artist")
                            .font(.appCallout)
                            .foregroundColor(.appSecondaryText)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: track.dateAdded))
                        .font(.appCaption1)
                        .foregroundColor(.appSecondaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appBackgroundGray)
                        .cornerRadius(8)
                }
                
                if !track.whereHeard.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 12))
                            .foregroundColor(.appPrimaryBlue)
                        
                        Text("Where heard:")
                            .font(.appCaption1)
                            .foregroundColor(.appSecondaryText)
                        
                        Text(track.whereHeard)
                            .font(.appCaption1)
                            .foregroundColor(.appPrimaryBlue)
                        
                        if let context = track.context, !context.isEmpty {
                            Text("• \(context)")
                                .font(.appCaption1)
                                .foregroundColor(.appSecondaryText)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                }
                
                if let whatReminds = track.whatReminds, !whatReminds.isEmpty {
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "heart")
                            .font(.system(size: 12))
                            .foregroundColor(.appAccent)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reminds me of:")
                                .font(.appCaption1)
                                .foregroundColor(.appSecondaryText)
                            
                            Text(whatReminds)
                                .font(.appCaption1)
                                .foregroundColor(.appPrimaryText)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBackgroundWhite)
                    .shadow(color: .appShadow, radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appGridBlue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleTrack = TrackData(
        title: "Bohemian Rhapsody",
        artist: "Queen",
        whereHeard: .radio,
        context: "Morning drive to work",
        whatReminds: "My college days and late night study sessions with friends"
    )
    
    return VStack {
        TrackCardView(track: sampleTrack) {
            print("Track tapped")
        }
        .padding()
        
        Spacer()
    }
    .background(BackgroundView())
}
