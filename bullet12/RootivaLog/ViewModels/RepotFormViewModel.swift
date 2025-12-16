import Foundation
import Combine

@MainActor
class RepotFormViewModel: ObservableObject {
    @Published var plantName: String = ""
    @Published var repotDate: Date = Date()
    @Published var potDiameter: String = ""
    @Published var potHeight: String = ""
    @Published var soilType: String = ""
    @Published var hasDrainage: Bool = false
    @Published var careNote: String = ""
    
    @Published var plantNameError: String = ""
    @Published var potDiameterError: String = ""
    @Published var potHeightError: String = ""
    
    @Published var isLoading: Bool = false
    @Published var showingDeleteAlert: Bool = false
    
    private var editingRecord: RepotRecord?
    
    var isEditing: Bool {
        return editingRecord != nil
    }
    
    var isValid: Bool {
        return !plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               potDiameterError.isEmpty &&
               potHeightError.isEmpty
    }
    
    var navigationTitle: String {
        return isEditing ? "Edit Repotting" : "New Repotting"
    }
    
    func loadRecord(_ record: RepotRecord) {
        editingRecord = record
        plantName = record.plantName
        repotDate = record.repotDate
        potDiameter = record.potDiameter?.description ?? ""
        potHeight = record.potHeight?.description ?? ""
        soilType = record.soilType ?? ""
        hasDrainage = record.hasDrainage
        careNote = record.careNote ?? ""
    }
    
    func validateFields() {
        validatePlantName()
        validatePotDiameter()
        validatePotHeight()
    }
    
    private func validatePlantName() {
        let trimmed = plantName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            plantNameError = "Enter plant name"
        } else if trimmed.count > 60 {
            plantNameError = "Plant name too long (max 60 characters)"
        } else {
            plantNameError = ""
        }
    }
    
    private func validatePotDiameter() {
        if potDiameter.isEmpty {
            potDiameterError = ""
            return
        }
        
        guard let diameter = Int(potDiameter), diameter >= 1, diameter <= 80 else {
            potDiameterError = "Enter number from 1 to 80"
            return
        }
        
        potDiameterError = ""
    }
    
    private func validatePotHeight() {
        if potHeight.isEmpty {
            potHeightError = ""
            return
        }
        
        guard let height = Int(potHeight), height >= 1, height <= 100 else {
            potHeightError = "Enter number from 1 to 100"
            return
        }
        
        potHeightError = ""
    }
    
    func createRecord() -> RepotRecord? {
        validateFields()
        
        guard isValid else { return nil }
        
        let normalizedPlantName = plantName.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "  ", with: " ")
        
        let diameter = potDiameter.isEmpty ? nil : Int(potDiameter)
        let height = potHeight.isEmpty ? nil : Int(potHeight)
        let soil = soilType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : soilType
        let note = careNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : careNote
        
        if let existingRecord = editingRecord {
            var updatedRecord = existingRecord
            updatedRecord.plantName = normalizedPlantName
            updatedRecord.repotDate = repotDate
            updatedRecord.potDiameter = diameter
            updatedRecord.potHeight = height
            updatedRecord.soilType = soil
            updatedRecord.hasDrainage = hasDrainage
            updatedRecord.careNote = note
            return updatedRecord
        } else {
            return RepotRecord(
                plantName: normalizedPlantName,
                repotDate: repotDate,
                potDiameter: diameter,
                potHeight: height,
                soilType: soil,
                hasDrainage: hasDrainage,
                careNote: note
            )
        }
    }
    
    func reset() {
        editingRecord = nil
        plantName = ""
        repotDate = Date()
        potDiameter = ""
        potHeight = ""
        soilType = ""
        hasDrainage = false
        careNote = ""
        
        plantNameError = ""
        potDiameterError = ""
        potHeightError = ""
    }
    
    func showDeleteAlert() {
        showingDeleteAlert = true
    }
}
