import Foundation

extension DataManager {
    func loadSampleData() {
        outfits.removeAll()
        notes.removeAll()
        weekPlan = WeekPlan()
        
        let sampleOutfits = [
            Outfit(
                name: "Casual Jeans & White Shirt",
                season: .spring,
                mood: .casual,
                situation: .work,
                comment: "Perfect for everyday wear. Add a nice watch and comfortable sneakers.",
                isFavorite: true
            ),
            Outfit(
                name: "Business Meeting Look",
                season: .autumn,
                mood: .business,
                situation: .meeting,
                comment: "Navy blazer with matching trousers. Don't forget the leather shoes.",
                isFavorite: false
            ),
            Outfit(
                name: "Romantic Dinner Dress",
                season: .summer,
                mood: .romantic,
                situation: .evening,
                comment: "Little black dress with heels. Add some jewelry for extra elegance.",
                isFavorite: true
            ),
            Outfit(
                name: "Cozy Weekend Sweater",
                season: .winter,
                mood: .cozy,
                situation: .walk,
                comment: "Warm knit sweater with comfortable jeans. Perfect for coffee dates.",
                isFavorite: false
            ),
            Outfit(
                name: "Summer Beach Vibes",
                season: .summer,
                mood: .casual,
                situation: .walk,
                comment: "Light cotton dress with sandals. Don't forget sunglasses!",
                isFavorite: true
            ),
            Outfit(
                name: "Professional Presentation",
                season: .spring,
                mood: .business,
                situation: .work,
                comment: "Sharp suit with confidence. Make sure everything is pressed.",
                isFavorite: false
            )
        ]
        
        let sampleNotes = [
            Note(
                title: "Capsule Wardrobe Ideas",
                content: "Build a capsule wardrobe with these essentials:\n\n• 2-3 pairs of quality jeans\n• 5-7 basic tops in neutral colors\n• 1-2 blazers for layering\n• Comfortable shoes for different occasions\n• A few statement accessories\n\nFocus on pieces that mix and match easily!"
            ),
            Note(
                title: "Shopping List - Fall",
                content: "Items to buy for fall season:\n\n• Warm cardigan in beige or cream\n• Ankle boots in brown leather\n• Cozy scarf for layering\n• Dark wash jeans\n• Turtleneck sweaters\n\nBudget: $300-400"
            ),
            Note(
                title: "Color Combinations",
                content: "Great color combinations that always work:\n\n• Navy + White + Gold accents\n• Black + Cream + Silver\n• Olive Green + Cream + Brown\n• Burgundy + Gray + Rose Gold\n• Camel + White + Black\n\nThese combinations are timeless and versatile."
            ),
            Note(
                title: "Outfit Planning Tips",
                content: "Tips for better outfit planning:\n\n1. Plan outfits the night before\n2. Consider the weather forecast\n3. Think about your daily activities\n4. Have backup options ready\n5. Keep a 'go-to' outfit for emergencies\n\nThis saves time and reduces morning stress!"
            )
        ]
        
        for outfit in sampleOutfits {
            addOutfit(outfit)
        }
        
        for note in sampleNotes {
            addNote(note)
        }
        
        if let casualOutfit = outfits.first(where: { $0.name.contains("Casual") }),
           let businessOutfit = outfits.first(where: { $0.name.contains("Business") }),
           let romanticOutfit = outfits.first(where: { $0.name.contains("Romantic") }) {
            
            setOutfitForDay(.monday, outfitId: businessOutfit.id)
            setOutfitForDay(.wednesday, outfitId: casualOutfit.id)
            setOutfitForDay(.friday, outfitId: romanticOutfit.id)
        }
    }
}

#if DEBUG
extension DataManager {
    static var preview: DataManager {
        let manager = DataManager.shared
        manager.loadSampleData()
        return manager
    }
}
#endif
