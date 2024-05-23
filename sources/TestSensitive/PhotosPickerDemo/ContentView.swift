/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The sample app's primary view that configures an inline Photos picker.
*/

import SwiftUI
import PhotosUI

/// A view that defines the app's user interface.
struct ContentView: View {
    
    /// A view model that provides the Photos picker with a selection.
    @StateObject private var viewModel = ContentViewModel()
    
    /// A body property for the app's UI.
    var body: some View {
        NavigationStack {
            VStack {
                
                // Define a list for photos and descriptions.
                ImageList(viewModel: viewModel)
                
                // Define the app's Photos picker.
                PhotosPicker(
                    selection: $viewModel.selection,
                    
                    // Enable the app to dynamically respond to user adjustments.
                    selectionBehavior: .continuousAndOrdered,
                    matching: .images,
                    preferredItemEncoding: .current,
                    photoLibrary: .shared()
                ) {
                    Text("Select Photos")
                }
                
                // Configure a half-height Photos picker.
                .photosPickerStyle(.inline)
                
                // Disable the cancel button for an inline use case.
                .photosPickerDisabledCapabilities(.selectionActions)
                
                // Hide padding around all edges in the picker UI.
                .photosPickerAccessoryVisibility(.hidden, edges: .all)
                .ignoresSafeArea()
                .frame(height: 200)
            }
            .navigationTitle("Image Description")
            .ignoresSafeArea(.keyboard)
        }
    }
}

/// A view that lists selected photos and their descriptions.
struct ImageList: View {
    
    /// A view model for the list.
    @ObservedObject var viewModel: ContentViewModel
    
    /// A container view for the list.
    var body: some View {
        
        // Display a stub image if the Photos picker lacks a selection.
        if viewModel.attachments.isEmpty {
            Spacer()
            Image(systemName: "text.below.photo")
                .font(.system(size: 150))
                .opacity(0.2)
            Spacer()
        } else {
            // Create a row for each selected photo in the picker.
            List(viewModel.attachments) { imageAttachment in
                ImageAttachmentView(imageAttachment: imageAttachment)
            }.listStyle(.plain)
        }
    }
}

/// A row item that displays a photo and a description.
struct ImageAttachmentView: View {
    
    /// An image that a person selects in the Photos picker.
    @ObservedObject var imageAttachment: ContentViewModel.ImageAttachment
    
    /// A container view for the row.
    var body: some View {
        HStack {
            
            // Define text that describes a selected photo.
            TextField("Image Description", text: $imageAttachment.imageDescription)
            
            // Add space after the description.
            Spacer()
            
            // Display the image that the text describes.
            switch imageAttachment.imageStatus {
            case .finished(let image):
                image.resizable().aspectRatio(contentMode: .fit).frame(height: 100)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            default:
                ProgressView()
            }
        }.task {
            // Asynchronously display the photo.
            await imageAttachment.loadImage()
        }
    }
}
