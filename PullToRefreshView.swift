import SwiftUI

struct PullToRefreshHack: View {
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    @State var stillHolding:Bool = false
    @State var pullAndHoldText = "pull down to refresh"
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) { //once they pull down 50px basically
                Rectangle().frame(width: 1, height: 1).foregroundColor(.clear)
                    .onAppear {
                        pullAndHoldText = "keep holding..."
                        stillHolding = true;
                        DispatchQueue.main.asyncAfter(deadline:  .now() + .milliseconds(750), execute: {
                            //start a timer, when timer completes, run this:
                            if stillHolding {
                                let generator = UINotificationFeedbackGenerator()
                                generator.prepare()
                                generator.notificationOccurred(.success)
                                withAnimation {
                                    needRefresh = true
                                }
                            }
                        })
                    }
                    .onDisappear {
                        stillHolding = false
                        pullAndHoldText = "pull down to refresh"
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) { //once they release it back up
                Rectangle().frame(width: 1, height: 1).foregroundColor(.clear)
                    .onAppear {
                        if needRefresh {
                            withAnimation {
                                needRefresh = false
                            }
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    SpinnerVIewSUI(spinning: true, bgOpacity: 0.0, message: "", style: .medium, bgColor: .clear)
                } else {
                    VStack{
                        Image(systemName: "arrow.down")
                        .font(.system(size: 20.0))
                        Text(pullAndHoldText).font(.custom("HelveticaNeue", size: 12))
                    }
                }
                Spacer()
            }
        }.padding(.top, -60)
    }
}

struct PullToRefreshHack_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            PullToRefreshHack(coordinateSpaceName: "bob", onRefresh: {})
            
        }.coordinateSpace(name: "bob")
    }
}
