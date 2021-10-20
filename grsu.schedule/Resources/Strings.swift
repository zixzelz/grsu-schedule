// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Address not found
  internal static let addressNotFoundMessage = L10n.tr("Localizable", "ADDRESS_NOT_FOUND_MESSAGE")
  /// Back
  internal static let anyScreenActionBack = L10n.tr("Localizable", "ANY_SCREEN_ACTION_BACK")
  /// Yandex Maps application is not installed
  internal static let applicationYandexMapNotInstalledMessage = L10n.tr("Localizable", "APPLICATION_YANDEX_MAP_NOT_INSTALLED_MESSAGE")
  /// Sign In
  internal static let authenticationActionLogin = L10n.tr("Localizable", "AUTHENTICATION_ACTION_LOGIN")
  /// Username
  internal static let authenticationFieldLogin = L10n.tr("Localizable", "AUTHENTICATION_FIELD_LOGIN")
  /// Back
  internal static let backBarButtonItemTitle = L10n.tr("Localizable", "BACK_BAR_BUTTON_ITEM_TITLE")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "CANCEL")
  /// Favorites
  internal static let favoriteNavigationBarTitle = L10n.tr("Localizable", "FAVORITE_NAVIGATION_BAR_TITLE")
  /// Favorites
  internal static let favoriteTabbarTitle = L10n.tr("Localizable", "FAVORITE_TABBAR_TITLE")
  /// Hostel №
  internal static let hostellNumberTitle = L10n.tr("Localizable", "HOSTELL_NUMBER_TITLE")
  /// Install
  internal static let installButton = L10n.tr("Localizable", "INSTALL_BUTTON")
  /// Loading Failed
  internal static let loadingFailedMessage = L10n.tr("Localizable", "LOADING_FAILED_MESSAGE")
  /// Map
  internal static let mapNavigationBarTitle = L10n.tr("Localizable", "MAP_NAVIGATION_BAR_TITLE")
  /// 
  internal static let myschedulesNavigationBarTitle = L10n.tr("Localizable", "MYSCHEDULES_NAVIGATION_BAR_TITLE")
  /// My
  internal static let myschedulesTabbarTitle = L10n.tr("Localizable", "MYSCHEDULES_TABBAR_TITLE")
  /// OK
  internal static let ok = L10n.tr("Localizable", "OK")
  /// RN 
  internal static let roomNumberTitle = L10n.tr("Localizable", "ROOM_NUMBER_TITLE")
  /// Group schedule
  internal static let scheduleActionMenuGroupSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_GROUP_SCHEDULE")
  /// Lecture hall
  internal static let scheduleActionMenuRoom = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_ROOM")
  /// Teacher info
  internal static let scheduleActionMenuTeacherInfo = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_INFO")
  /// Teacher schedule
  internal static let scheduleActionMenuTeacherSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_SCHEDULE")
  /// No schedule
  /// for the week
  internal static let scheduleListEmpty = L10n.tr("Localizable", "SCHEDULE_LIST_EMPTY")
  /// Select group:
  internal static let scheduleSelectGroupTitle = L10n.tr("Localizable", "SCHEDULE_SELECT_GROUP_TITLE")
  /// Subgroup:
  internal static let scheduleSubgroupTitle = L10n.tr("Localizable", "SCHEDULE_SUBGROUP_TITLE")
  /// Search
  internal static let searchBarPlaceholderTitle = L10n.tr("Localizable", "SEARCH_BAR_PLACEHOLDER_TITLE")
  /// Sign In
  internal static let studentActionLoginTitle = L10n.tr("Localizable", "STUDENT_ACTION_LOGIN_TITLE")
  /// Show
  internal static let studentActionShowScheduleTitle = L10n.tr("Localizable", "STUDENT_ACTION_SHOW_SCHEDULE_TITLE")
  /// Course
  internal static let studentFilterCourseTitle = L10n.tr("Localizable", "STUDENT_FILTER_COURSE_TITLE")
  /// Department
  internal static let studentFilterDepartmentTitle = L10n.tr("Localizable", "STUDENT_FILTER_DEPARTMENT_TITLE")
  /// Faculty
  internal static let studentFilterFacultyTitle = L10n.tr("Localizable", "STUDENT_FILTER_FACULTY_TITLE")
  /// Group
  internal static let studentFilterGroupTitle = L10n.tr("Localizable", "STUDENT_FILTER_GROUP_TITLE")
  /// Week
  internal static let studentFilterWeekTitle = L10n.tr("Localizable", "STUDENT_FILTER_WEEK_TITLE")
  /// Schedule filter
  internal static let studentNavigationBarTitle = L10n.tr("Localizable", "STUDENT_NAVIGATION_BAR_TITLE")
  /// Students
  internal static let studentTabbarTitle = L10n.tr("Localizable", "STUDENT_TABBAR_TITLE")
  /// Email
  internal static let teacherInfoEmailFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_EMAIL_FIELD_TITLE")
  /// Mobile
  internal static let teacherInfoMobileFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_MOBILE_FIELD_TITLE")
  /// Teacher
  internal static let teacherInfoNavigationBarTitle = L10n.tr("Localizable", "TEACHER_INFO_NAVIGATION_BAR_TITLE")
  /// Skype
  internal static let teacherInfoSkypeFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_SKYPE_FIELD_TITLE")
  /// No teachers
  internal static let teachersListEmpty = L10n.tr("Localizable", "TEACHERS_LIST_EMPTY")
  /// Teachers
  internal static let teachersNavigationBarTitle = L10n.tr("Localizable", "TEACHERS_NAVIGATION_BAR_TITLE")
  /// Teachers
  internal static let teachersTabbarTitle = L10n.tr("Localizable", "TEACHERS_TABBAR_TITLE")
  /// Sign Out
  internal static let userProfileActionSignout = L10n.tr("Localizable", "USER_PROFILE_ACTION_SIGNOUT")
  /// The user name cannot be empty
  internal static let usernameCannotBeEmptyMessage = L10n.tr("Localizable", "USERNAME_CANNOT_BE_EMPTY_MESSAGE")
  /// Login Failed
  internal static let usernameNotFoundHeader = L10n.tr("Localizable", "USERNAME_NOT_FOUND_HEADER")
  /// The username you entered is incorrect
  internal static let usernameNotFoundMessage = L10n.tr("Localizable", "USERNAME_NOT_FOUND_MESSAGE")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
