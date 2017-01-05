<?php
require_once('engine/Configuration.php');
/**
 * Request class.
 */
class Request
{
	/**
	 * Method to get raw request data.
	 *
	 * @return	string	request string
	 */
	public static function getRaw()
	{
		return $_SERVER['REQUEST_URI'];
	}
	
	/**
	 * Method to get parsed request data.
	 *
	 * Method parse request string and returns object with three fields:
	 * 'method' contains method name string,
	 * 'params' contains method parameters array,
	 * 'format' contains requested data format string.
	 *
	 * @return	object	request data
	 */
	public static function getParsed()
	{
		$data = new stdClass();
		
		$request = strtolower(self::getRaw());
		$request = trim($request, '/');
		$request = explode('/', $request);
		$request = explode('?', $request[0]);
		
		$data->method = isset($request[0]) ? $request[0] : '';
		
		$params = isset($request[1]) ? explode('&',$request[1]) : array();
		$data->params = array();
		foreach ($params as $pair) {
			$pair = explode('=', $pair);
			$k = $pair[0];
			$v = isset($pair[1]) ? $pair[1] : '';
			$data->params[$k] = $v;
		}
		
		$data->format = isset($data->params['format']) ? $data->params['format'] : '';
		$cfg = Configuration::getInstance();
		if ( !$data->format || !in_array($data->format, $cfg->get('allowedFormats')) ) {
			$data->format = $cfg->get('defaultFormat');
		}
		
		return $data;
	}
}