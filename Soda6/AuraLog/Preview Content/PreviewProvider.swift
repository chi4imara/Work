import SwiftUI

#if DEBUG
struct PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        let store = PerfumeStore()
        
        let samplePerfume = Perfume(
            name: "Libre",
            brand: "Yves Saint Laurent",
            notes: "lavender, vanilla, orange blossom",
            season: .autumn,
            mood: .energetic,
            favoriteCombinations: "Pairs well with warm vanilla scents"
        )
        
        store.addPerfume(samplePerfume)
        
        return MainTabView()
            .environmentObject(store)
    }
}
#endif
