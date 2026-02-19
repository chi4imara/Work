import Foundation

enum SampleData {
    
    static var salons: [SPASalon] {
        [
            SPASalon(
                name: "Serenity Spa & Wellness",
                rating: 4.8,
                reviewCount: 127,
                distance: 0.8,
                imageURL: "",
                availableServices: [
                    SPAService(name: "Deep Tissue Massage", duration: 60, price: 120, category: .massage, description: "Relaxing deep tissue massage"),
                    SPAService(name: "Facial Treatment", duration: 45, price: 85, category: .facial, description: "Rejuvenating facial treatment")
                ],
                priceRange: .premium,
                hasDiscount: true,
                discountPercentage: 15
            ),
            SPASalon(
                name: "Blissful Touch Spa",
                rating: 4.6,
                reviewCount: 89,
                distance: 1.2,
                imageURL: "",
                availableServices: [
                    SPAService(name: "Hot Stone Massage", duration: 90, price: 150, category: .massage, description: "Therapeutic hot stone massage"),
                    SPAService(name: "Body Wrap", duration: 75, price: 95, category: .bodyWrap, description: "Detoxifying body wrap")
                ],
                priceRange: .luxury,
                hasDiscount: false,
                discountPercentage: nil
            ),
            SPASalon(
                name: "Urban Oasis Spa",
                rating: 4.4,
                reviewCount: 203,
                distance: 2.1,
                imageURL: "",
                availableServices: [
                    SPAService(name: "Swedish Massage", duration: 60, price: 80, category: .massage, description: "Classic Swedish massage"),
                    SPAService(name: "Manicure", duration: 30, price: 45, category: .manicure, description: "Professional manicure service")
                ],
                priceRange: .moderate,
                hasDiscount: true,
                discountPercentage: 10
            ),
            SPASalon(
                name: "Tranquil Waters Spa",
                rating: 4.9,
                reviewCount: 156,
                distance: 1.8,
                imageURL: "",
                availableServices: [
                    SPAService(name: "Aromatherapy Massage", duration: 75, price: 110, category: .aromatherapy, description: "Relaxing aromatherapy session"),
                    SPAService(name: "Anti-Aging Facial", duration: 60, price: 130, category: .facial, description: "Advanced anti-aging treatment")
                ],
                priceRange: .premium,
                hasDiscount: false,
                discountPercentage: nil
            ),
            SPASalon(
                name: "Zen Garden Spa",
                rating: 4.2,
                reviewCount: 74,
                distance: 3.5,
                imageURL: "",
                availableServices: [
                    SPAService(name: "Couples Massage", duration: 90, price: 200, category: .massage, description: "Romantic couples massage"),
                    SPAService(name: "Pedicure", duration: 45, price: 55, category: .pedicure, description: "Luxury pedicure service")
                ],
                priceRange: .moderate,
                hasDiscount: true,
                discountPercentage: 20
            )
        ]
    }
    
    static func bookings(calendar: Calendar = .current) -> [Booking] {
        let now = Date()
        return [
            Booking(
                salonName: "Serenity Spa & Wellness",
                serviceName: "Deep Tissue Massage",
                masterName: "Sarah Johnson",
                date: calendar.date(byAdding: .day, value: 2, to: now) ?? now,
                duration: 60,
                price: 120,
                status: .scheduled
            ),
            Booking(
                salonName: "Blissful Touch Spa",
                serviceName: "Hot Stone Massage",
                masterName: "Maria Garcia",
                date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                duration: 90,
                price: 150,
                status: .completed
            ),
            Booking(
                salonName: "Urban Oasis Spa",
                serviceName: "Swedish Massage",
                masterName: "Emily Chen",
                date: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                duration: 60,
                price: 80,
                status: .completed
            ),
            Booking(
                salonName: "Tranquil Waters Spa",
                serviceName: "Aromatherapy Massage",
                masterName: "Lisa Anderson",
                date: calendar.date(byAdding: .day, value: -7, to: now) ?? now,
                duration: 75,
                price: 110,
                status: .missed
            ),
            Booking(
                salonName: "Serenity Spa & Wellness",
                serviceName: "Facial Treatment",
                masterName: "Sarah Johnson",
                date: calendar.date(byAdding: .day, value: -15, to: now) ?? now,
                duration: 45,
                price: 85,
                status: .completed
            )
        ]
    }
    
    static var profile: UserProfile {
        var p = UserProfile()
        p.name = "Alex Johnson"
        p.email = "alex.johnson@example.com"
        p.favoriteServices = [.massage, .facial]
        p.favoriteSalon = "Serenity Spa & Wellness"
        p.visitGoal = 4
        p.notificationsEnabled = true
        return p
    }
}
