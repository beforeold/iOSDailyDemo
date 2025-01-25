import SwiftUI

struct ContentView: View {
  @State var image: UIImage = UIImage()

  var body: some View {
    print("issupported", UIImagePickerController.isSourceTypeAvailable(.camera))

    return ImagePicker(selectedImage: $image)
  }
}

public struct ImagePicker: UIViewControllerRepresentable {
  let cameraDevice: UIImagePickerController.CameraDevice
  @Binding var selectedImage: UIImage
  var completion: ([UIImage]) -> Void = { _ in }

  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .camera
    imagePicker.cameraDevice = cameraDevice
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  public init(
    cameraDevice: UIImagePickerController.CameraDevice = .front,
    selectedImage: Binding<UIImage>,
    completion: @escaping ([UIImage]) -> Void = { _ in }
  ) {
    self.cameraDevice = cameraDevice
    self._selectedImage = selectedImage
    self.completion = completion
  }

}

extension ImagePicker {

  public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    public func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      let images: [UIImage]
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        parent.selectedImage = image
        images = [image]
      } else {
        images = []
      }
      self.parent.completion(images)
      picker.dismiss(animated: true)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      self.parent.completion([])
      picker.dismiss(animated: true)
    }

  }

  public func makeCoordinator() -> Coordinator { Coordinator(self) }

}

#Preview {
  @Previewable @State var image: UIImage = UIImage()
  ImagePicker(selectedImage: $image)
}
