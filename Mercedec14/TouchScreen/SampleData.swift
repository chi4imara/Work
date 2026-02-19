import Foundation
import SwiftUI

enum SampleData {
        
    static let masters: [Master] = {
        [
            Master(
                name: "Sarah Johnson",
                rating: 4.9,
                reviewCount: 127,
                specialties: [.relaxation, .antiStress],
                experience: 8,
                pricePerHour: 120,
                availability: ["Morning", "Afternoon"],
                bio: "Certified massage therapist specializing in relaxation and stress relief techniques.",
                imageUrl: "",
                isVerified: true
            ),
            Master(
                name: "Michael Chen",
                rating: 4.8,
                reviewCount: 89,
                specialties: [.sports, .antiCellulite],
                experience: 6,
                pricePerHour: 100,
                availability: ["Afternoon", "Evening"],
                bio: "Sports massage specialist with focus on recovery and performance enhancement.",
                imageUrl: "",
                isVerified: true
            ),
            Master(
                name: "Emma Williams",
                rating: 4.7,
                reviewCount: 156,
                specialties: [.classic, .relaxation],
                experience: 10,
                pricePerHour: 110,
                availability: ["Morning", "Evening"],
                bio: "Traditional massage techniques combined with modern wellness approaches.",
                imageUrl: "",
                isVerified: true
            )
        ]
    }()
        
    static func catalogSessions(masters: [Master]) -> [Session] {
        guard masters.count >= 3 else { return [] }
        let calendar = Calendar.current
        return [
            Session(
                title: "Relaxing Evening Session",
                master: masters[0],
                type: .relaxation,
                duration: .sixty,
                date: calendar.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                price: 120,
                status: .scheduled,
                notes: "",
                location: .salon
            ),
            Session(
                title: "Anti-Stress Morning Treatment",
                master: masters[0],
                type: .antiStress,
                duration: .ninety,
                date: calendar.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                price: 150,
                status: .scheduled,
                notes: "",
                location: .home
            ),
            Session(
                title: "Classic Full Body Massage",
                master: masters[2],
                type: .classic,
                duration: .sixty,
                date: calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                price: 110,
                status: .scheduled,
                notes: "",
                location: .salon
            ),
            Session(
                title: "Sports Recovery Session",
                master: masters[1],
                type: .sports,
                duration: .sixty,
                date: calendar.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                price: 100,
                status: .scheduled,
                notes: "",
                location: .salon
            ),
            Session(
                title: "Anti-Cellulite Treatment",
                master: masters[1],
                type: .antiCellulite,
                duration: .ninety,
                date: calendar.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
                price: 140,
                status: .scheduled,
                notes: "",
                location: .home
            )
        ]
    }
        
    static func bookedSessions(masters: [Master]) -> [Session] {
        guard masters.count >= 3 else { return [] }
        let calendar = Calendar.current
        return [
            Session(
                title: "Relaxing Evening Session",
                master: masters[0],
                type: .relaxation,
                duration: .sixty,
                date: calendar.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                price: 120,
                status: .scheduled,
                notes: "Please focus on shoulders and neck",
                location: .salon
            ),
            Session(
                title: "Anti-Stress Treatment",
                master: masters[1],
                type: .antiStress,
                duration: .ninety,
                date: calendar.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                price: 150,
                status: .completed,
                notes: "",
                location: .home,
                userRating: 5,
                userReview: "Excellent service!"
            ),
            Session(
                title: "Sports Recovery",
                master: masters[2],
                type: .sports,
                duration: .sixty,
                date: calendar.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                price: 110,
                status: .missed,
                notes: "",
                location: .salon
            )
        ]
    }
        
    static var stressLevels: [StressDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        return [
            StressDataPoint(date: calendar.date(byAdding: .day, value: -30, to: now) ?? now, level: 8),
            StressDataPoint(date: calendar.date(byAdding: .day, value: -25, to: now) ?? now, level: 6),
            StressDataPoint(date: calendar.date(byAdding: .day, value: -20, to: now) ?? now, level: 5),
            StressDataPoint(date: calendar.date(byAdding: .day, value: -15, to: now) ?? now, level: 4),
            StressDataPoint(date: calendar.date(byAdding: .day, value: -10, to: now) ?? now, level: 3),
            StressDataPoint(date: calendar.date(byAdding: .day, value: -5, to: now) ?? now, level: 3),
            StressDataPoint(date: now, level: 2)
        ]
    }
}
