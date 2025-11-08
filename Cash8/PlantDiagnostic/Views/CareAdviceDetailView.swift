import SwiftUI

struct CareAdviceDetailView: View {
    let advice: CareAdvice
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.accentGreen)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        
                        contentView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon(advice.category))
                    .font(.system(size: 30))
                    .foregroundColor(categoryColor(advice.category))
                
                Spacer()
                
                Text(advice.category.rawValue)
                    .font(.caption)
                    .foregroundColor(categoryColor(advice.category))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(categoryColor(advice.category).opacity(0.1))
                    .cornerRadius(12)
            }
            
            Text(advice.title)
                .font(.titleLarge)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.leading)
            
            Text(advice.description)
                .font(.bodyLarge)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(parseContent(advice.content), id: \.id) { section in
                ContentSectionView(section: section)
            }
        }
    }
    
    private func categoryIcon(_ category: CareAdvice.Category) -> String {
        switch category {
        case .watering:
            return "drop.fill"
        case .repotting:
            return "arrow.up.and.down.and.arrow.left.and.right"
        case .fertilizing:
            return "leaf.arrow.circlepath"
        case .lighting:
            return "sun.max.fill"
        case .diseases:
            return "cross.fill"
        case .general:
            return "info.circle.fill"
        }
    }
    
    private func categoryColor(_ category: CareAdvice.Category) -> Color {
        switch category {
        case .watering:
            return .accentBlue
        case .repotting:
            return .accentOrange
        case .fertilizing:
            return .accentGreen
        case .lighting:
            return .yellow
        case .diseases:
            return .red
        case .general:
            return .accentPurple
        }
    }
    
    private func parseContent(_ content: String) -> [ContentSection] {
        let lines = content.components(separatedBy: .newlines)
        var sections: [ContentSection] = []
        var currentSection: ContentSection?
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.isEmpty {
                continue
            }
            
            if trimmedLine.hasPrefix("# ") {
                if let section = currentSection {
                    sections.append(section)
                }
                currentSection = ContentSection(
                    id: UUID().uuidString,
                    title: String(trimmedLine.dropFirst(2)),
                    content: [],
                    type: .heading
                )
            } else if trimmedLine.hasPrefix("## ") {
                if currentSection == nil {
                    currentSection = ContentSection(
                        id: UUID().uuidString,
                        title: "",
                        content: [],
                        type: .text
                    )
                }
                currentSection?.content.append(ContentItem(
                    text: String(trimmedLine.dropFirst(3)),
                    type: .subheading
                ))
            } else if trimmedLine.hasPrefix("### ") {
                if currentSection == nil {
                    currentSection = ContentSection(
                        id: UUID().uuidString,
                        title: "",
                        content: [],
                        type: .text
                    )
                }
                currentSection?.content.append(ContentItem(
                    text: String(trimmedLine.dropFirst(4)),
                    type: .subSubheading
                ))
            } else if trimmedLine.hasPrefix("- ") {
                if currentSection == nil {
                    currentSection = ContentSection(
                        id: UUID().uuidString,
                        title: "",
                        content: [],
                        type: .text
                    )
                }
                currentSection?.content.append(ContentItem(
                    text: String(trimmedLine.dropFirst(2)),
                    type: .bulletPoint
                ))
            } else {
                if currentSection == nil {
                    currentSection = ContentSection(
                        id: UUID().uuidString,
                        title: "",
                        content: [],
                        type: .text
                    )
                }
                currentSection?.content.append(ContentItem(
                    text: trimmedLine,
                    type: .text
                ))
            }
        }
        
        if let section = currentSection {
            sections.append(section)
        }
        
        return sections
    }
}

struct ContentSection {
    let id: String
    let title: String
    var content: [ContentItem]
    let type: SectionType
    
    enum SectionType {
        case heading
        case text
    }
}

struct ContentItem {
    let text: String
    let type: ItemType
    
    enum ItemType {
        case text
        case subheading
        case subSubheading
        case bulletPoint
    }
}

struct ContentSectionView: View {
    let section: ContentSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.titleMedium)
                    .foregroundColor(.primaryText)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(section.content.indices, id: \.self) { index in
                    ContentItemView(item: section.content[index])
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct ContentItemView: View {
    let item: ContentItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if item.type == .bulletPoint {
                Image(systemName: "circle.fill")
                    .font(.system(size: 6))
                    .foregroundColor(.accentGreen)
                    .padding(.top, 6)
            }
            
            Text(item.text)
                .font(fontForType(item.type))
                .foregroundColor(colorForType(item.type))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func fontForType(_ type: ContentItem.ItemType) -> Font {
        switch type {
        case .text:
            return .bodyMedium
        case .subheading:
            return .titleSmall
        case .subSubheading:
            return .bodyLarge
        case .bulletPoint:
            return .bodyMedium
        }
    }
    
    private func colorForType(_ type: ContentItem.ItemType) -> Color {
        switch type {
        case .text, .bulletPoint:
            return .primaryText
        case .subheading:
            return .accentGreen
        case .subSubheading:
            return .accentBlue
        }
    }
}
