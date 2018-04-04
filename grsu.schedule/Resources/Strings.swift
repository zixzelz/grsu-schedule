// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// Назад
  static let anyScreenActionBack = L10n.tr("Localizable", "ANY_SCREEN_ACTION_BACK")
  /// Войти
  static let authenticationActionLogin = L10n.tr("Localizable", "AUTHENTICATION_ACTION_LOGIN")
  /// Логин
  static let authenticationFieldLogin = L10n.tr("Localizable", "AUTHENTICATION_FIELD_LOGIN")
  /// Back
  static let backBarButtonItemTitle = L10n.tr("Localizable", "BACK_BAR_BUTTON_ITEM_TITLE")
  /// Отмена
  static let cancel = L10n.tr("Localizable", "CANCEL")
  /// Избранное
  static let favoriteNavigationBarTitle = L10n.tr("Localizable", "FAVORITE_NAVIGATION_BAR_TITLE")
  /// Избранное
  static let favoriteTabbarTitle = L10n.tr("Localizable", "FAVORITE_TABBAR_TITLE")
  /// Карта
  static let mapNavigationBarTitle = L10n.tr("Localizable", "MAP_NAVIGATION_BAR_TITLE")
  /// 
  static let myschedulesNavigationBarTitle = L10n.tr("Localizable", "MYSCHEDULES_NAVIGATION_BAR_TITLE")
  /// Мое
  static let myschedulesTabbarTitle = L10n.tr("Localizable", "MYSCHEDULES_TABBAR_TITLE")
  /// OK
  static let ok = L10n.tr("Localizable", "OK")
  /// Расписание группы
  static let scheduleActionMenuGroupSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_GROUP_SCHEDULE")
  /// Аудитория
  static let scheduleActionMenuRoom = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_ROOM")
  /// Преподаватель
  static let scheduleActionMenuTeacherInfo = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_INFO")
  /// Расписание преп.
  static let scheduleActionMenuTeacherSchedule = L10n.tr("Localizable", "SCHEDULE_ACTION_MENU_TEACHER_SCHEDULE")
  /// Нет расписания\nна данную неделю
  static let scheduleListEmpty = L10n.tr("Localizable", "SCHEDULE_LIST_EMPTY")
  /// Поиск
  static let searchBarPlaceholderTitle = L10n.tr("Localizable", "SEARCH_BAR_PLACEHOLDER_TITLE")
  /// Войти
  static let studentActionLoginTitle = L10n.tr("Localizable", "STUDENT_ACTION_LOGIN_TITLE")
  /// Показать
  static let studentActionShowScheduleTitle = L10n.tr("Localizable", "STUDENT_ACTION_SHOW_SCHEDULE_TITLE")
  /// Курс
  static let studentFilterCourseTitle = L10n.tr("Localizable", "STUDENT_FILTER_COURSE_TITLE")
  /// Форма обучения
  static let studentFilterDepartmentTitle = L10n.tr("Localizable", "STUDENT_FILTER_DEPARTMENT_TITLE")
  /// Факультет
  static let studentFilterFacultyTitle = L10n.tr("Localizable", "STUDENT_FILTER_FACULTY_TITLE")
  /// Группа
  static let studentFilterGroupTitle = L10n.tr("Localizable", "STUDENT_FILTER_GROUP_TITLE")
  /// Неделя
  static let studentFilterWeekTitle = L10n.tr("Localizable", "STUDENT_FILTER_WEEK_TITLE")
  /// Фильтр
  static let studentNavigationBarTitle = L10n.tr("Localizable", "STUDENT_NAVIGATION_BAR_TITLE")
  /// Студенты
  static let studentTabbarTitle = L10n.tr("Localizable", "STUDENT_TABBAR_TITLE")
  /// Email
  static let teacherInfoEmailFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_EMAIL_FIELD_TITLE")
  /// Сотовый
  static let teacherInfoMobileFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_MOBILE_FIELD_TITLE")
  /// Преподаватель
  static let teacherInfoNavigationBarTitle = L10n.tr("Localizable", "TEACHER_INFO_NAVIGATION_BAR_TITLE")
  /// Skype
  static let teacherInfoSkypeFieldTitle = L10n.tr("Localizable", "TEACHER_INFO_SKYPE_FIELD_TITLE")
  /// Нет преподавателей
  static let teachersListEmpty = L10n.tr("Localizable", "TEACHERS_LIST_EMPTY")
  /// Преподаватели
  static let teachersNavigationBarTitle = L10n.tr("Localizable", "TEACHERS_NAVIGATION_BAR_TITLE")
  /// Преподаватели
  static let teachersTabbarTitle = L10n.tr("Localizable", "TEACHERS_TABBAR_TITLE")
  /// Выход
  static let userProfileActionSignout = L10n.tr("Localizable", "USER_PROFILE_ACTION_SIGNOUT")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
