# SwiftUIPullToRefresh
A simple way to add Pull-to-Refresh support for all versions of SwiftUI.

Usage:

Add the PullToRefreshView to your project, then use it put it at the top of any scrollview and utilize it via a coordinated namespace:

EXAMPLE:

          ScrollView {
              PullToRefreshHack(coordinateSpaceName: "p2r", onRefresh: {
                //your refresh function/code goes here
              })
          }.coordinateSpace(name: "p2r")
