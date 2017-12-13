<?php
/**
 * @Author: haodaquan
 * @Date:   2017-12-13 16:38:16
 * @Last Modified by:   haodaquan
 * @Last Modified time: 2017-12-13 16:42:37
 */

$link = new mysqli('localhost', 'root','','mysql','3306');
if ($link) {
	$password = randstr(10);
    $link->query("SET character_set_connection=gbk,character_set_results=gbk,character_set_client=binary");
    $link->query("SET sql_mode=''");
    $link->query("set password for 'root'@'localhost' = PASSWORD('{$password}')");
    $link->query("delete from user where user = '' or password = ''");
    $link->query("flush privileges");
}

file_put_contents('account.log', str_replace('mysql_password', $password, file_get_contents('account.log')));

function randstr($length) {
	return substr(md5(num_rand($length)), mt_rand(0, 32 - $length), $length);
}
function num_rand($length) {
	mt_srand((double) microtime() * 1000000);
	$randVal = mt_rand(1, 9);
	for ($i = 1; $i < $length; $i++) {
		$randVal .= mt_rand(0, 9);
	}
	return $randVal;
}
