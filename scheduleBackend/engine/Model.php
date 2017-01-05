<?php
require_once('engine/Error.php');
require_once('engine/Configuration.php');
/**
 * Schedule API model class.
 */
class Model
{
	/**
	 * Autocall overload method.
	 */
	public function __call($name, $args)
	{
		if (!$name) {
			return Error::_('00002');
		} else if ( method_exists($this, strtolower($name)) ) {
			return $this->$name($args[0]);
		} else {
			return Error::_('00001');
		}
	}
	
	/**
	 * Method to get teachers list.
	 */
	private function getTeachers($params)
	{
		$cfg = Configuration::getInstance();
		$allowedTeacherFields = $cfg->get('allowedTeacherFields');
	
		// extended
		if ( isset($params['extended']) && $params['extended'] != 'false' ) {
			$extended = (bool)$params['extended'];
		} else {
			$extended = false;
		}
		
		// fields
		if ($extended) {
			$fields = $allowedTeacherFields;
		} else {
			if ( isset($params['fields']) ) {
				$fields = array_filter(array_unique(explode(',', $params['fields'])));
				foreach ($fields as $f) {
					if ( $f && !in_array($f, $allowedTeacherFields) ) {
						return Error::_('11001', $f);
					}
				}
				if ( !in_array('id', $fields) ) {
					array_unshift($fields, 'id');
				}
			} else {
				$fields = $cfg->get('defaultTeacherFields');
			}
		}
		
		// teacherId
		if ( isset($params['teacherid']) ) {
			$teacherId = $params['teacherid'];
			if ( !ctype_digit($teacherId) || (int)$teacherId < 0 ) {
				return Error::_('11005');
			}
			$teacherId = (int)$teacherId;
		} else {
			$teacherId = 0;
		}
		// TODO teacher exists check (11006)
		
		// sort
		$sort = array();
		if (!$teacherId) {
			$sortFields = array();
			if ( isset($params['sort']) ) {
				$pairs = array_filter(array_unique(explode(',', $params['sort'])));
				foreach ($pairs as $p) {
					$pair = array_filter(array_unique(explode('.', $p)));
					$field = isset($pair[0]) ? $pair[0] : '';
					if ( in_array($field, $sortFields) ) {
						continue;
					}
					$sortFields[] = $field;
					if ( $field && !in_array($field, $allowedTeacherFields) ) {
						return Error::_('11002', $field);
					}
					$direction = isset($pair[1]) ? $pair[1] : '';
					if ( !in_array($direction, $cfg->get('allowedSortDirections')) ) {
						$direction = $cfg->get('defaultSortDirection');
					}
					$sort[] = "{$field} {$direction}";
				}
			}
		}
		
		// count
		$count = 0;
		if (!$teacherId) {
			if ( isset($params['count']) ) {
				$count = $params['count'];
				if ( !ctype_digit($count) || (int)$count < 0 ) {
					return Error::_('11003');
				}
				$count = (int)$count;
			}
		}
		
		// offset
		$offset = 0;
		if (!$teacherId) {
			if ( isset($params['offset']) ) {
				$offset = $params['offset'];
				if ( !ctype_digit($offset) || (int)$offset < 0 ) {
					return Error::_('11004');
				}
				$offset = (int)$offset;
			}
		}
		
		return "teachers<br>extended = [{$extended}]<br>fields = [" . implode(',', $fields) . "]<br>sort = [" . implode(',', $sort) . "]<br>count = [{$count}]<br>offset = [{$offset}]<br>teacherId = [{$teacherId}]";
	}
	
