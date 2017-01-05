<?php
/**
 * Configuration class.
 */
class Configuration
{
	/**
	 * Configuration instance.
	 */
	private static $_instance = null;

	private function __construct() {}
	
	private function __clone() {}
	
	private function __wakeup() {}
	
	/**
	 * Configuration data.
	 */
	private $data = array(
		'defaultFormat' => 'json',
		'allowedFormats' => array('json', 'xml'),
		//
		'defaultTeacherFields' => array('id', 'fullname'),
		'allowedTeacherFields' => array(
			'id', 'name', 'surname', 'patronym', 'post', 
			'phone', 'photo', 'desc', 'email', 'skype'
		),
		'defaultSortDirection' => 'asc',
		'allowedSortDirections' => array('asc', 'desc'),
	);
	
	/**
	 * Method to get instance of Configuration.
	 *
	 * @return	Configuration	Configuration instance
	 */
    public static function getInstance() 
	{
        if ( empty(self::$_instance) ) {
            self::$_instance = new self();
        }
		
        return self::$_instance;
    }
	
	/**
	 * Method to get constant value by key.
	 *
	 * @param	string	$key	key
	 *
	 * @return	mixed	value
	 */
	public function get($key)
	{
		return $this->data[$key];
	}
}