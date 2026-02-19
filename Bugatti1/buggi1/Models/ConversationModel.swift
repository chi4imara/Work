import Foundation

struct Conversation: Identifiable, Codable {
    let id: UUID
    var personName: String
    var topic: String
    var outcome: String
    var createdAt: Date
    var updatedAt: Date
    
    init(personName: String, topic: String, outcome: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.personName = personName
        self.topic = topic
        self.outcome = outcome
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }
    
    mutating func update(personName: String, topic: String, outcome: String) {
        self.personName = personName
        self.topic = topic
        self.outcome = outcome
        self.updatedAt = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

extension Conversation {
    static var sampleData: [Conversation] {
        let calendar = Calendar.current
        let now = Date()
        func day(_ offset: Int) -> Date {
            calendar.date(byAdding: .day, value: offset, to: now) ?? now
        }
        return [
            Conversation(personName: "John Smith", topic: "Project planning meeting", outcome: "Agreed on timeline and deliverables for Q2", createdAt: now),
            Conversation(personName: "Sarah Johnson", topic: "Budget discussion", outcome: "Need to reduce expenses by 15% next quarter", createdAt: now),
            Conversation(personName: "Mike Wilson", topic: "Technical review", outcome: "Architecture approved, starting implementation next week", createdAt: now),
            Conversation(personName: "Emma Davis", topic: "Marketing strategy", outcome: "Launch campaign scheduled for next month", createdAt: now),
            Conversation(personName: "John Smith", topic: "Follow-up on Q2 goals", outcome: "Confirmed priorities and key metrics", createdAt: now),
            Conversation(personName: "David Lee", topic: "Sprint retrospective", outcome: "Process improvements for next sprint agreed", createdAt: day(-1)),
            Conversation(personName: "Rachel Green", topic: "Partnership proposal", outcome: "NDA signed, next meeting in two weeks", createdAt: day(-1)),
            Conversation(personName: "Lisa Chen", topic: "Team sync", outcome: "Stand-up format updated, async updates in Slack", createdAt: day(-1)),
            Conversation(personName: "Alex Brown", topic: "Client feedback", outcome: "Positive response, contract renewal likely", createdAt: day(-1)),
            Conversation(personName: "Sarah Johnson", topic: "Vendor negotiation", outcome: "Discount agreed for annual contract", createdAt: day(-1)),
            Conversation(personName: "James Wilson", topic: "Resource allocation", outcome: "Two developers assigned to mobile project", createdAt: day(-2)),
            Conversation(personName: "Maria Garcia", topic: "Compliance review", outcome: "All documents approved for audit", createdAt: day(-2)),
            Conversation(personName: "John Smith", topic: "One-on-one check-in", outcome: "Career goals and training plan discussed", createdAt: day(-2)),
            Conversation(personName: "Tom Harris", topic: "Infrastructure upgrade", outcome: "Migration window set for next weekend", createdAt: day(-2)),
            Conversation(personName: "Emma Davis", topic: "Brand guidelines", outcome: "New logo usage approved for social", createdAt: day(-3)),
            Conversation(personName: "Lisa Chen", topic: "API integration", outcome: "Endpoints documented, sandbox ready", createdAt: day(-3)),
            Conversation(personName: "Chris Taylor", topic: "Security audit", outcome: "No critical issues, recommendations shared", createdAt: day(-3)),
            Conversation(personName: "Rachel Green", topic: "Contract renewal", outcome: "Terms extended for 12 months", createdAt: day(-3)),
            Conversation(personName: "Alex Brown", topic: "Feature request", outcome: "Export to PDF added to roadmap", createdAt: day(-4)),
            Conversation(personName: "David Lee", topic: "Code review process", outcome: "New checklist and SLA agreed", createdAt: day(-4)),
            Conversation(personName: "Sarah Johnson", topic: "Quarterly review", outcome: "Targets met, bonus criteria confirmed", createdAt: day(-4)),
            Conversation(personName: "Mike Wilson", topic: "Architecture decision", outcome: "Microservices approach approved", createdAt: day(-5)),
            Conversation(personName: "James Wilson", topic: "Hiring pipeline", outcome: "Two candidates to final round", createdAt: day(-5)),
            Conversation(personName: "Maria Garcia", topic: "Data privacy", outcome: "GDPR checklist completed", createdAt: day(-5)),
            Conversation(personName: "John Smith", topic: "Stakeholder update", outcome: "Demo scheduled for next Friday", createdAt: day(-5)),
            Conversation(personName: "Tom Harris", topic: "CI/CD pipeline", outcome: "Automated tests running on every PR", createdAt: day(-6)),
            Conversation(personName: "Emma Davis", topic: "Content calendar", outcome: "Q2 themes and deadlines set", createdAt: day(-6)),
            Conversation(personName: "Lisa Chen", topic: "Onboarding feedback", outcome: "New hire program improvements listed", createdAt: day(-6)),
            Conversation(personName: "Chris Taylor", topic: "Incident post-mortem", outcome: "Root cause fixed, monitoring added", createdAt: day(-7)),
            Conversation(personName: "Rachel Green", topic: "Pricing discussion", outcome: "Tier structure to be revised", createdAt: day(-7)),
            Conversation(personName: "Alex Brown", topic: "Support metrics", outcome: "Response time target lowered to 4h", createdAt: day(-7)),
            Conversation(personName: "David Lee", topic: "Training budget", outcome: "Conference allowance approved", createdAt: day(-10)),
            Conversation(personName: "Sarah Johnson", topic: "Team offsite", outcome: "Dates and venue booked", createdAt: day(-12)),
            Conversation(personName: "James Wilson", topic: "Performance review", outcome: "Cycle dates and criteria communicated", createdAt: day(-14)),
            Conversation(personName: "Maria Garcia", topic: "Insurance renewal", outcome: "Policy updated, premiums unchanged", createdAt: day(-18)),
            Conversation(personName: "John Smith", topic: "Annual planning kickoff", outcome: "OKRs draft by end of month", createdAt: day(-21)),
            Conversation(personName: "Emma Davis", topic: "Competitor analysis", outcome: "Report shared with leadership", createdAt: day(-25)),
            Conversation(personName: "Mike Wilson", topic: "Tech debt prioritization", outcome: "Backlog refined, top 5 items selected", createdAt: day(-28)),
        ]
    }
}
