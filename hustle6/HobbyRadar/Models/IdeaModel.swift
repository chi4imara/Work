import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let isSystem: Bool
    
    static let systemCategories: [Category] = [
        Category(name: "Entertainment", isSystem: true),
        Category(name: "Sports", isSystem: true),
        Category(name: "Creative", isSystem: true),
        Category(name: "Relaxation", isSystem: true),
        Category(name: "Travel", isSystem: true),
        Category(name: "Social", isSystem: true),
        Category(name: "Learning", isSystem: true),
        Category(name: "Outdoor", isSystem: true)
    ]
}

struct Idea: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: Category
    let description: String?
    let source: String?
    let dateAdded: Date
    let isSystem: Bool
    
    init(title: String, category: Category, description: String? = nil, source: String? = nil, isSystem: Bool = false) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.description = description
        self.source = source
        self.dateAdded = Date()
        self.isSystem = isSystem
    }
    
    init(id: UUID, title: String, category: Category, description: String? = nil, source: String? = nil, dateAdded: Date, isSystem: Bool) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.source = source
        self.dateAdded = dateAdded
        self.isSystem = isSystem
    }
}

struct HistoryEntry: Identifiable, Codable {
    let id = UUID()
    let ideaId: UUID
    let timestamp: Date
    
    init(ideaId: UUID) {
        self.ideaId = ideaId
        self.timestamp = Date()
    }
}

extension Idea {
    static let systemIdeas: [Idea] = [
        Idea(title: "Watch a classic movie", category: Category.systemCategories[0], description: "Pick a movie from the AFI's top 100 list", isSystem: true),
        Idea(title: "Start a new TV series", category: Category.systemCategories[0], description: "Browse trending shows on streaming platforms", isSystem: true),
        Idea(title: "Play a board game", category: Category.systemCategories[0], description: "Dust off that game you haven't played in a while", isSystem: true),
        Idea(title: "Listen to a new podcast", category: Category.systemCategories[0], description: "Explore a topic you've never heard about", isSystem: true),
        Idea(title: "Have a movie marathon", category: Category.systemCategories[0], description: "Pick a theme or franchise and binge watch", isSystem: true),
        
        Idea(title: "Go for a run", category: Category.systemCategories[1], description: "Start with a 20-minute jog around your neighborhood", isSystem: true),
        Idea(title: "Try yoga", category: Category.systemCategories[1], description: "Follow a beginner-friendly YouTube tutorial", isSystem: true),
        Idea(title: "Play basketball", category: Category.systemCategories[1], description: "Find a local court and shoot some hoops", isSystem: true),
        Idea(title: "Go swimming", category: Category.systemCategories[1], description: "Visit your local pool or find a natural swimming spot", isSystem: true),
        Idea(title: "Try rock climbing", category: Category.systemCategories[1], description: "Visit an indoor climbing gym for beginners", isSystem: true),
        
        Idea(title: "Start drawing", category: Category.systemCategories[2], description: "Grab a pencil and sketch something you see", isSystem: true),
        Idea(title: "Write in a journal", category: Category.systemCategories[2], description: "Reflect on your day or write about your dreams", isSystem: true),
        Idea(title: "Learn to cook something new", category: Category.systemCategories[2], description: "Try a recipe from a different cuisine", isSystem: true),
        Idea(title: "Take photos", category: Category.systemCategories[2], description: "Go on a photo walk and capture interesting moments", isSystem: true),
        Idea(title: "Write a short story", category: Category.systemCategories[2], description: "Create a 500-word story about anything", isSystem: true),
        
        Idea(title: "Take a bubble bath", category: Category.systemCategories[3], description: "Add some essential oils and relax", isSystem: true),
        Idea(title: "Meditate", category: Category.systemCategories[3], description: "Try a 10-minute guided meditation", isSystem: true),
        Idea(title: "Read a book", category: Category.systemCategories[3], description: "Pick up that book you've been meaning to read", isSystem: true),
        Idea(title: "Listen to calming music", category: Category.systemCategories[3], description: "Create a playlist of your favorite relaxing songs", isSystem: true),
        Idea(title: "Do some gardening", category: Category.systemCategories[3], description: "Water your plants or start a small herb garden", isSystem: true),
        
        Idea(title: "Plan a weekend trip", category: Category.systemCategories[4], description: "Research nearby destinations you haven't visited", isSystem: true),
        Idea(title: "Explore your city", category: Category.systemCategories[4], description: "Visit a neighborhood you've never been to", isSystem: true),
        Idea(title: "Take a scenic drive", category: Category.systemCategories[4], description: "Find a beautiful route and enjoy the journey", isSystem: true),
        Idea(title: "Visit a museum", category: Category.systemCategories[4], description: "Learn something new at a local museum", isSystem: true),
        Idea(title: "Go on a nature hike", category: Category.systemCategories[4], description: "Find a trail and enjoy the outdoors", isSystem: true),
        
        Idea(title: "Call an old friend", category: Category.systemCategories[5], description: "Reconnect with someone you haven't talked to in a while", isSystem: true),
        Idea(title: "Host a dinner party", category: Category.systemCategories[5], description: "Invite friends over for a home-cooked meal", isSystem: true),
        Idea(title: "Join a local club", category: Category.systemCategories[5], description: "Find a group that shares your interests", isSystem: true),
        Idea(title: "Volunteer", category: Category.systemCategories[5], description: "Help out at a local charity or community center", isSystem: true),
        Idea(title: "Organize a game night", category: Category.systemCategories[5], description: "Gather friends for board games or video games", isSystem: true),
        
        Idea(title: "Learn a new language", category: Category.systemCategories[6], description: "Start with basic phrases using a language app", isSystem: true),
        Idea(title: "Take an online course", category: Category.systemCategories[6], description: "Pick a skill you've always wanted to develop", isSystem: true),
        Idea(title: "Watch educational videos", category: Category.systemCategories[6], description: "Explore TED talks or documentary films", isSystem: true),
        Idea(title: "Practice a musical instrument", category: Category.systemCategories[6], description: "Dust off that guitar or try learning piano", isSystem: true),
        Idea(title: "Learn to code", category: Category.systemCategories[6], description: "Start with basic programming tutorials", isSystem: true),
        
        Idea(title: "Have a picnic", category: Category.systemCategories[7], description: "Pack some food and eat outdoors", isSystem: true),
        Idea(title: "Go stargazing", category: Category.systemCategories[7], description: "Find a dark spot and look up at the night sky", isSystem: true),
        Idea(title: "Start a campfire", category: Category.systemCategories[7], description: "Gather around a fire and tell stories", isSystem: true),
        Idea(title: "Go fishing", category: Category.systemCategories[7], description: "Find a peaceful spot by the water", isSystem: true),
        Idea(title: "Collect natural items", category: Category.systemCategories[7], description: "Gather interesting rocks, leaves, or shells", isSystem: true)
    ]
}
