import Foundation

extension MeetingStore {
    func loadSampleData() {
        let sampleMeetings = [
            Meeting(
                title: "Conversation with Street Musician",
                description: "Had an amazing conversation with a street musician playing violin near the central park. He told me about his journey from classical music to street performance and how it changed his perspective on connecting with people. We talked for about 30 minutes about music, life, and the beauty of unexpected encounters.",
                location: "Central Park",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
            ),
            Meeting(
                title: "Chat with Elderly Bookstore Owner",
                description: "While browsing through old books, I struck up a conversation with the bookstore owner who has been running this place for 40 years. She shared fascinating stories about famous authors who used to visit her store and how the neighborhood has changed over the decades.",
                location: "Old Town Bookstore",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
            ),
            Meeting(
                title: "Meeting a Fellow Traveler at Airport",
                description: "During a flight delay, I met a fellow traveler who was on their way to volunteer in a remote village. We discussed travel experiences, cultural differences, and the impact of volunteering on personal growth. It was inspiring to hear about their dedication to helping others.",
                location: "Airport Terminal 2",
                date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
            ),
            Meeting(
                title: "Unexpected Encounter with Local Artist",
                description: "While walking through the art district, I stumbled upon a local artist creating a beautiful mural. We talked about their artistic process, inspiration from the community, and how art can bring people together. They even let me help with a small part of the mural!",
                location: "Art District",
                date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()
            ),
            Meeting(
                title: "Coffee Shop Philosophy Discussion",
                description: "A stranger at the coffee shop overheard me reading a philosophy book and initiated a deep conversation about existentialism and the meaning of life. What started as a casual comment turned into a two-hour discussion about consciousness, free will, and human nature.",
                location: "Corner Coffee Shop",
                date: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date()
            )
        ]
        
        for meeting in sampleMeetings {
            addMeeting(meeting)
        }
    }
}
