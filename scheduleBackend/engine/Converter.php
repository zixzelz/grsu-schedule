<?php
require_once('engine/Error.php');
/**
 * Data converter class.
 */
class Converter
{
	/**
	 * Autocall overload method.
	 */
	public function __call($name, $args)
	{
		if ( method_exists($this, strtolower($name)) ) {
			return $this->$name($args[0]);
		} else {
			throw new Exception("Unknown method Converter->{$name}");
		}
	}
	
	/**
	 * Method to automatically call converter method by name.
	 *
	 * @param	string	$format		converting format
	 * @param	object	$data		object to convert
	 *
	 * @return	mixed	converted data
	 */
	public function to($format, $data)
	{
		$name = "to{$format}";
		return $this->$name($data);
	}
	
	/**
	 * Method to convert data object to JSON.
	 *
	 * @param	object	$data	object to convert
	 *
	 * @return	json	converted data
	 */
	private function toJSON($data)
	{
		return json_encode($data, JSON_UNESCAPED_UNICODE);
	}
	
	/**
	 * Method to convert data object to XML.
	 *
	 * @param	object	$data	object to convert
	 *
	 * @return	xml		converted data
	 */
	private function toXML($data)
	{
		return $data; // TODO convert to XML
	}
}