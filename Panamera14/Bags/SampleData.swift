import Foundation

extension BagStore {
    func loadSampleData() {
        guard bags.isEmpty else { return }
        
        let sampleBags = [
            Bag(
                name: "Work Tote",
                size: .large,
                style: .business,
                suitableFor: "work, meetings, business trips"
            ),
            Bag(
                name: "Evening Clutch",
                size: .small,
                style: .evening,
                suitableFor: "dinner, parties, special occasions"
            ),
            Bag(
                name: "Weekend Backpack",
                size: .medium,
                style: .casual,
                suitableFor: "weekend trips, casual outings, shopping"
            ),
            Bag(
                name: "Gym Bag",
                size: .medium,
                style: .sport,
                suitableFor: "gym, sports, fitness activities"
            ),
            Bag(
                name: "Classic Handbag",
                size: .medium,
                style: .classic,
                suitableFor: "daily use, work, casual meetings"
            )
        ]
        
        for bag in sampleBags {
            addBag(bag)
        }
        
        if let firstBag = bags.first {
            toggleFavorite(for: firstBag)
        }
        if bags.count > 2 {
            toggleFavorite(for: bags[2])
        }
    }
}
