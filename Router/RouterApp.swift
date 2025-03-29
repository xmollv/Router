import SwiftUI

@main
struct RouterApp: App {
  
  @State private var sidebarSelection: String?
  
  var body: some Scene {
    WindowGroup {
      NavigationSplitView {
        List(selection: $sidebarSelection) {
          Text("Option 1").tag("Option 1")
        }
      } detail: {
        if let _ = sidebarSelection {
          RouterView(initialRoute: .detail(modalLevel: 0, pathLevel: 0), parentRouter: nil)
        } else {
          ContentUnavailableView("No Selection", systemImage: "folder.badge.questionmark")
        }
      }
    }
  }
}
