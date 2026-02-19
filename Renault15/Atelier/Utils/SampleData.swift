import Foundation

enum SampleData {
    
    static var sampleHairstyles: [Hairstyle] {
        let calendar = Calendar.current
        let today = Date()
        
        let list: [(String, HairstyleCategory, HairLength, String, String)] = [
            ("Bob Cut", .cuts, .medium, "Dark Brown", "Classic bob"),
            ("Long Waves", .styling, .long, "Blonde", "Beach waves"),
            ("Balayage", .color, .long, "Caramel", "Sun-kissed look"),
            ("French Braid", .braids, .long, "Brown", "Elegant braid"),
            ("Pixie Cut", .cuts, .short, "Black", "Short and stylish"),
            ("Straight Blowout", .styling, .medium, "Auburn", "Sleek finish"),
            ("Highlights", .color, .medium, "Light Brown", "Face-framing highlights"),
            ("Fishtail Braid", .braids, .long, "Blonde", "Casual braid")
        ]
        
        return list.enumerated().map { index, item in
            Hairstyle(
                name: item.0,
                category: item.1,
                hairLength: item.2,
                hairColor: item.3,
                comment: item.4,
                dateCreated: calendar.date(byAdding: .day, value: -index, to: today) ?? today
            )
        }
    }
    
    static var sampleLooks: [Look] {
        let styles = sampleHairstyles
        let calendar = Calendar.current
        let today = Date()
        
        let lookData: [(String, Int, Bool)] = [
            ("Weekend Casual", 2, true),
            ("Office Style", 1, false),
            ("Evening Look", 3, false)
        ]
        
        return lookData.enumerated().map { index, item in
            Look(
                name: item.0,
                hairstyles: Array(styles.prefix(item.1)),
                dateCreated: calendar.date(byAdding: .day, value: -index, to: today) ?? today,
                isFavorite: item.2
            )
        }
    }
    
    static var sampleCategories: [CustomCategory] {
        [
            CustomCategory(name: "Special Occasions", isRepeating: false),
            CustomCategory(name: "Everyday", isRepeating: true)
        ]
    }
}
