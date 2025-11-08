import Foundation
import SwiftUI
import PDFKit
import Combine

class ExportManager: ObservableObject {
    static let shared = ExportManager()
    
    @Published var isExporting = false
    @Published var exportError: String?
    
    private init() {}
    
    func exportToJSON(entries: [MoodEntry], timeRange: String) -> URL? {
        let exportData = MoodExportData(
            timeRange: timeRange,
            exportDate: Date(),
            totalEntries: entries.count,
            entries: entries.map { entry in
                MoodEntryExport(
                    id: entry.id,
                    date: entry.date,
                    moodColor: entry.moodColor.rawValue,
                    note: entry.note,
                    createdAt: entry.createdAt,
                    updatedAt: entry.updatedAt,
                    isFavorite: entry.isFavorite
                )
            }
        )
        
        do {
            let jsonData = try JSONEncoder().encode(exportData)
            let fileName = "mood_export_\(DateFormatter.fileName.string(from: Date())).json"
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try jsonData.write(to: url)
            return url
        } catch {
            exportError = "Error exporting to JSON: \(error.localizedDescription)"
            return nil
        }
    }
    
    func exportToPDF(entries: [MoodEntry], timeRange: String, analytics: MoodAnalyticsData) -> URL? {
        let pdfData = generatePDFData(entries: entries, timeRange: timeRange, analytics: analytics)
        
        do {
            let fileName = "mood_analytics_\(DateFormatter.fileName.string(from: Date())).pdf"
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try pdfData.write(to: url)
            return url
        } catch {
            exportError = "Error exporting to PDF: \(error.localizedDescription)"
            return nil
        }
    }
    
    private func generatePDFData(entries: [MoodEntry], timeRange: String, analytics: MoodAnalyticsData) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "MoodFans AuraDay",
            kCGPDFContextAuthor: "MoodFans App",
            kCGPDFContextTitle: "Mood Analytics - \(timeRange)"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            drawTitle("Mood Analytics", timeRange: timeRange, in: pageRect)
            
            let statsY = drawStatistics(analytics: analytics, startY: 120, pageRect: pageRect)
            
            let chartY = drawMoodDistributionChart(analytics: analytics, startY: statsY + 20, pageRect: pageRect)
            
