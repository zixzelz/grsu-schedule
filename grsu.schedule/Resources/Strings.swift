// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// Address not found
  static let addressNotFoundMessage = L10n.tr("Localizable", "ADDRESS_NOT_FOUND_MESSAGE")
  /// Back
  static let anyScreenActionBack = L10n.tr("Localizable", "ANY_SCREEN_ACTION_BACK")
  /// Yandex Maps application is not installed
  static let applicationYandexMapNotInstalledMessage = L10n.tr("Localizable", "APPLICATION_YANDEX_MAP_NOT_INSTALLED_MESSAGE")
  /// Sign In
  static let authenticationActionLogin = L10n.tr("Localizable", "AUTHENTICATION_ACTION_LOGIN")
  /// Username
  static let authenticationFieldLogin = L10n.tr("Localizable", "AUTHENTICATION_FIELD_LOGIN")
  /// Back
  static let backBarButtonItemTitle = L10n.tr("Localizable", "BACK_BAR_BUTTON_ITEM_TITLE")
  /// Cancel
  static let cancel = L10n.tr("Localizable", "CANCEL")
  /// Favorites
  static let favoriteNavigationBarTitle = L10n.tr("Localizable", "FAVORITE_NAVIGATION_BAR_TITLE")
  /// Favorites
  static let favoriteTabbarTitle = L10n.tr("Localizable", "FAVORITE_TABBAR_TITLE")
  /// Hostel №
  static let hostellNumberTitle = L10n.tr("Localizable", "HOSTELL_NUMBER_TITLE")
  /// Install
  static let installButton = L10n.tr("Localizable", "INSTALL_BUTTON")
  /// Loading Failed
  static let loadingFailedMessage = L10n.tr("Localizable", "LOADING_FAILED_MESSAGE")
  /// Карта
  static let mapNavigationBarTitle = L10n.tr("Localizable", "MAP_NAVIGATION_BAR_TITLE")
  /// 
  static let myschedulesNavigationBarTitle = L10n.tr("Localizable", "MYSCHEDULES_NAVIGATION_BAR_TITLE")
  /// My
  static let myschedulesTabbarTitle = L10n.tr("Localizable", "MYSCHEDULES_TABBAR_TITLE")
  /// OK
  static let ok = L10n.tr("Localizable", "OK")
  /// RN 
  static let roomNumberTitle = L10n.tr("Localizable", "ROOM_NUMBER_TITLE")
  /// Group schedule
  static let scheduleActionMenuGroupSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_GROUP_SCHEDULE")
  /// Lecture hall
  static let scheduleActionMenuRoom = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_ROOM")
  /// Teacher info
  static let scheduleActionMenuTeacherInfo = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_INFO")
  /// Teacher schedule
  static let scheduleActionMenuTeacherSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_SCHEDULE")
  /// No schedule\nfor the week
  static let scheduleListEmpty = L10n.tr("Localizable", "SCHEDULE_LIST_EMPTY")
  /// Select group:
  static let scheduleSelectGroupTitle = L10n.tr("Localizable", "SCHEDULE_SELECT_GROUP_TITLE")
  /// Subgroup:
  static let scheduleSubgroupTitle = L10n.tr("Localizable", "SCHEDULE_SUBGROUP_TITLE")
  /// Search
  static let searchBarPlaceholderTitle = L10n.tr("Localizable", "SEARCH_BAR_PLACEHOLDER_TITLE")
  /// Sign In
  static let studentActionLoginTitle = L10n.tr("Localizable", "STUDENT_ACTION_LOGIN_TITLE")
  /// Show
  static let studentActionShowScheduleTitle = L10n.tr("Localizable", "STUDENT_ACTION_SHOW_SCHEDULE_TITLE")
  /// Course
  static let studentFilterCourseTitle = L10n.tr("Localizable", "STUDENT_FILTER_COURSE_TITLE")
  /// Department
  static let studentFilterDepartmentTitle = L10n.tr("Localizable", "STUDENT_FILTER_DEPARTMENT_TITLE")
  /// Faculty
  static let studentFilterFacultyTitle = L10n.tr("Localizable", "STUDENT_FILTER_FACULTY_TITLE")
  /// Group
  static let studentFilterGroupTitle = L10n.tr("Localizable", "STUDENT_FILTER_GROUP_TITLE")
  /// Week
  static let studentFilterWeekTitle = L10n.tr("Localizable", "STUDENT_FILTER_WEEK_TITLE")
  /// Schedule filter
  static let studentNavigationBarTitle = L10n.tr("Localizable", "STUDENT_NAVIGATION_BAR_TITLE")
  /// Students
  static let studentTabbarTitle = L10n.tr("Localizable", "STUDENT_TABBAR_TITLE")
  /// Email
  static let teacherInfoEmailFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_EMAIL_FIELD_TITLE")
  /// Mobile
  static let teacherInfoMobileFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_MOBILE_FIELD_TITLE")
  /// Teacher
  static let teacherInfoNavigationBarTitle = L10n.tr("Localizable", "TEACHER_INFO_NAVIGATION_BAR_TITLE")
  /// Skype
  static let teacherInfoSkypeFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_SKYPE_FIELD_TITLE")
  /// No teachers
  static let teachersListEmpty = L10n.tr("Localizable", "TEACHERS_LIST_EMPTY")
  /// Teachers
  static let teachersNavigationBarTitle = L10n.tr("Localizable", "TEACHERS_NAVIGATION_BAR_TITLE")
  /// Teachers
  static let teachersTabbarTitle = L10n.tr("Localizable", "TEACHERS_TABBAR_TITLE")
  /// Sign Out
  static let userProfileActionSignout = L10n.tr("Localizable", "USER_PROFILE_ACTION_SIGNOUT")
  /// The user name cannot be empty
  static let usernameCannotBeEmptyMessage = L10n.tr("Localizable", "USERNAME_CANNOT_BE_EMPTY_MESSAGE")
  /// Login Failed
  static let usernameNotFoundHeader = L10n.tr("Localizable", "USERNAME_NOT_FOUND_HEADER")
  /// The username you entered is incorrect
  static let usernameNotFoundMessage = L10n.tr("Localizable", "USERNAME_NOT_FOUND_MESSAGE")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
