<?php

if (!class_exists('\PDO'))
{
    throw new Exception('PDO_MYSQL extension not installed');
}

if (!class_exists('\Redis'))
{
    throw new Exception('REDIS extension not installed');
}

if (!function_exists('pcntl_exec'))
{
    throw new Exception('PCNTL extension not installed');
}

return true;
