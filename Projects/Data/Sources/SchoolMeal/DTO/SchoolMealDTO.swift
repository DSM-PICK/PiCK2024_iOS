import Foundation

import Domain

struct SchoolMealDTO: Decodable {
    public let date: String
    public let meals: [String : [String]]
    
}

extension SchoolMealDTO {
    func toDomain() -> SchoolMealEntity {
        return .init(
//            date: date,
            meals: meals
        )
    }
    
}

struct SchoolMealDTOElement: Decodable {
   public let breakfast: [String]
   public let lunch: [String]
   public let dinner: [String]
    
}

extension SchoolMealDTOElement {
    func toDomain() -> SchoolMealEntityElement {
        return .init(
            breakfast: breakfast,
            lunch: lunch,
            dinner: dinner
        )
    }
    
}
