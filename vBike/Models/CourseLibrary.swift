import Foundation

struct CourseLibrary {
  let featuredRoutes: [CyclingRoute]

  var defaultRoute: CyclingRoute {
    featuredRoutes[0]
  }

  static let mock = CourseLibrary(featuredRoutes: MockRoutes.routes)
}
