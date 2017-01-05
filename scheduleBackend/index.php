<?php
header('Content-Type: text/html; charset=utf-8');
require_once('engine/ScheduleAPI.php');
require_once('engine/Request.php');

$api = ScheduleAPI::getInstance();
$request = Request::getParsed();

echo $api->getData($request->method, $request->params, $request->format);