            drawMoodEntries(entries: entries, startY: chartY + 20, pageRect: pageRect)
        }
        
        return data
    }
    
    private func drawTitle(_ title: String, timeRange: String, in pageRect: CGRect) {
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let subtitleFont = UIFont.systemFont(ofSize: 16)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.gray
        ]
        
        let titleSize = title.size(withAttributes: titleAttributes)
        let titleRect = CGRect(x: (pageRect.width - titleSize.width) / 2, y: 40, width: titleSize.width, height: titleSize.height)
        title.draw(in: titleRect, withAttributes: titleAttributes)
        
        let subtitleText = "Period: \(timeRange) • Export Date: \(DateFormatter.exportDate.string(from: Date()))"
        let subtitleSize = subtitleText.size(withAttributes: subtitleAttributes)
        let subtitleRect = CGRect(x: (pageRect.width - subtitleSize.width) / 2, y: titleRect.maxY + 10, width: subtitleSize.width, height: subtitleSize.height)
        subtitleText.draw(in: subtitleRect, withAttributes: subtitleAttributes)
    }
    
    private func drawStatistics(analytics: MoodAnalyticsData, startY: CGFloat, pageRect: CGRect) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        var currentY = startY
        let lineHeight: CGFloat = 20
        
        let sectionTitle = "General Statistics"
        let titleFont = UIFont.boldSystemFont(ofSize: 16)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        sectionTitle.draw(at: CGPoint(x: 50, y: currentY), withAttributes: titleAttributes)
        currentY += 30
        
        let stats = [
            "Total Entries: \(analytics.totalEntries)",
            "Average Mood Score: \(String(format: "%.1f", analytics.averageMood))",
            "Best Day: \(analytics.bestDay)",
            "Tracking Rate: \(analytics.consistencyPercentage)%"
        ]
        
        for stat in stats {
            stat.draw(at: CGPoint(x: 50, y: currentY), withAttributes: attributes)
            currentY += lineHeight
        }
        
        return currentY
    }
    
    private func drawMoodDistributionChart(analytics: MoodAnalyticsData, startY: CGFloat, pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 16)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let sectionTitle = "Mood Distribution"
        sectionTitle.draw(at: CGPoint(x: 50, y: startY), withAttributes: titleAttributes)
        
        var currentY = startY + 30
        let lineHeight: CGFloat = 20
        let font = UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        for (moodColor, count) in analytics.moodDistribution {
            let percentage = analytics.totalEntries > 0 ? (count * 100) / analytics.totalEntries : 0
            let text = "\(moodColor.displayName): \(count) entries (\(percentage)%)"
            text.draw(at: CGPoint(x: 50, y: currentY), withAttributes: attributes)
            currentY += lineHeight
        }
        
        return currentY
    }
    
    private func drawMoodEntries(entries: [MoodEntry], startY: CGFloat, pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 16)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        let sectionTitle = "Mood Entries"
        sectionTitle.draw(at: CGPoint(x: 50, y: startY), withAttributes: titleAttributes)
        
        var currentY = startY + 30
        let lineHeight: CGFloat = 16
        let font = UIFont.systemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let sortedEntries = entries.sorted { $0.date > $1.date }
        let maxEntries = min(50, sortedEntries.count)
        
        for (index, entry) in sortedEntries.prefix(maxEntries).enumerated() {
            if currentY > pageRect.height - 100 {
                break
            }
            
            let dateString = DateFormatter.entryDate.string(from: entry.date)
            let moodString = entry.moodColor.displayName
            let noteString = entry.note.isEmpty ? "No note" : entry.note
            
            let text = "\(dateString) - \(moodString) - \(noteString)"
            text.draw(at: CGPoint(x: 50, y: currentY), withAttributes: attributes)
            currentY += lineHeight
        }
        
        if sortedEntries.count > maxEntries {
            let moreText = "... and \(sortedEntries.count - maxEntries) more entries"
            moreText.draw(at: CGPoint(x: 50, y: currentY), withAttributes: attributes)
            currentY += lineHeight
        }
        
        return currentY
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getJSONData(entries: [MoodEntry], timeRange: String) -> (data: Data, fileName: String)? {
        let exportData = MoodExportData(
            timeRange: timeRange,
            exportDate: Date(),
            totalEntries: entries.count,
            entries: entries.map { entry in
                MoodEntryExport(
                    id: entry.id,
                    date: entry.date,
                    moodColor: entry.moodColor.rawValue,
                    note: entry.note,
                    createdAt: entry.createdAt,
                    updatedAt: entry.updatedAt,
                    isFavorite: entry.isFavorite
                )
            }
        )
        
        do {
            let jsonData = try JSONEncoder().encode(exportData)
            let fileName = "mood_export_\(DateFormatter.fileName.string(from: Date())).json"
            return (jsonData, fileName)
        } catch {
            exportError = "Error encoding JSON: \(error.localizedDescription)"
            print("JSON encoding error: \(error)")
            return nil
        }
    }
    
    func getPDFData(entries: [MoodEntry], timeRange: String, analytics: MoodAnalyticsData) -> (data: Data, fileName: String)? {
        let pdfData = generatePDFData(entries: entries, timeRange: timeRange, analytics: analytics)
        let fileName = "mood_analytics_\(DateFormatter.fileName.string(from: Date())).pdf"
        return (pdfData, fileName)
    }
}

struct MoodExportData: Codable {
    let timeRange: String
    let exportDate: Date
    let totalEntries: Int
    let entries: [MoodEntryExport]
}

struct MoodEntryExport: Codable {
    let id: UUID
    let date: Date
    let moodColor: String
    let note: String
    let createdAt: Date
    let updatedAt: Date
    let isFavorite: Bool
}

struct MoodAnalyticsData {
    let totalEntries: Int
    let averageMood: Double
    let bestDay: String
    let consistencyPercentage: Int
    let moodDistribution: [(MoodColor, Int)]
}

extension DateFormatter {
    static let fileName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()
    
    static let exportDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let entryDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}
