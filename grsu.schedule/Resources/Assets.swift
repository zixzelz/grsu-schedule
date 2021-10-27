// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let backgroundColor = ColorAsset(name: "BackgroundColor")
    internal static let lessonTitleColor = ColorAsset(name: "LessonTitleColor")
    internal static let navigationBarColor = ColorAsset(name: "NavigationBarColor")
    internal static let scheduleActiveLessonColor = ColorAsset(name: "ScheduleActiveLessonColor")
    internal static let schedulePageSelectedColor = ColorAsset(name: "SchedulePageSelectedColor")
    internal static let schedulePageUnselectedColor = ColorAsset(name: "SchedulePageUnselectedColor")
  }
  internal enum Images {
    internal static let calloutView = ImageAsset(name: "CalloutView")
    internal static let closeButton = ImageAsset(name: "CloseButton")
    internal static let backgroundColor = ColorAsset(name: "BackgroundColor")
    internal static let navigationBarColor = ColorAsset(name: "NavigationBarColor")
    internal static let scheduleActiveLessonColor = ColorAsset(name: "ScheduleActiveLessonColor")
    internal static let schedulePageSelectedColor = ColorAsset(name: "SchedulePageSelectedColor")
    internal static let schedulePageUnselectedColor = ColorAsset(name: "SchedulePageUnselectedColor")
    internal static let editIcon = ImageAsset(name: "EditIcon")
    internal static let editIconOk = ImageAsset(name: "EditIconOk")
    internal static let educationalMapMarker = ImageAsset(name: "EducationalMapMarker")
    internal static let emailIcon = ImageAsset(name: "EmailIcon")
    internal static let empty = ImageAsset(name: "Empty")
    internal static let favorite = ImageAsset(name: "Favorite")
    internal static let favoriteSelected = ImageAsset(name: "FavoriteSelected")
    internal static let grsuLogo = ImageAsset(name: "GRSULogo")
    internal static let grsu = ImageAsset(name: "Grsu")
    internal static let hostelMapMarker = ImageAsset(name: "HostelMapMarker")
    internal static let launchImage = ImageAsset(name: "LaunchImage")
    internal static let lecturer = ImageAsset(name: "Lecturer")
    internal static let lecturerSchedule = ImageAsset(name: "LecturerSchedule")
    internal static let lessonLocation = ImageAsset(name: "LessonLocation")
    internal static let mapTabBar = ImageAsset(name: "MapTabBar")
    internal static let messageIcon = ImageAsset(name: "MessageIcon")
    internal static let navigationBarEmptyStar = ImageAsset(name: "NavigationBarEmptyStar")
    internal static let navigationBarFillStar = ImageAsset(name: "NavigationBarFillStar")
    internal static let phoneIcon = ImageAsset(name: "PhoneIcon")
    internal static let photo20200 = ImageAsset(name: "Photo_20200")
    internal static let photo46750 = ImageAsset(name: "Photo_46750")
    internal static let skypeIcon = ImageAsset(name: "SkypeIcon")
    internal static let student = ImageAsset(name: "Student")
    internal static let students = ImageAsset(name: "Students")
    internal static let teacher = ImageAsset(name: "Teacher")
    internal static let teacherSchedule = ImageAsset(name: "TeacherSchedule")
    internal static let educationalBuilding1 = ImageAsset(name: "EducationalBuilding_1")
    internal static let educationalBuilding10 = ImageAsset(name: "EducationalBuilding_10")
    internal static let educationalBuilding11 = ImageAsset(name: "EducationalBuilding_11")
    internal static let educationalBuilding12 = ImageAsset(name: "EducationalBuilding_12")
    internal static let educationalBuilding2 = ImageAsset(name: "EducationalBuilding_2")
    internal static let educationalBuilding3 = ImageAsset(name: "EducationalBuilding_3")
    internal static let educationalBuilding4 = ImageAsset(name: "EducationalBuilding_4")
    internal static let educationalBuilding5 = ImageAsset(name: "EducationalBuilding_5")
    internal static let educationalBuilding6 = ImageAsset(name: "EducationalBuilding_6")
    internal static let educationalBuilding7 = ImageAsset(name: "EducationalBuilding_7")
    internal static let educationalBuilding8 = ImageAsset(name: "EducationalBuilding_8")
    internal static let educationalBuilding9 = ImageAsset(name: "EducationalBuilding_9")
    internal static let hostelBuilding2 = ImageAsset(name: "HostelBuilding_2")
    internal static let hostelBuilding3 = ImageAsset(name: "HostelBuilding_3")
    internal static let hostelBuilding4 = ImageAsset(name: "HostelBuilding_4")
    internal static let hostelBuilding5 = ImageAsset(name: "HostelBuilding_5")
    internal static let userLogo = ImageAsset(name: "UserLogo")
    internal static let userPlaceholderIcon = ImageAsset(name: "UserPlaceholderIcon")
    internal static let userTabBar = ImageAsset(name: "UserTabBar")
    internal static let logo = ImageAsset(name: "logo")
    internal static let settingsIcon = ImageAsset(name: "settings_icon")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
