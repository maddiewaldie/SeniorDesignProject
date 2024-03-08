import SwiftUI
import PhotosUI

struct ProfileImage: View {
	let imageState: ProfileModel.ImageState
	
	var body: some View {
		switch imageState {
		case .success(let image):
			image.resizable()
		case .loading:
			ProgressView()
		case .empty:
			Image(systemName: "person.fill")
				.font(.system(size: 25))
				.foregroundColor(.white)
		case .failure:
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 25))
				.foregroundColor(.white)
		}
	}
}

struct CircularProfileImage: View {
	let imageState: ProfileModel.ImageState
	
	var body: some View {
		ProfileImage(imageState: imageState)
            .scaledToFill()
			.clipShape(Circle())
			.frame(width: 35, height: 35)
			.background {
				Circle().fill(
					LinearGradient(
						colors: [.lightTeal, .darkTeal],
						startPoint: .top,
						endPoint: .bottom
					)
				)
			}
	}
}

struct EditableCircularProfileImage: View {
	@ObservedObject var viewModel: ProfileModel
	
	var body: some View {
		CircularProfileImage(imageState: viewModel.imageState)
			.overlay(alignment: .bottomTrailing) {
				PhotosPicker(selection: $viewModel.imageSelection,
							 matching: .images,
							 photoLibrary: .shared()) {
					Image(systemName: "pencil.circle.fill")
						.symbolRenderingMode(.multicolor)
						.font(.system(size: 10))
						.foregroundColor(.accentColor)
				}
				.buttonStyle(.borderless)
			}
	}
}
