import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var showOnboarding = false
    @Published var isFirstLaunch = true
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            showOnboarding = true
        }
    }
    
    func completeSplash() {
        showSplash = false
    }
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
}

class ProceduresViewModel: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var showingProcedureSaved = false
    @Published var savedProcedure: Procedure?
    
    private let userDefaultsKey = "SavedProcedures"
    
    init() {
        loadProcedures()
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        savedProcedure = procedure
        saveProcedures()
        showingProcedureSaved = true
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveProcedures()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        saveProcedures()
    }
    
    func getProductStatistics() -> [ProductStatistics] {
        var productCounts: [String: Int] = [:]
        var productProcedures: [String: [Procedure]] = [:]
        
        for procedure in procedures {
            let products = procedure.products.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            for product in products {
                productCounts[product, default: 0] += 1
                productProcedures[product, default: []].append(procedure)
            }
        }
        
        return productCounts.map { product, count in
            ProductStatistics(
                name: product,
                usageCount: count,
                procedures: productProcedures[product] ?? []
            )
        }.sorted { $0.usageCount > $1.usageCount }
    }
    
    private func saveProcedures() {
        if let encoded = try? JSONEncoder().encode(procedures) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadProcedures() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Procedure].self, from: data) {
            procedures = decoded.sorted { $0.date > $1.date }
        }
    }
}

class SettingsViewModel: ObservableObject {
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/stubblebeard-ritual-privacy-policy/9d644fa9-107b-4069-bc82-b18617aeda87/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://forms.gle/Ga5v5hh7rc6yDyY56") {
            UIApplication.shared.open(url)
        }
    }
}
