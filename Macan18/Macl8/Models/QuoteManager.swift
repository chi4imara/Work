import Foundation
import SwiftUI
import Combine

class QuoteManager: ObservableObject {
    static let shared = QuoteManager()
    
    @Published var quotes: [Quote] = []
    @Published var currentFilter = QuoteFilter()
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let quotesKey = "SavedQuotes"
    
    private init() {
        loadQuotes()
        
        if quotes.isEmpty {
        }
    }
    
    var filteredQuotes: [Quote] {
        var result = quotes
        
        if !searchText.isEmpty {
            result = result.filter { quote in
                let searchableText = "\(quote.text) \(quote.author) \(quote.source)".lowercased()
                return searchableText.contains(searchText.lowercased())
            }
        }
        
        if !currentFilter.isEmpty {
            result = result.filter { currentFilter.matches($0) }
        }
        
        return result.sorted { $0.dateModified > $1.dateModified }
    }
    
    var quotesByTheme: [QuoteTheme: [Quote]] {
        Dictionary(grouping: quotes) { $0.theme }
    }
    
    var themeStats: [(theme: QuoteTheme, count: Int)] {
        QuoteTheme.allCases.map { theme in
            (theme: theme, count: quotes.filter { $0.theme == theme }.count)
        }.filter { $0.count > 0 }
    }
    
    func addQuote(_ quote: Quote) {
        quotes.append(quote)
        saveQuotes()
    }
    
    func updateQuote(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            var updatedQuote = quote
            updatedQuote.updateModifiedDate()
            quotes[index] = updatedQuote
            saveQuotes()
        }
    }
    
    func deleteQuote(_ quote: Quote) {
        quotes.removeAll { $0.id == quote.id }
        saveQuotes()
    }
    
    func deleteQuote(at indexSet: IndexSet) {
        let quotesToDelete = indexSet.map { filteredQuotes[$0] }
        for quote in quotesToDelete {
            deleteQuote(quote)
        }
    }
    
    func applyFilter(_ filter: QuoteFilter) {
        currentFilter = filter
    }
    
    func clearFilter() {
        currentFilter = QuoteFilter()
        searchText = ""
    }
    
    func applyThemeFilter(_ theme: QuoteTheme) {
        currentFilter = QuoteFilter()
        currentFilter.themes = [theme]
    }
    
    private func saveQuotes() {
        if let encoded = try? JSONEncoder().encode(quotes) {
            userDefaults.set(encoded, forKey: quotesKey)
        }
    }
    
    private func loadQuotes() {
        if let data = userDefaults.data(forKey: quotesKey),
           let decodedQuotes = try? JSONDecoder().decode([Quote].self, from: data) {
            quotes = decodedQuotes
        }
    }
    
    func loadSampleData() {
        let sampleQuotes = [
            Quote(
                text: "Fashion fades, style is eternal.",
                author: "Yves Saint Laurent",
                source: "Interview, 1978",
                theme: .style,
                comment: "Perfect for self-expression section"
            ),
            Quote(
                text: "Style is a way to say who you are without speaking.",
                author: "Rachel Zoe",
                source: "",
                theme: .style
            ),
            Quote(
                text: "Elegance is not standing out, but being remembered.",
                author: "Giorgio Armani",
                source: "",
                theme: .style
            ),
            Quote(
                text: "Simplicity is the ultimate sophistication.",
                author: "Leonardo da Vinci",
                source: "",
                theme: .style
            ),
            Quote(
                text: "Style is knowing who you are, what you want to say, and not giving a damn.",
                author: "Gore Vidal",
                source: "",
                theme: .style
            ),
            Quote(
                text: "Fashion is what you adopt when you don't know who you are.",
                author: "Quentin Crisp",
                source: "",
                theme: .style
            ),
            Quote(
                text: "The best color in the whole world is the one that looks good on you.",
                author: "Coco Chanel",
                source: "",
                theme: .style
            ),
            Quote(
                text: "The future belongs to those who believe in the beauty of their dreams.",
                author: "Eleanor Roosevelt",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "Dream big and dare to fail.",
                author: "Norman Vaughan",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "All our dreams can come true, if we have the courage to pursue them.",
                author: "Walt Disney",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "Dreams don't work unless you do.",
                author: "John C. Maxwell",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "The only thing that stands between you and your dream is the will to try and the belief that it is actually possible.",
                author: "Joel Brown",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "If you can dream it, you can do it.",
                author: "Walt Disney",
                source: "",
                theme: .dreams
            ),
            Quote(
                text: "A dream is a wish your heart makes.",
                author: "Cinderella",
                source: "Disney's Cinderella",
                theme: .dreams
            ),
            Quote(
                text: "Beauty begins the moment you decide to be yourself.",
                author: "Coco Chanel",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "Beauty is not in the face; beauty is a light in the heart.",
                author: "Kahlil Gibran",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "The most beautiful thing you can wear is confidence.",
                author: "Blake Lively",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "Beauty is power; a smile is its sword.",
                author: "John Ray",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "True beauty is not related to what color your hair is or what color your eyes are. True beauty is about who you are as a human being, your principles, your moral compass.",
                author: "Ellen DeGeneres",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "Beauty is how you feel inside, and it reflects in your eyes. It is not something physical.",
                author: "Sophia Loren",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "Outer beauty attracts, but inner beauty captivates.",
                author: "Kate Angell",
                source: "",
                theme: .beauty
            ),
            Quote(
                text: "Life is what happens to you while you're busy making other plans.",
                author: "John Lennon",
                source: "",
                theme: .life
            ),
            Quote(
                text: "The purpose of our lives is to be happy.",
                author: "Dalai Lama",
                source: "",
                theme: .life
            ),
            Quote(
                text: "Life is either a daring adventure or nothing at all.",
                author: "Helen Keller",
                source: "",
                theme: .life
            ),
            Quote(
                text: "In the end, it's not the years in your life that count. It's the life in your years.",
                author: "Abraham Lincoln",
                source: "",
                theme: .life
            ),
            Quote(
                text: "Life is really simple, but we insist on making it complicated.",
                author: "Confucius",
                source: "",
                theme: .life
            ),
            Quote(
                text: "The biggest adventure you can take is to live the life of your dreams.",
                author: "Oprah Winfrey",
                source: "",
                theme: .life
            ),
            Quote(
                text: "Life is 10% what happens to you and 90% how you react to it.",
                author: "Charles R. Swindoll",
                source: "",
                theme: .life
            ),
            Quote(
                text: "Life is too important to be taken seriously.",
                author: "Oscar Wilde",
                source: "",
                theme: .life
            ),
            Quote(
                text: "The good life is one inspired by love and guided by knowledge.",
                author: "Bertrand Russell",
                source: "",
                theme: .life
            )
        ]
        
        for quote in sampleQuotes {
            addQuote(quote)
        }
    }
}