	/**
	 * Method to get schedule for a teacher.
	 */
	private function getTeacherSchedule($params)
	{
		// teacherId
		if ( isset($params['teacherid']) ) {
			$teacherId = $params['teacherid'];
			if ( !ctype_digit($teacherId) || (int)$teacherId < 0 ) {
				return Error::_('12002');
			}
			$teacherId = (int)$teacherId;
		} else {
			return Error::_('12001');
		}
		// TODO teacher exists check (12003)
		
		// dateStart
		if ( isset($params['datestart']) ) {
			$dateStart = trim($params['datestart']);
			$parts = explode('.', $dateStart);
			if ( count($parts) != 3 || !checkdate($parts[1], $parts[0], $parts[2]) ) {
				return Error::_('12004');
			}
		} else {
			$dateStart = '';
		}
		
		// dateEnd
		if ( isset($params['dateend']) ) {
			$dateEnd = trim($params['dateend']);
			$parts = explode('.', $dateEnd);
			if ( count($parts) != 3 || !checkdate($parts[1], $parts[0], $parts[2]) ) {
				return Error::_('12005');
			}
		} else {
			$dateEnd = '';
		}
		
		if ( $dateStart && $dateEnd && strtotime($dateStart) > strtotime($dateEnd) ) {
			$t = $dateStart;
			$dateStart = $dateEnd;
			$dateEnd = $t;
		}
	
		return "teacherSchedule<br>teacherId = [{$teacherId}]<br>dateStart = [{$dateStart}]<br>dateEnd = [{$dateEnd}]";
	}
	
	/**
	 * Method to get faculties list.
	 */
	private function getFaculties($params)
	{
		return 'faculties';
	}
	
	/**
	 * Method to get departments list.
	 */
	private function getDepartments($params)
	{
		return 'departments';
	}
	
	/**
	 * Method to get groups list.
	 */
	private function getGroups($params)
	{
		// facultyId
		if ( isset($params['facultyid']) ) {
			$facultyId = $params['facultyid'];
			if ( !ctype_digit($facultyId) || (int)$facultyId < 0 ) {
				return Error::_('23002');
			}
			$facultyId = (int)$facultyId;
		} else {
			return Error::_('23001');
		}
		// TODO faculty exists check (23003)
		
		// departmentId
		if ( isset($params['departmentid']) ) {
			$departmentId = $params['departmentid'];
			if ( !ctype_digit($departmentId) || (int)$departmentId < 0 ) {
				return Error::_('23005');
			}
			$departmentId = (int)$departmentId;
		} else {
			return Error::_('23004');
		}
		// TODO department exists check (23006)
		
		// course
		if ( isset($params['course']) ) {
			$course = $params['course'];
			if ( !ctype_digit($course) || (int)$course < 0 ) {
				return Error::_('23008');
			}
			$course = (int)$course;
		} else {
			return Error::_('23007');
		}
		// TODO course exists check (23009)
	
		return "groups<br>facultyId = [{$facultyId}]<br>departmentId = [{$departmentId}]<br>course = [{$course}]";
	}
	
	/**
	 * Method to get schedule for a group.
	 */
	private function getGroupSchedule($params)
	{
		// groupId
		if ( isset($params['groupid']) ) {
			$groupId = $params['groupid'];
			if ( !ctype_digit($groupId) || (int)$groupId < 0 ) {
				return Error::_('24002');
			}
			$groupId = (int)$groupId;
		} else {
			return Error::_('24001');
		}
		// TODO group exists check (24003)
		
		// dateStart
		if ( isset($params['datestart']) ) {
			$dateStart = trim($params['datestart']);
			$parts = explode('.', $dateStart);
			if ( count($parts) != 3 || !checkdate($parts[1], $parts[0], $parts[2]) ) {
				return Error::_('24004');
			}
		} else {
			$dateStart = '';
		}
		
		// dateEnd
		if ( isset($params['dateend']) ) {
			$dateEnd = trim($params['dateend']);
			$parts = explode('.', $dateEnd);
			if ( count($parts) != 3 || !checkdate($parts[1], $parts[0], $parts[2]) ) {
				return Error::_('24005');
			}
		} else {
			$dateEnd = '';
		}
		
		if ( $dateStart && $dateEnd && strtotime($dateStart) > strtotime($dateEnd) ) {
			$t = $dateStart;
			$dateStart = $dateEnd;
			$dateEnd = $t;
		}
	
		return "groupSchedule<br>groupId = [{$groupId}]<br>dateStart = [{$dateStart}]<br>dateEnd = [{$dateEnd}]";
	}
}