<?php
/**
 * Error class.
 */
class Error
{
	/**
	 * Errors list.
	 */
	private static $errors = array(
		// global errors
		'00000' => 'Неизвестная ошибка',
		'00001' => 'Указанный метод не существует',
		'00002' => 'Имя метода не указано',
		// 'getTeachers' errors
		'11001' => 'Параметр fields метода getTeachers содержит несуществующее имя поля',
		'11002' => 'Параметр sort метода getTeachers содержит несуществующее имя поля',
		'11003' => 'Параметр count метода getTeachers должен быть целым положительным числом',
		'11004' => 'Параметр offset метода getTeachers должен быть целым положительным числом',
		'11005' => 'Параметр teacherId метода getTeachers должен быть целым положительным числом',
		'11006' => 'По заданному в методе getTeachers параметру teacherId не найден преподаватель',
		// 'getTeacherSchedule' errors
		'12001' => 'Не указан обязательный параметр teacherId метода getTeacherSchedule',
		'12002' => 'Параметр teacherId метода getTeacherSchedule должен быть целым положительным числом',
		'12003' => 'По заданному в методе getTeacherSchedule параметру teacherId не найден преподаватель',
		'12004' => 'Параметр dateStart метода getTeacherSchedule должен быть строкой в формате “dd.mm.yyyy” и являться существующей датой',
		'12005' => 'Параметр dateEnd метода getTeacherSchedule должен быть строкой в формате “dd.mm.yyyy” и являться существующей датой',
		// 'getFaculties' errors
		//
		// 'getDepartments' errors
		//
		// 'getGroups' errors
		'23001' => 'Не указан обязательный параметр facultyId метода getGroups',
		'23002' => 'Параметр facultyId метода getGroups должен быть целым положительным числом',
		'23003' => 'По заданному в методе getGroups параметру facultyId не найден факультет',
		'23004' => 'Не указан обязательный параметр departmentId метода getGroups',
		'23005' => 'Параметр departmentId метода getGroups должен быть целым положительным числом',
		'23006' => 'По заданному в методе getGroups параметру departmentId не найдена форма обучения',
		'23007' => 'Не указан обязательный параметр course метода getGroups',
		'23008' => 'Параметр course метода getGroups должен быть целым положительным числом',
		'23009' => 'Курс, заданный параметром course в методе getGroups, не существует',
		// 'getGroupSchedule' errors
		'24001' => 'Не указан обязательный параметр groupId метода getGroupSchedule',
		'24002' => 'Параметр groupId метода getGroupSchedule должен быть целым положительным числом',
		'24003' => 'По заданному в методе getGroupSchedule параметру groupId не найдена группа',
		'24004' => 'Параметр dateStart метода getGroupSchedule должен быть строкой в формате “dd.mm.yyyy” и являться существующей датой',
		'24005' => 'Параметр dateEnd метода getGroupSchedule должен быть строкой в формате “dd.mm.yyyy” и являться существующей датой',
	);
	
	/**
	 * Method to get error object.
	 *
	 * @param	string	$code	error code
	 *
	 * @return	object	error object
	 */
	public static function _($code, $details = '')
	{
		$code = array_key_exists($code, self::$errors) ? $code : '00000';
		
		$obj = new stdClass();
		$obj->error = new stdClass();
		$obj->error->code = $code;
		$obj->error->desc = self::$errors[$code];
		if ($details) {
			$obj->error->details = $details;
		}
		return $obj;
	}
}