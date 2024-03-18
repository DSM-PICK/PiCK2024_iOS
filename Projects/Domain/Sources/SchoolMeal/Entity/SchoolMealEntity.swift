import Foundation

public struct SchoolMealEntity {
//    public let date: String
    public let meals: [String : [String]]
    
    public init(
        meals: [String : [String]]
    ) {
        self.meals = meals
    }
    
}

public struct SchoolMealEntityElement {
    public let breakfast: [String]
    public let lunch: [String]
    public let dinner: [String]

    public init(
        breakfast: [String],
        lunch: [String],
        dinner: [String]
    ) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
    
}
