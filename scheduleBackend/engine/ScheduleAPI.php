<?php
require_once('engine/Model.php');
require_once('engine/Converter.php');
/**
 * Schedule API class.
 */
class ScheduleAPI
{
	/**
	 * Schedule API instance.
	 */
	private static $_instance = null;

	private function __construct() {}
	
	private function __clone() {}
	
	private function __wakeup() {}
	
	/**
	 * Method to get instance of Schedule API.
	 *
	 * @return	ScheduleAPI		Schedule API instance
	 */
    public static function getInstance() 
	{
        if ( empty(self::$_instance) ) {
            self::$_instance = new self();
        }
		
        return self::$_instance;
    }
	
	/**
	 * Method to get requested data from database.
	 *
	 * @param	string	$method		method name
	 * @param	array	$params		method params
	 * @param	string	$format		requested data format
	 *
	 * @return	string	requested data
	 */
	public function getData($method, $params = array(), $format = 'json')
	{
		$model = new Model();
		$data = $model->$method($params);
		$converter = new Converter();
		return $converter->to($format, $data);
	}
}