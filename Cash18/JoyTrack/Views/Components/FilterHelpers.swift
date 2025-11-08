import SwiftUI

struct FilterHelpers {
    static func createFilterButtons(eventStore: EventStore) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        for eventType in EventType.allCases {
            let isSelected = eventStore.selectedEventTypes.contains(eventType)
            buttons.append(
                .default(Text("\(isSelected ? "✓ " : "")\(eventType.displayName)")) {
                    if isSelected {
                        eventStore.selectedEventTypes.remove(eventType)
                    } else {
                        eventStore.selectedEventTypes.insert(eventType)
                    }
                }
            )
        }
        
        buttons.append(.default(Text("Reset Filters")) {
            eventStore.selectedEventTypes = Set(EventType.allCases)
            eventStore.searchText = ""
        })
        
        buttons.append(.cancel())
        return buttons
    }
    
    static func createSortButtons(eventStore: EventStore) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        for option in EventStore.SortOption.allCases {
            let isSelected = eventStore.sortOption == option
            buttons.append(
                .default(Text("\(isSelected ? "✓ " : "")\(option.rawValue)")) {
                    eventStore.sortOption = option
                }
            )
        }
        
        buttons.append(.cancel())
        return buttons
    }
}
