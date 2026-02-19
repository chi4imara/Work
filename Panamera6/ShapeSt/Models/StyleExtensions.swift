import Foundation

extension Style {
    static var sampleStyles: [Style] {
        [
            Style(
                name: "Classic Fade",
                category: .haircut,
                length: "6mm",
                shape: "Fade",
                description: "A timeless fade cut that works for any occasion. Clean and professional look.",
                isFavorite: true
            ),
            Style(
                name: "Full Beard",
                category: .beard,
                length: "Medium",
                shape: "Full Beard",
                description: "A well-maintained full beard that adds character and maturity.",
                isFavorite: false
            ),
            Style(
                name: "Buzz Cut",
                category: .haircut,
                length: "3mm",
                shape: "Buzz Cut",
                description: "Simple, low-maintenance cut perfect for active lifestyle.",
                isFavorite: false
            )
        ]
    }
}
