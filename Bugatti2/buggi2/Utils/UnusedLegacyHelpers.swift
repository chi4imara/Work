import Foundation
import SwiftUI

enum LegacyExportFormat {
    case csv
    case json
    case xml
    case binary
}

struct LegacyReportMetadata {
    var reportId: String
    var generatedAt: Date
    var version: Int
    var checksum: UInt64
}

class LegacyCacheManager {
    private var storage: [String: Data] = [:]

    func store(key: String, value: Data) {
        storage[key] = value
    }

    func retrieve(key: String) -> Data? {
        storage[key]
    }

    func clearAll() {
        storage.removeAll()
    }

    func estimatedSizeInBytes() -> Int {
        storage.values.reduce(0) { $0 + $1.count }
    }
}

struct LegacyCoordinate3D {
    let x: Double
    let y: Double
    let z: Double

    func magnitude() -> Double {
        sqrt(x * x + y * y + z * z)
    }

    func normalized() -> LegacyCoordinate3D {
        let m = magnitude()
        guard m > 0 else { return self }
        return LegacyCoordinate3D(x: x / m, y: y / m, z: z / m)
    }
}

enum LegacyThemeVariant {
    case classic
    case minimal
    case highContrast
    case sepia
}

struct LegacyPaginationCursor {
    var offset: Int
    var limit: Int
    var nextToken: String?
}

func legacyComputeHash(_ input: String) -> Int {
    var hash = 0
    for char in input.unicodeScalars {
        hash = 31 &* hash &+ Int(char.value)
    }
    return hash
}

func legacyFormatCurrency(amount: Double, locale: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: locale)
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
}

func legacyDelay(seconds: Double) async {
    try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}

func legacyRandomId() -> String {
    UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
}

struct LegacyPlaceholderCardView: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct LegacyDebugOverlayView: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.system(size: 10, design: .monospaced))
            .foregroundColor(.red)
            .padding(4)
    }
}

struct LegacyEmptyStateBanner: View {
    var iconName: String
    var message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
            Text(message)
        }
        .padding()
    }
}
