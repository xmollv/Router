import SwiftUI

struct ContentView: View {
  @Environment(Router.self) private var router
  
  let modalLevel: Int
  let pathLevel: Int
  
  var body: some View {
    VStack {
      Button {
        router.push(.detail(modalLevel: router.modalLevel, pathLevel: router.pathLevel + 1))
      } label: { Text("Push") }
      
      Button {
        router.pop()
      } label: { Text("Pop (one)") }
      
      Button {
        router.popToRoot()
      } label: { Text("Pop (root)") }
      
      Divider()
      
      Button {
        router.showModal(.detail(modalLevel: router.modalLevel + 1, pathLevel: 0))
      } label: { Text("Show (new)") }
      
      Button {
        router.dismissModal()
      } label: { Text("Dismiss (current)") }
      
      Button {
        router.dismissAllModals()
      } label: { Text("Dismiss (all)") }
    }
    .padding()
    .navigationTitle("[Modal: \(modalLevel), Path: \(pathLevel)]")
#if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
#endif
  }
}

// MARK: RouterView
struct RouterView: View {
  
  private let initialRoute: Route
  @State private var router: Router
  
  init(initialRoute: Route, parentRouter: Router?) {
    self.initialRoute = initialRoute
    self._router = State(initialValue: Router(parent: parentRouter))
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      initialRoute
        .environment(router)
        .navigationDestination(for: Route.self) {
          $0.environment(router).sheet(item: $router.sheet) {
            RouterView(initialRoute: $0, parentRouter: router)
          }
        }
        .sheet(item: $router.sheet) {
          RouterView(initialRoute: $0, parentRouter: router)
        }
    }
  }
}

// MARK: Route
enum Route: View, Hashable, Identifiable {
  case detail(modalLevel: Int, pathLevel: Int)
  
  var id: Self { self }
  
  var body: some View {
    switch self {
    case .detail(let modalLevel, let pathLevel):
      ContentView(modalLevel: modalLevel, pathLevel: pathLevel)
    }
  }
}

// MARK: Router
@Observable
final class Router {
  
  var parent: Router?
  var path: [Route]
  var sheet: Route?
  
  var pathLevel: Int {
    path.count
  }
  
  var modalLevel: Int {
    var count = 0
    var topmostRouter = self
    while let parent = topmostRouter.parent {
      topmostRouter = parent
      count += 1
    }
    return count
  }
  
  init(parent: Router? = nil, path: [Route] = [], sheet: Route? = nil) {
    self.parent = parent
    self.path = path
    self.sheet = sheet
  }
  
  func push(_ route: Route) {
    path.append(route)
  }
  
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }
  
  func popToRoot() {
    path.removeLast(path.count)
  }
  
  func showModal(_ route: Route) {
    sheet = route
  }
  
  func dismissModal() {
    parent?.sheet = nil
  }
  
  func dismissAllModals() {
    var topmostRouter = self
    while let parent = topmostRouter.parent {
      topmostRouter = parent
    }
    topmostRouter.sheet = nil
  }
}

