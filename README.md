# About:
This is a test to try to build a generic/reusable way to navigate across a SwiftUI app. From anywhere, you can navigate to any other view, including when presenting a view modally, you could reach any other view.

# Issue:
Started the discussion on mastodon: https://mastodon.social/@xmollv/114246128065325460


Only on macOS, and if the NavigationStack has had something pushed into it, the .sheet modifier doesn't work. On iOS/iPadOS works as expected, and on macOS if the NavigationStack only has the initial view, it does work as expected too.

Demo of the issue:


https://github.com/user-attachments/assets/9ed5af66-e080-4665-a2e5-c3a87c9eae38

