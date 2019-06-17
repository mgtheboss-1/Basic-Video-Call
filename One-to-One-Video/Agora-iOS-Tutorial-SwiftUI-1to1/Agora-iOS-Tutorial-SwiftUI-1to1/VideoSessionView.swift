//
//  VideoSessionView.swift
//  Agora-iOS-Tutorial-SwiftUI-1to1
//
//  Created by GongYuhua on 2019/6/17.
//  Copyright © 2019 Agora. All rights reserved.
//

import SwiftUI

struct VideoSessionView : View {
    
    let videoCanvas = VideoCanvas()
    
    @State var muted: Bool = false
    
    var body: some View {
        ZStack {
            if muted {
                Color.gray
                Image("videoMutedIndicator")
                    .resizable()
                    .relativeSize(width: 0.6, height: 0.6)
                    .aspectRatio(307/258, contentMode: .fit)
            } else {
                videoCanvas
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct VideoSessionView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            VideoSessionView(muted: false)
            VideoSessionView(muted: true)
        }
    }
}
#endif
