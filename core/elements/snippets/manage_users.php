<?php
use CustomServices\Users;

require_once MODX_CORE_PATH . 'services/vendor/autoload.php';
/**
 * @var modX $modx
 * @var array $scriptProperties
 * @var SendIt $SendIt
 * @var string $method
 */
$service = new Users($modx);
$method = $scriptProperties['method'];
if(!method_exists($service, $method)){
    return $SendIt->error('Метод '.$method.' не найден', []);
}
$result = $service->$method($_POST, $scriptProperties);

if($SendIt){
    if($result['success']){
        return $SendIt->success($result['message'], $result['data']);
    }else{
        return $SendIt->error($result['message'], $result['data']);
    }
}
return $result;
