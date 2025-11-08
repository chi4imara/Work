import Foundation
import SwiftUI
import Combine

class MedicationViewModel: ObservableObject {
    static let shared = MedicationViewModel()
    
    @Published var medications: [Medication] = []
    @Published var doses: [Dose] = []
    @Published var selectedDate = Date()
    @Published var calendarPeriod: CalendarPeriod = .month
    @Published var isLoading = false
    
    private let dataManager = DataManager.shared
    
    private init() {
        loadData()
    }
    
    func loadData() {
        medications = dataManager.loadMedications()
        doses = dataManager.loadDoses()
    }
    
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        generateDoses(for: medication)
        dataManager.saveMedications(medications)
        dataManager.saveDoses(doses)
    }
    
    func updateMedication(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index] = medication
            regenerateFutureDoses(for: medication)
            dataManager.saveMedications(medications)
            dataManager.saveDoses(doses)
        }
    }
    
    func deleteMedication(_ medication: Medication) {
        medications.removeAll { $0.id == medication.id }
        doses.removeAll { $0.medicationId == medication.id }
        dataManager.saveMedications(medications)
        dataManager.saveDoses(doses)
    }
    
    func updateDoseStatus(_ dose: Dose, status: Dose.DoseStatus) {
        if let index = doses.firstIndex(where: { $0.id == dose.id }) {
            doses[index].status = status
            dataManager.saveDoses(doses)
        }
    }
    
    func markAllDosesForDay(_ date: Date, status: Dose.DoseStatus) {
        let calendar = Calendar.current
        for i in 0..<doses.count {
            if calendar.isDate(doses[i].date, inSameDayAs: date) {
                doses[i].status = status
            }
        }
        dataManager.saveDoses(doses)
    }
    
    func resetDosesForDay(_ date: Date) {
        markAllDosesForDay(date, status: .notMarked)
    }
    
    func getDayStatus(for date: Date) -> DayStatus {
        let dayDoses = getDosesForDay(date)
        
        if dayDoses.isEmpty {
            return .noDoses
        }
        
        let takenCount = dayDoses.filter { $0.status == .taken }.count
        let missedCount = dayDoses.filter { $0.status == .missed }.count
        let unmarkedCount = dayDoses.filter { $0.status == .notMarked }.count
        
        if missedCount > 0 {
            return .hasMissed
        } else if unmarkedCount > 0 {
            return .hasUnmarked
        } else if takenCount == dayDoses.count {
            return .allTaken
        } else {
            return .noDoses
        }
    }
    
    func getDosesForDay(_ date: Date) -> [Dose] {
        let calendar = Calendar.current
        return doses.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.time < $1.time }
    }
    
    func getTodaySummary() -> (scheduled: Int, taken: Int, missed: Int, unmarked: Int) {
        let todayDoses = getDosesForDay(Date())
        let taken = todayDoses.filter { $0.status == .taken }.count
        let missed = todayDoses.filter { $0.status == .missed }.count
        let unmarked = todayDoses.filter { $0.status == .notMarked }.count
        
        return (scheduled: todayDoses.count, taken: taken, missed: missed, unmarked: unmarked)
    }
    
    func getUpcomingDoses() -> [Dose] {
        let now = Date()
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        
        return doses.filter { dose in
            let doseDateTime = combineDateAndTime(date: dose.date, time: dose.time)
            return doseDateTime >= now && doseDateTime <= endDate
        }.sorted { dose1, dose2 in
            let date1 = combineDateAndTime(date: dose1.date, time: dose1.time)
            let date2 = combineDateAndTime(date: dose2.date, time: dose2.time)
            return date1 < date2
        }
    }
    
    func getAnalyticsData(for period: Int) -> AnalyticsData {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -period, to: endDate) ?? endDate
        
        let periodDoses = doses.filter { dose in
            dose.date >= startDate && dose.date <= endDate
        }
        
        let taken = periodDoses.filter { $0.status == .taken }.count
        let missed = periodDoses.filter { $0.status == .missed }.count
        let unmarked = periodDoses.filter { $0.status == .notMarked }.count
        
        return AnalyticsData(
            totalDoses: periodDoses.count,
            takenDoses: taken,
            missedDoses: missed,
            unmarkedDoses: unmarked
        )
    }
    
    func getMedicationAnalytics(for period: Int) -> [(medication: Medication, taken: Int, total: Int, percentage: Int)] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -period, to: endDate) ?? endDate
        
        return medications.compactMap { medication in
            let medicationDoses = doses.filter { dose in
                dose.medicationId == medication.id &&
                dose.date >= startDate &&
                dose.date <= endDate
            }
            
            let taken = medicationDoses.filter { $0.status == .taken }.count
            let total = medicationDoses.count
            let percentage = total > 0 ? Int((Double(taken) / Double(total)) * 100) : 0
            
            return (medication: medication, taken: taken, total: total, percentage: percentage)
        }.sorted { $0.percentage > $1.percentage }
    }
    
    private func generateDoses(for medication: Medication) {
        let calendar = Calendar.current
        let endDate = medication.endDate ?? calendar.date(byAdding: .day, value: 30, to: medication.startDate) ?? medication.startDate
        
        var currentDate = medication.startDate
        
        while currentDate <= endDate {
            let weekday = calendar.component(.weekday, from: currentDate)
            let medicationWeekday = weekdayFromCalendarWeekday(weekday)
            
            if medication.days.contains(medicationWeekday) {
                for time in medication.times {
                    let dose = Dose(
                        medicationId: medication.id,
                        date: currentDate,
                        time: time,
                        status: .notMarked
                    )
                    doses.append(dose)
                }
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
    }
    
    private func regenerateFutureDoses(for medication: Medication) {
        let today = Date()
        
        doses.removeAll { dose in
            dose.medicationId == medication.id && dose.date > today
        }
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let endDate = medication.endDate ?? calendar.date(byAdding: .day, value: 30, to: startDate) ?? startDate
        
        var currentDate = startDate
        
        while currentDate <= endDate {
            let weekday = calendar.component(.weekday, from: currentDate)
            let medicationWeekday = weekdayFromCalendarWeekday(weekday)
            
            if medication.days.contains(medicationWeekday) {
                for time in medication.times {
                    let dose = Dose(
                        medicationId: medication.id,
                        date: currentDate,
                        time: time,
                        status: .notMarked
                    )
                    doses.append(dose)
                }
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
    }
    
    private func weekdayFromCalendarWeekday(_ weekday: Int) -> Medication.WeekDay {
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
    
    private func combineDateAndTime(date: Date, time: String) -> Date {
        let calendar = Calendar.current
        let timeComponents = time.split(separator: ":").compactMap { Int($0) }
        
        guard timeComponents.count == 2 else { return date }
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = timeComponents[0]
        components.minute = timeComponents[1]
        
        return calendar.date(from: components) ?? date
    }
}
