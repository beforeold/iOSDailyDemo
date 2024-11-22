import AVFoundation
import Foundation

class AudioRecorder {
  private var audioRecorder: AVAudioRecorder?

  func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])
      try audioSession.setActive(true)
    } catch {
      print("Failed to set up audio session: \(error)")
    }
  }

  func startRecording() {
    setupAudioSession()

    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let audioFileURL = documentPath.appendingPathComponent("recording.m4a")

    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 2,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
      audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
      audioRecorder?.prepareToRecord()
      audioRecorder?.record()
    } catch {
      print("Failed to start recording: \(error)")
    }
  }

  func stopRecording() {
    audioRecorder?.stop()
    audioRecorder = nil
  }
}
