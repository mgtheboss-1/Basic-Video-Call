//
//  ContentView.swift
//  Agora-iOS-Tutorial-SwiftUI-1to1
//
//  Created by GongYuhua on 2019/6/17.
//  Copyright © 2019 Agora. All rights reserved.
//

import SwiftUI
import AgoraRtcEngineKit

struct ContentView : View {
    
    @State var isInSession = false
    @State var isLocalVideoMuted = false
    @State var isLocalAudioMuted = false
    @State var isRemoteOnline = false
//    @State var isRemoteVideoMuted = false
    
    let localSessionView = VideoSessionView(muted: false)
    let remoteSessionView = VideoSessionView(muted: false)
    
    let engine: VideoEngine = VideoEngine()
    
    var body: some View {
        ZStack {
            remoteSessionView
            ZStack(alignment: .topTrailing) {
                localSessionView.relativeSize(width: 0.25, height: 0.25)
                Spacer()
            }.padding()
            if isInSession {
                VStack {
                    Spacer()
                    HStack {
                        ButtonView(imageName: isLocalVideoMuted ? "videoMuteButtonSelected" : "videoMuteButton", action: muteLocalVideo)
                        ButtonView(imageName: isLocalAudioMuted ? "muteButtonSelected" : "muteButton", action: muteLocalAudio)
                        ButtonView(imageName: "switchCameraButton", action: switchCamera)
                        ButtonView(imageName: "hangUpButton", action: leaveChannel)
                    }.padding()
                }
            }
        }.onAppear(perform: joinChannel)
    }
    
    func joinChannel() {
        engine.contentView = self
        
        let agoraEngine = engine.agoraEngine
        agoraEngine.enableVideo()
        agoraEngine.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: AgoraVideoDimension640x360,
                frameRate: .fps15,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative
            )
        )
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = localSessionView.videoCanvas.rendererView
        videoCanvas.renderMode = .hidden
        agoraEngine.setupLocalVideo(videoCanvas)
        
        agoraEngine.joinChannel(byToken: Token, channelId: "swift", info: nil, uid: 0, joinSuccess: nil)
    }
    
    func muteLocalVideo() {
        engine.agoraEngine.muteLocalVideoStream(!self.isLocalVideoMuted)
//        localSessionView.setupMute(!self.isLocalVideoMuted)
        isLocalVideoMuted.toggle()
    }
    
    func muteLocalAudio() {
        engine.agoraEngine.muteLocalAudioStream(!self.isLocalAudioMuted)
        isLocalAudioMuted.toggle()
    }
    
    func switchCamera() {
        engine.agoraEngine.switchCamera()
    }
    
    func leaveChannel() {
        engine.agoraEngine.leaveChannel(nil)
        isInSession = false
    }
}

class VideoEngine: NSObject {
    lazy var agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    var contentView: ContentView?
}

extension VideoEngine: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        contentView?.isInSession = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = contentView?.remoteSessionView.videoCanvas.rendererView
        videoCanvas.renderMode = .hidden
        videoCanvas.uid = uid
        agoraEngine.setupRemoteVideo(videoCanvas)
        
        contentView?.isRemoteOnline = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        contentView?.isRemoteOnline = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        
    }
}

struct ButtonView : View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        return Image(imageName)
            .resizable()
            .frame(width: 60, height: 60)
            .tapAction(action)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
